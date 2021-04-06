let oldContainerHistory = []
let currentContainer = "home";
let contactList = [];
let gpsFilters = [];
let keyFilters = [];
let gurgleEntries = [];
let manageGroup = "";
let playerId = 0;

let isSprint = false;
let curLap = 0;
let maxLaps = 0;
let maxCheckpoints = 0;
let curCheckpoint = 0;
let startTime = 0;
let previousLapTime = 0;
let currentStartTime = 0;
let fastestLapTime = 0;
let overallLapTime = 0;
let drawRaceStatsIntervalId = 0;
let races = {};
let maps = {};

/* Call info */
let currentCallState = 0;
let currentCallInfo = "";

const callStates = {
    0: "isNotInCall",
    1: "isDialing",
    2: "isReceivingCall",
    3: "isCallInProgress"
}

var decodeEntities = (function () {
    // this prevents any overhead from creating the object each time
    var element = document.createElement('div');

    function decodeHTMLEntities(str) {
        if (str && typeof str === 'string') {
            // strip script/html tags
            str = str.replace(/<script[^>]*>([\S\s]*?)<\/script>/gmi, '');
            str = str.replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gmi, '');
            element.innerHTML = str;
            str = element.textContent;
            element.textContent = '';
        }

        return str;
    }

    return decodeHTMLEntities;
})();

const calendarFormatDate = {
    sameDay: '[Today at] HH:mm',
    nextDay: '[Tomorrow at] HH:mm',
    nextWeek: 'dddd [at] HH:mm',
    lastDay: '[Yesterday at] HH:mm',
    lastWeek: '[Last] dddd [at] HH:mm',
    sameElse: 'YYYY-MM-DD HH:mm:ss'
}

moment.updateLocale('en', {
    relativeTime: {
        past: function (input) {
            return input === 'now'
                ? input
                : input + ' ago'
        },
        s: 'now',
        future: "in %s",
        ss: '%ds',
        m: "1m",
        mm: "%dm",
        h: "1h",
        hh: "%dh",
        d: "1d",
        dd: "%dd",
        M: "1mo",
        MM: "%dmo",
        y: "1y",
        yy: "%dy"
    }
});

var debounce = function (func, wait, immediate) {
    var timeout;
    return function () {
        var context = this, args = arguments;
        var later = function () {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
};

$(document).ready(function () {
    $('.collapsible').collapsible();
    $('.modal').modal();

    $.post('http://phone/getWeather', JSON.stringify({}));

    setInterval(function () {
        $.post('http://phone/getWeather', JSON.stringify({}));
    }, 60 * 1000);

    /* This handles keyEvents - ESC etc */
    document.onkeyup = function (data) {
        // If Key == ESC -> Close Phone
        if (data.which == 27) {
            $.post('http://phone/close', JSON.stringify({}));
        }
    }

    $(".phone-screen").on('click', '.phone-button', function (e) {
        var action = $(this).data('action');
        var actionButton = $(this).data('action-button');
        if (actionButton !== undefined) {
            switch (actionButton) {
                case "home":
                    if (currentContainer !== "home") {
                        openContainer('home');
                    }
                    break;
                case "back":
                    if (oldContainerHistory.length > 0)
                        openContainer(oldContainerHistory.pop(), null, currentContainer);
                    break;
                case "browser":
                    openBrowser($(this).data('site'));
                    break;
            }
        }
        if (action !== undefined) {
            switch (action) {
                case "yellow-pages-delete":
                    $.post('http://phone/deleteYP', JSON.stringify({}));
                    break;
                case "racing-create":
                    $('racing-map-creation').fadeIn(150);
                    break;
                case "newPostSubmit":
                    e.preventDefault();
                    $.post('http://phone/newPostSubmit', JSON.stringify({
                        advert: escapeHtml($("#yellow-pages-form #yellow-pages-form-advert").val())
                    }));
                    $("#yellow-pages-form #yellow-pages-form-advert").attr("style", "").val('')
                    break;
                case "group-manage":
                    $.post('http://phone/manageGroup', JSON.stringify({ GroupID: $(this).data('action-data') }));
                    break;
                case "btnTaskGang":
                    manageGroup = $(this).data('action-data');
                    $.post('http://phone/btnTaskGang', JSON.stringify({}));
                    break;
                case "group-manage-pay-external":
                    $('#group-manage-pay-modal').modal('open');
                    $('#group-manage-pay-form').trigger('reset');
                    $('#group-manage-pay-modal #group-manage-id').prop('disabled', false);
                    M.updateTextFields();
                    break;
                case "group-manage-hire-external":
                    $('#group-manage-rank-modal').modal('open');
                    $('#group-manage-rank-form').trigger('reset');
                    $('#group-manage-rank-modal #group-manage-rank-id').prop('disabled', false);
                    M.updateTextFields();
                    break;
                case "nopixel-radio":
                    openRadio();
                    break;
                case "getCallHistory":
                    if (callStates[currentCallState] === "isCallInProgress" && currentContainer !== "incoming-call")
                        openContainer("incoming-call");
                    else
                        $.post('http://phone/' + action, JSON.stringify({}));
                    break;
                case "dabcoin":
                    openBrowser('http://nopixel.online/dabcoin/login.php');
                    break;
                default:
                    $.post('http://phone/' + action, JSON.stringify({}));
                    break;
            }
        }
    });

    window.addEventListener('message', function (event) {
        var item = event.data;

        if (item.newContact === true) {
            addContact(item.contact);
        }

        if (item.removeContact === true) {
            removeContact(item.contact);
        }

        if (item.emptyContacts === true) {
            contactList = [];
            $(".contacts-entries").empty();
        }

        if (item.openPhone === true) {
            openPhoneShell();
            playerId = item.playerId;
            $('.status-bar-player-id').text(item.playerId);
            openContainer("home")
            if(callStates[currentCallState] !== "isNotInCall") {
                phoneCallerScreenSetup()
            }
        }

        if (item.openPhone === false) {
            closePhoneShell();
            $('#browser').fadeOut(300);
            closeContainer("home");
        }

        if (item.isRealEstateAgent === true) {
            $('.btn-real-estate').hide().fadeIn(150);
        }

        if (item.hasDecrypt === true) {
            $('.btn-decrypt').hide().fadeIn(150);
        }

        if (item.hasDecrypt2 === true) {
            $('.btn-vpn').hide().fadeIn(150);
        }

        if (item.hasTrucker === true) {
            $('.btn-delivery-job').hide().fadeIn(150);
        }

        switch (item.openSection) {
            case "timeheader":
                $(".status-bar-time").empty();
                $(".status-bar-time").html(item.timestamp);
                break;
            case "server-time":
                setBatteryLevel(item.serverTime);
                break;
            case "notificationsYP":
                $(".yellow-pages-entries").empty();
                if (item.list && Object.keys(item.list).length > 0) {
                    for (let message of item.list) {
                        if (message) {
                            addYellowPage(message);
                        }
                    }
                }
                openContainer("yellow-pages");
                break;
            case "messages":
                $(".messages-entries").empty();
                if (item.list && Object.keys(item.list).length > 0) {
                    for (let message of item.list) {
                        if (message && message.receiver && message.message) {
                            addMessage(message, item.clientNumber);
                        }
                    }
                }
                $('.notification-sms').fadeOut(150);
                openContainer("messages");
                break;
            case "messageRead":
                $(".message-entries").empty();
                $(".message-recipient").empty();
                $(".message-recipient").append(item.displayName);
                if (item.messages && Object.keys(item.messages).length > 0) {
                    for (let message of item.messages) {
                        if (message && message.receiver && message.message) {
                            addMessageRead(message, item.clientNumber, item.displayName);
                        }
                    }
                }
                openContainer("message");
                break;
            case "messagesOther":
                $(".messages-entries").empty();
                if (item.list && Object.keys(item.list).length > 0) {
                    for (let message of item.list) {
                        if (message && message.receiver && message.message) {
                            addMessageOther(message, item.clientNumber);
                        }
                    }
                }
                openContainer("messages");
                break;
            case "contacts":
                openContainer("contacts");
                break;
            case "callHistory":
                $(".call-history-entries").empty();
                addCallHistoryEntries(item.callHistory);
                openContainer("call-history");
                break;
            case "twatter":
                $(".twatter-entries").empty();
                addTweets(item.twats, item.myhandle);
                openContainer("twatter");
                $('.notification-twatter').fadeOut(150);
                break;
            case "accountInformation":
                addAccountInformation(item.response);
                openContainer("account-information");
                break;
            case "GPS":
                if (item.locations !== undefined) {
                    addGPSLocations(item.locations);
                }
                openContainer("gps")
                break;
            case "Garage":
                $('.garage-entries').empty();
                addVehicles(item.vehicleData, item.showCarPaymentsOwed)
                openContainer("garage");
                break;
            case "addStocks":
                $('.stocks-entries').empty();
                addStocks(item.stocksData);
                openContainer('stocks');
                break;
            case "google":
                openContainer('gurgle');
                break;
            case "weather":
                setWeather(item.weather);
                break;
            case "deepweb":
                if (true) {
                    openBrowser("http://www.nopixel.online/morbrowser/mor-browser-setup-1/");
                }
                break;
            case "gurgleEntries":
                addGurgleEntries(item.gurgleData);
                break;
            case "keys":
                $('.keys-entries').empty();
                openContainer("keys");
                addKeys(item.keys);
                break;
            case "deliveryJob":
                $('.delivery-job-entries').empty();
                openContainer("delivery-job");
                addDeliveries(item.deliveries);
                break;
            case "notifications":
                $('.emails-entries').empty();
                openContainer("emails");
                $('.notification-email').fadeOut(150);
                addEmails(item.list);
                break;
            case "newemail":
                $('.notification-email').css("display", "flex").hide().fadeIn(150);
                break;
            case "newsms":
                $('.notification-sms').css("display", "flex").hide().fadeIn(150);
                break;
            case "newtweet":
                $('.notification-twatter').css("display", "flex").hide().fadeIn(150);
                break;
            case "newpager":
                let pagerNotification = $('#pager-notification')
                $(pagerNotification).css("display", "flex").hide().fadeIn(2000);
                this.setTimeout(function() {
                    $(pagerNotification).fadeOut(2000);
                }, 8000);
                break;
            case "groups":
                $('.groups-entries').empty();
                openContainer("groups");
                addGroups(item.groups);
                break;
            case "addTasks":
                $('.group-tasks-entries').empty();
                addGroupTasks(item.tasks);
                openContainer("group-tasks");
                break;
            case "groupManage":
                $('.group-manage-entries').empty();
                addGroupManage(item.groupData);
                openContainer("group-manage");
                break;
            case "RealEstate":
                openContainer("real-estate");
                if(item.RERank >= 4) {
                    $('.btn-evict-house').css("visibility", "visible").hide().fadeIn(150);
                    $('.btn-transfer-house').css("visibility", "visible").hide().fadeIn(150);
                }
                break;
            case "callState":
                currentCallState = item.callState;
                currentCallInfo = item.callInfo;
                phoneCallerScreenSetup();
                break;
            case "notify":
                $('#twatter-notification').fadeIn(300);
                $('.twatter-notification-title').text(item.handle);
                $('.twatter-notitication-body').text(decodeEntities(item.message));
                $('#twatter-notification').fadeOut(10000);
                break;
            case "hoa-notification":
                $('#hoa-notification').fadeIn(300);
                $('.hoa-notification-title').text("Security System Alert");
                $('.hoa-notitication-body').text(`An alert has been triggered at ${item.alertLocation}`);
                $('#hoa-notification').fadeOut(15000);
                break;
            case "showOutstandingPayments":
                $('.outstanding-payments-entries').empty();
                addOutstandingPayments(item.outstandingPayments);
                openContainer('outstanding-payments');
                break;
            case "manageKeys":
                $('.manage-keys-entries').empty();
                addManageKeys(item.sharedKeys);
                openContainer('manage-keys')
                break;
            case "settings":
                $('#controlSettings').empty();
                if (item.currentControls !== undefined) {
                    currentBinds = item.currentControls;
                }
                if (item.currentSettings !== undefined) {
                    currentSettings = item.currentSettings;
                }
                createControlList();
                $('.tabs').tabs();
                openContainer("settings");
                setSettings();
                break;
            case "racing:events:list":
                $('.racing-entries').empty();
                races = item.races;
                addRaces(races);
                setInterval(racingStartsTimer, 1000);
                openContainer('racing')
                if (item.canMakeMap)
                    $('.racing-create').css("visibility", "visible").hide().fadeIn(150);
                break;
            case "racing-start":
                $('#racing-start-tracks').empty();
                maps = item.maps;
                addRacingTracks(maps);
                openContainer('racing-start');
                break;
            case "racing:hud:update":
                switch (item.hudState) {
                    case "starting":
                        $('#racing-hud').fadeIn(300);
                        startTime = moment.utc();
                        currentStartTime = startTime;
                        drawRaceStats();
                        break;
                    case "start":
                        isSprint = item.hudData.isSprint
                        if (isSprint)
                            $('#FastestLaptime').hide();
                        startTime = moment.utc();
                        currentStartTime = startTime;
                        curLap = 1;
                        maxLaps = item.hudData.maxLaps;
                        curCheckpoint = 1;
                        maxCheckpoints = item.hudData.maxCheckpoints;
                        fastestLapTime = 0;
                        drawRaceStatsIntervalId = this.setInterval(drawRaceStats, 10);
                        break;
                    case "update":
                        checkFastestLap(item.hudData.curLap);
                        curLap = item.hudData.curLap;
                        curCheckpoint = item.hudData.curCheckpoint;
                        break;
                    case "finished":
                        checkFastestLap(item.hudData.curLap);
                        endTime = moment.utc();
                        curLap = maxLaps;
                        curCheckpoint = maxCheckpoints;
                        this.clearInterval(drawRaceStatsIntervalId);
                        drawRaceStats();
                        $.post('http://phone/race:completed', JSON.stringify({
                            fastestlap: moment(fastestLapTime).valueOf(),
                            overall: moment(endTime - startTime).valueOf(),
                            sprint: isSprint,
                            identifier: item.hudData.eventId
                        }));
                        break;
                    case "clear":
                        curLap = 0;
                        maxLaps = 0;
                        curCheckpoint = 0;
                        maxCheckpoints = 0;
                        fastestLapTime = 0;
                        endTime = 0;
                        startTime = 0;
                        currentStartTime = 0;
                        drawRaceStats();
                        $('#racing-hud').fadeOut(300);
                        break;
                }
                break;
            case "racing:event:update":
                if (item.eventId !== undefined) {
                    $(`.racing-entries li[data-event-id="${item.eventId}"]`).remove();
                    if (races !== undefined)
                        races[item.eventId] = item.raceData
                    addRace(item.raceData, item.eventId);
                } else
                    races = item.raceData
                break;
            case "racing:events:highscore":
                $('.racing-highscore-entries').empty();
                addRacingHighScores(item.highScoreList);
                openContainer('racing-highscore');
                break;
        }
    });
});

$('.phone-screen').on('copy', '.number-badge', function (event) {
    if (event.originalEvent.clipboardData) {
        let selection = document.getSelection();
        selection = selection.toString().replace(/-/g, "")
        event.originalEvent.clipboardData.setData('text/plain', selection);
        event.preventDefault();
    }
});

function checkFastestLap(dataLap) {
    if (curLap < dataLap) {
        let lapTime = curLap === 0 ? moment(startTime - currentStartTime) : moment(moment.utc() - currentStartTime);
        if (fastestLapTime === 0)
            fastestLapTime = lapTime;
        else if (lapTime.isBefore(fastestLapTime)) {
            fastestLapTime = lapTime;
        }
        currentStartTime = moment.utc();
    }
}

function drawRaceStats() {
    $('#Lap').text(`Lap: ${curLap} / ${maxLaps}`);
    $('#Checkpoints').text(`Checkpoint: ${curCheckpoint} / ${maxCheckpoints}`);
    $('#Laptime').text(`Current Lap: ${moment(moment.utc() - currentStartTime).format("mm:ss.SSS")}`);
    if (!isSprint)
        $('#FastestLaptime').text(`Fastest Lap: ${moment(fastestLapTime).format("mm:ss.SSS")}`)
    $('#OverallTime').text(`Total: ${moment(moment.utc() - startTime).format("mm:ss.SSS")}`)
}

function setBatteryLevel(serverTime) {
    let restartTimes = ["00:00:00", "08:00:00", "16:00:00"];
    restartTimes = restartTimes.map(time => moment(time, "HH:mm:ss"));
    serverTime = moment(serverTime, "HH:mm:ss")

    let timeUntilRestarts = restartTimes.map(time => moment.duration(time.diff(serverTime)));
    timeUntilRestarts = timeUntilRestarts.map(time => time.asHours());
    let timeUntilRestart = timeUntilRestarts.filter(time => 0 <= time && time < 8);

    if (timeUntilRestart.length == 0) {
        timeUntilRestarts = timeUntilRestarts.map(time => time + 24);
        timeUntilRestart = timeUntilRestarts.filter(time => 0 <= time && time < 8);
    }
    timeUntilRestart = timeUntilRestart[0];

    if (timeUntilRestart >= 4.5)
        $('#status-bar-time').removeClass().addClass('fas fa-battery-full')
    else if (timeUntilRestart >= 3)
        $('#status-bar-time').removeClass().addClass('fas fa-battery-three-quarters')
    else if (timeUntilRestart >= 1.5)
        $('#status-bar-time').removeClass().addClass('fas fa-battery-half')
    else if (timeUntilRestart < 1.5 && timeUntilRestart > 0.16)
        $('#status-bar-time').removeClass().addClass('fas fa-battery-quarter')
    else
        $('#status-bar-time').removeClass().addClass('fas fa-battery-empty')
}

function addRacingHighScores(highScores) {
    for (let highScore in highScores) {
        let score = highScores[highScore]
        let highScoreElement = `
            <li>
                <div class="collapsible-header row" style="margin-bottom: 0px;">
                    <div class="col s12">
                        <i class="fas fa-trophy yellow-text text-darken-4"></i> ${score.map} <span class="new badge blue" data-badge-caption="races">${score.noOfRaces}</span>
                    </div>
                </div>
                <div class="collapsible-body racing-highscore-body row">
                    <div class="col s12">
                        <div class="row no-padding">
                            <div class="col s3 right-align">
                                <i class="fas fa-stopwatch fa-2x icon "></i>
                            </div>  
                            <div class="col s9">
                                <strong>Fastest Lap</strong> <span data-badge-caption="" class="new badge">${score.fastestLap === -1 ? 'N/A' : moment(score.fastestLap).format("mm:ss.SSS")}</span>
                                <br>${score.fastestName}
                            </div>
                        </div>
                        <div class="row no-padding">
                            <div class="col s3 right-align">
                                <i class="fas fa-shipping-fast fa-2x icon "></i>
                            </div>  
                            <div class="col s9">
                                <strong>Fastest Sprint</strong> <span data-badge-caption="" class="new badge">${score.fastestSprint === -1 ? 'N/A' : moment(score.fastestSprint).format("mm:ss.SSS")}</span>
                                <br>${score.fastestSprintName}
                            </div>
                        </div>
                        <div class="row no-padding">
                            <div class="col s3 right-align">
                                <i class="fas fa-route fa-2x icon "></i>
                            </div>  
                            <div class="col s9">
                                <strong>Distance</strong>
                                <br>${score.mapDistance}m
                            </div>
                        </div>
                    </div>
                </div>
            </li>
        `
        $('.racing-highscore-entries').prepend(highScoreElement);
    }
}

function addRacingTracks(tracks) {
    $('#racing-start-tracks').append(`<option value="" disabled selected>Choose your option</option>`);
    for (let track in tracks) {
        $('#racing-start-tracks').append(`<option value="${track}">${tracks[track].track_name}</option>`)
    }
    $('select').formSelect();
}

function racingStartsTimer() {
    $('.racing-entries .racing-start-timer').each(function () {
        let startTime = moment.utc($(this).data('start-time'));
        if (startTime.diff(moment.utc()) > 0) {
            let formatedTime = makeTimer(startTime);
            $(this).text(`Starts in ${formatedTime.minutes} min ${formatedTime.seconds} sec`);
        }
        else {
            $(this).text('Closed');
        }
    });
}

function addRace(race, raceId) {
    let raceElement = `
    <li data-event-id="${raceId}">
        <div class="collapsible-header row" style="margin-bottom: 0px;">
            <div class="col s12">
                <div class="row no-padding">
                    <div class="col s12">
                        <i class="fas fa-flag-checkered ${race.open ? "green-text" : "red-text"}"></i>${race.raceName} <span class="new badge" data-badge-caption="${race.laps > 0 ? 'laps' : 'Sprint'}">${race.laps > 0 ? race.laps : ''}</span>
                        
                    </div>
                </div>
                <div class="row no-padding">
                    <div class="col s12">
                        <i class="fas fa-stopwatch"></i><span data-balloon-pos="down" class="racing-start-timer" data-start-time="${race.startTime}"></span>
                        <span class="new badge" data-badge-caption="m">${race.mapDistance}</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="collapsible-body racing-entries-body center-align row">
            <div class="col s12">
                <div class="row no-padding">
                    <div class="col s12">
                        <div class="chip">
                            Map Creator: ${race.mapCreator}
                        </div>
                    </div>
                </div>
                <div class="row no-padding">
                    <div class="col s12">
            `
        raceElement += `<button class="waves-effect waves-light btn racing-entries-entrants" data-id="${race.identifier}" aria-label="Race information" data-balloon-pos="up"><i class="fas fa-info icon"></i></button> `

        if (race.open)
            raceElement += `<button class="waves-effect waves-light btn green racing-entries-join" data-id="${race.identifier}" aria-label="Join race" data-balloon-pos="up"><i class="fas fa-flag-checkered icon"></i></button> `

        raceElement += `<button class="waves-effect red waves-light btn phone-button" data-action="racing:event:leave" aria-label="Leave race" data-balloon-pos="up"><i class="fas fa-sign-out-alt icon"></i></button> `
        raceElement +=
        `           </div>
                </div>
            </div>
        </div>
    </li>
    `
    $('.racing-entries').prepend(raceElement);
}

function addRaces(races) {
    for (let race in races) {
        let curRace = races[race]
        addRace(curRace, race);
    }
}

function addManageKeys(keys) {
    for (let key in keys) {
        $('.manage-keys-house').text(keys[key].sharedHouseName);
        let manageHouseKey = `
            <li class="collection-item">
                <div class="row no-padding">
                    <div class="col s9" aria-label="${keys[key].sharedName}" data-balloon-pos="down">
                        <span  class="truncate" style="font-weight:bold">${keys[key].sharedName + "Longernamehereoklolasdasd"}</span>
                    </div>
                    <div class="col s3 right-align">
                        <span class="phone-button manage-keys-remove" data-target-id="${keys[key].sharedId}" aria-label="Remove Key" data-balloon-pos="left"><i class="fas red-text fa-user-times fa-2x"></i></span>
                    </div>
                </div>
                <div class="row no-padding">
                    <div class="col s12">
                        <span>Citizen ID: ${keys[key].sharedId}</span>
                    </div>
                </div>
            </li>
        `

        $('.manage-keys-entries').append(manageHouseKey);
    }
}

function addOutstandingPayments(payments) {
    for (let payment in Object.keys(payments)) {
        $('.outstanding-payments-entries').append("<div class='col s12 outstanding-payment-entry'>" + payments[payment] + "<hr></div>");
    }
}

function addGroupManage(group) {
    $('.group-manage-company-name').text(group.groupName).data('group-id', group.groupId);
    $('.group-manage-company-bank').text('$' + group.bank);
    for (let i = 0; i < group.employees.length; i++) {
        let employee = group.employees[i];
        let employeeEntry = `
        <li>
            <div class="row no-padding">
                <div class="col s12">
                    <div class="card white group-manage-entry-card">
                        <div class="card-content group-manage-entry-content">
                            <div class="row no-padding">
                                <div class="col s12">
                                    <span class="card-title group-manage-entry-title">${employee.name} [${employee.cid}]</span>
                                    <span class="group-manage-entry-body">Promoted to Rank ${employee.rank} by ${employee.giver}</span>
                                </div>
                            </div>
                            <div class="row no-padding" style="padding-top:10px !important">
                                <div class="col s12 center-align">
                                    <button class="waves-effect waves-light btn-small group-manage-pay" style="padding-left:18px;padding-right:18px" data-id="${employee.cid}" aria-label="Pay" data-balloon-pos="up-left"><i class="fas fa-hand-holding-usd"></i></button>
                                    <button class="waves-effect waves-light btn-small group-manage-rank" data-id="${employee.cid}" data-rank="${employee.rank}" aria-label="Set Rank" data-balloon-pos="up"><i class="fas fa-handshake"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </li>
        `
        $('.group-manage-entries').append(employeeEntry);
    }
}

function addGroupTasks(tasks) {
    for (let task in tasks) {
        if (tasks[task].groupId == manageGroup) {
            let currentTask = tasks[task];
            let taskElement = `
                <li class="collection-item">
                    <span style="font-weight:bold">${currentTask.name}</span>
                    <a href="#!" class="secondary-content">`

            if (currentTask.retrace == 1 && currentTask.status != "Successful" && currentTask.status != "Failed")
                taskElement += `<span class="group-tasks-track" data-id="${currentTask.identifier}" aria-label="Track" data-balloon-pos="left"><i class="fas fa-map-marker-alt fa-2x"></i></span>`

            taskElement += `
                        <span class="btn-group-tasks-assign" data-id="${currentTask.identifier}" aria-label="Assign" data-balloon-pos="left"><i class="grey-text text-darken-4 fas fa-hands-helping fa-2x"></i></span>
                    </a>
                    <br><span style="font-weight:300">${currentTask.status}</span>
                    <br><span style="font-weight:bold">${currentTask.assignedTo === 0 ? "Unassigned" : `Assigned to ${currentTask.assignedTo}`}</span> <span data-badge-caption="" class="new badge">${currentTask.identifier}</span>
                </li>
            `

            $('.group-tasks-entries').append(taskElement);
        }
    }
}

function addGroups(groups) {
    for (let group in groups) {
        let groupElement = `
            <li class="collection-item">
                <span style="font-weight:bold">${groups[group].namesent}</span>
                <a href="#!" class="secondary-content">
                    <span class="phone-button" data-action="btnTaskGang" data-action-data="${groups[group].idsent}" aria-label="Tasks" data-balloon-pos="left"><i class="fas fa-tasks fa-2x"></i></span> &nbsp;&nbsp; 
                    <span class="phone-button" data-action="group-manage" data-action-data="${groups[group].idsent}" aria-label="Manage" data-balloon-pos="left"><i class="grey-text text-darken-3 fas fa-briefcase fa-2x"></i></span>
                </a>
                <br><span style="font-weight:300">${groups[group].ranksent}</span>
            </li>
        `

        $('.groups-entries').append(groupElement);
    }
}

function addEmails(emails) {
    for (let email of Object.keys(emails)) {
        let emailElement = `
        <div class="row">
            <div class="col s12 center-align">
                <div class="card-panel teal">
                    <span class="white-text">${emails[email].message}
                    </span>
                </div>
            </div>
        </div>
        `
        $('.emails-entries').prepend(emailElement);
    }
}

function addDeliveries(deliveries) {
    for (let delivery of Object.keys(deliveries)) {
        let deliveryEntry = deliveries[delivery];
        let deliveryElement =
            `
            <li>
                <i class="fas fa-truck-loading fa-2x"></i> <span class="delivery-job-entry-street">${deliveryEntry.targetStreet}</span>
                <span class="secondary-content delivery-job-accept" data-job-id="${deliveryEntry.jobId}" data-job-type="${deliveryEntry.jobType}" aria-label="Click to accept job" data-balloon-pos="left">
                    <i class="fas fa-clipboard-check fa-2x"></i>
                </span>
            </li>
        `
        $('.delivery-job-entries').append(deliveryElement);
    }
}

function addKeys(keys) {
    for (let keyType of Object.keys(keys)) {
        for (let i = 0; i < keys[keyType].length; i++) {
            let key = keys[keyType][i];
            var keyElement = `
            <li data-key-type="${keyType}">
                <div class="collapsible-header">
                    <span class="left">
                    <i class="fas ${keyType === "sharedKeys" ? "fa-handshake" : "fa-key"}"> </i>
                    ${key.house_name}</span>
                    <div class="col s2 right-align">
                        <i class="fas fa-map-marker-alt teal-text gps-location-click" data-house-type="${key.house_model}" data-house-id="${key.house_id}"></i>
                    </div>
                </div>
                <div class="collapsible-body garage-body">
                    <div class="row">
                        <div class="col s12">
                            <ul class="collection">`
            if (keyType === "ownedKeys") {
                let paymentDue = Math.ceil(7 - parseFloat(key.days));
                let paymentString = "";
                if (paymentDue == 0)
                    paymentString = "Today";
                else if (paymentDue < 0)
                    paymentString = `Payment was due ${Math.abs(paymentDue)} days ago.`
                else
                    paymentString = `${paymentDue} until payment is due.`

                if (key.rent_due > 1)
                    keyElement += `<li class="collection-item"><i class="fas fa-credit-card"></i> ${key.rent_due} payments left</li>`
                
                keyElement += `
                                            <li class="collection-item"><i class="fas fa-hourglass-half"></i> ${key.paymentDue == 0 ? 'No remaining payments.' : paymentString}</li>
                                            <li class="collection-item"><i class="fas fa-money-check-alt"></i> You owe $${key.amountdue}</li>
                                        `
            }
            keyElement += `
                            </ul>
                        </div>
                    </div>
                    `
            if (keyType === "ownedKeys") {
                keyElement += `
                        <div class="row no-padding">
                            <div class="col s12 center-align no-padding button-row" >
                                <button class="waves-effect waves-light btn-small phone-button" data-action="btnPropertyUnlock" aria-label="Toggle Unlock" data-balloon-pos="up-left"><i class="fas fa-lock-open"></i></button>
                                <button class="waves-effect waves-light btn-small phone-button" data-action="btnGiveKey" aria-label="Give Keys" data-balloon-pos="up"><i class="fas fa-key"></i></button>
                                <button class="waves-effect waves-light btn-small manage-keys" aria-label="Manage Keys" data-balloon-pos="up"><i class="fas fa-user-slash"></i></button>
                                <button class="waves-effect waves-light btn-small phone-button" data-action="btnFurniture" aria-label="Furniture" data-balloon-pos="up"><i class="fas fa-couch"></i></button>
                                <button class="waves-effect waves-light btn-small phone-button" data-action="btnMortgage" aria-label="Pay Mortgage" data-balloon-pos="up-right"><i class="fas fa-hand-holding-usd"></i></button>
                            </div>
                        </div>
                        `
            } else if (keyType == "sharedKeys") {
                keyElement += `
                <div class="row no-padding">
                    <div class="col s12 center-align no-padding">
                        <button class="waves-effect waves-light btn-small phone-button" data-action="btnPropertyUnlock" aria-label="Toggle Unlock" data-balloon-pos="up-left"><i class="fas fa-lock-open"></i></button>
                        <button class="waves-effect waves-light btn-small phone-button" data-action="btnMortgage" aria-label="Pay Mortgage" data-balloon-pos="up-right"><i class="fas fa-hand-holding-usd"></i></button>
                        <button class="waves-effect waves-light btn-small remove-shared-key" data-house-id="${key.house_id}" data-house-model="${key.house_model}" aria-label="Remove key" data-balloon-pos="up"><i class="fas fa-user-slash"></i></button>
                    </div>
                </div>
                `
            }

            keyElement += `
                </div>
            </li>
        `
            $('.keys-entries').append(keyElement);
        }
    }

}

function addGurgleEntries(pGurgleEntries) {
    const preMadeSearchEntries = [

    ]

    let combined = pGurgleEntries === undefined ? preMadeSearchEntries : $.merge(pGurgleEntries, preMadeSearchEntries);
    if (combined !== undefined)
        gurgleEntries = combined;
}

function openBrowser(url) {
    $("#browser object").attr("data", url);
    closePhoneShell();
    $.post('http://phone/btnCamera', JSON.stringify({}));
    $("#browser").fadeIn(300);
}

function openRadio() {
    let browserRadio =
        `
        <object type="text/html" data="https://nopixel.online/radio/player.html" class="browser-radio-window">
        </object>
    `;

    if ($("#browser-radio").data('loaded') === false) {
        $("#browser-radio").fadeIn(300).data('loaded', true).html(browserRadio)
    }
    else {
        $("#browser-radio").data('loaded', false);
        $("#browser-radio").fadeOut(300).empty();
    }
}

function setWeather(weather) {
    let weatherIcon = "fas fa-sun"
    switch (weather) {
        case "EXTRASUNNY":
        case "CLEAR":
            weatherIcon = "fas fa-sun"
            break;
        case "THUNDER":
            weatherIcon = "fas fa-poo-storm"
            break;
        case "CLEARING":
        case "OVERCAST":
            weatherIcon = "fas fa-cloud-sun-rain"
            break;
        case "CLOUD":
            weatherIcon = "fas fa-cloud"
            break;
        case "RAIN":
            weatherIcon = "fas fa-cloud-rain"
            break;
        case "SMOG":
        case "FOGGY":
            weatherIcon = "fas fa-smog"
            break;
    }
    $('.status-bar-weather').empty();
    $('.status-bar-weather').append(`<i class="${weatherIcon}"></i>`);
}

function addStocks(stocksData) {
    for (let stock of Object.keys(stocksData)) {
        let stockEntry = stocksData[stock];
        let stockElement = `
            <li>
                <div class="collapsible-header">
                    ${stockEntry.identifier} <span class="new ${stockEntry.change > -0.01 ? 'green' : 'red'} badge" data-badge-caption="">${stockEntry.change > -0.01 ? '▲' : '▼'} ${stockEntry.change}%</span>
                </div>
                <div class="collapsible-body garage-body">
                    <ul class="collection">
                        <li class="collection-item">Name: ${stockEntry.name}</li>
                        <li class="collection-item">Shares: ${stockEntry.clientStockValue}</li>
                        <li class="collection-item">Float: ${stockEntry.available}</li>
                        <li class="collection-item">Value: ${stockEntry.value}</li>
                        <li class="collection-item center-align">
                            <button class="waves-effect waves-light btn-small garage-spawn stocks-exchange" data-stock-id="${stockEntry.identifier}"><i class="fas fa-exchange-alt"></i> Exchange</button> 
                        </li>
                    </ul>
                </div>
            </li>
        `
        $('.stocks-entries').append(stockElement);
    }
}

function addVehicles(vehicleData, showCarPayments) {
    if (showCarPayments)
        $('.btn-car-payments').css("visibility", "visible").hide().fadeIn(150);

    for (let vehicle of Object.keys(vehicleData)) {
        let carIconColor = "green";
        if (vehicleData[vehicle].amountDue > 0)
            carIconColor = "red";
        else if (vehicleData[vehicle].amountDue == 0 && vehicleData[vehicle].payments > 0)
            carIconColor = "orange";
        else
            carIconColor = "green";
        var vehicleElement = `
            <li>
                <div class="collapsible-header">
                    <i class="fas fa-car ${carIconColor}-text"></i>${vehicleData[vehicle].name}
                    <span class="new badge" style="text-overflow:ellipsis;overflow:hidden;max-width:15ch;white-space: nowrap;" data-badge-caption="">(${vehicleData[vehicle].state}) ${vehicleData[vehicle].garage}</span>
                </div>
                <div class="collapsible-body garage-body">
                    <div class="row">
                        <div class="col s12"> 
                            <ul class="collection">
                                <li class="collection-item"><i class="fas fa-map-marker-alt"></i>  ${vehicleData[vehicle].garage}</li>
                                <li class="collection-item"><i class="fas fa-closed-captioning"></i> ${vehicleData[vehicle].plate}</li>
                                <li class="collection-item"><i class="fas fa-oil-can"></i> ${vehicleData[vehicle].enginePercent}% Engine</li>
                                <li class="collection-item"><i class="fas fa-car-crash"></i> ${vehicleData[vehicle].bodyPercent}% Body</li>
                                <li class="collection-item"><i class="fas fa-hourglass-half"></i> ${vehicleData[vehicle].payments == 0 ? 'No remaining payments.' : Math.ceil(7 - parseFloat(vehicleData[vehicle].lastPayment)) + ' days until payment is due.'}</li>
                                `
        if (vehicleData[vehicle].payments != 0) {
            vehicleElement += `
                                <li class="collection-item"><i class="fas fa-credit-card"></i> ${vehicleData[vehicle].payments} payments left.</li>
                                <li class="collection-item"><i class="fas fa-dollar-sign"></i> <span class="car-payment-due">${vehicleData[vehicle].amountDue}</span> amount due.</li>
                                `
        }
        vehicleElement += `
                            </ul>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col s12 center-align">`
        if (vehicleData[vehicle].canSpawn)
            vehicleElement += `<button class="waves-effect waves-light btn-small garage-spawn" data-plate="${vehicleData[vehicle].plate}"><i class="fas fa-magic"></i> Spawn</button> `

        if (vehicleData[vehicle].payments > 0 && vehicleData[vehicle].amountDue > 0)
            vehicleElement += `<button class="waves-effect waves-light btn-small red garage-pay" data-plate="${vehicleData[vehicle].plate}"><i class="fas fa-hand-holding-usd"></i> Pay</button> `

        vehicleElement += `<button class="waves-effect waves-light btn-small garage-track" data-plate="${vehicleData[vehicle].plate}"><i class="fas fa-map-marker-alt"></i> Track</button>
                        </div>
                    </div>
                </div>
            </li>
        `
        $('.garage-entries').append(vehicleElement);
    }
}

function addGPSLocations(locations) {
    let unorderedAdressess = []
    for (let location of Object.keys(locations)) {
        let houseType = parseInt(locations[location].houseType);
        let houseInfo = locations[location].info;
        if (houseInfo !== undefined) {
            for (let i = 0; i < houseInfo.length; i++) {

                const houseMapping = {
                    1: { type: 'House', icon: 'fas fa-home' },
                    2: { type: 'Mansion', icon: 'fas fa-hotel' },
                    3: { type: 'Rented', icon: 'fas fa-key' },
                    69: { type: 'Misc', icon: 'fas fa-info' }
                }
                let address = escapeHtml(houseType == 3 ? houseInfo[i].name : houseInfo[i].info)
                unorderedAdressess.push({
                    address: address.trimStart(),
                    houseId: i + 1,
                    houseIcon: houseMapping[houseType].icon,
                    houseType: houseMapping[houseType].type,
                    houseTypeId: houseType
                })
            }
        }
    }
    unorderedAdressess.sort((a, b) => a.address.localeCompare(b.address))
    for (let j = 0; j < unorderedAdressess.length; j++) {
        let htmlData = `<li class="collection-item" data-house-type="${unorderedAdressess[j].houseType}">
                            <div>
                                <span aria-label="${unorderedAdressess[j].houseType}" data-balloon-pos="right"><i class="${unorderedAdressess[j].houseIcon}"></i></span> ${unorderedAdressess[j].address}
                                <span class="secondary-content gps-location-click" data-house-type=${unorderedAdressess[j].houseTypeId} data-house-id="${unorderedAdressess[j].houseId}"><i class="fas fa-map-marker-alt"></i></span>
                            </div>
                        </li>`
        $('.gps-entries').append(htmlData);
    }
}

function addAccountInformation(accountInfo) {
    if (accountInfo) {
        $('.account-information-cash').text('$' + (accountInfo.cash ? accountInfo.cash : 0));
        $('.account-information-bank').text('$' + (accountInfo.bank ? accountInfo.bank : 0));
        licenses = accountInfo.licenses.split('<br>')
        let licensesObject = {}
        for (var i = 0; i < licenses.length; i++) {
            let license = licenses[i].replace(/<[^>]*>?/gm, '').split("|");
            if (license[0] && license !== "") {
                licensesObject[license[0].replace(/\s/gm, '')] = license[1].replace(/\s/gm, '')
            }
        }
        let licenseTable =
            `<table class="responsive-table license-table" >
                <thead>
                    <tr>
                        <th><span aria-label="Your licenses" data-balloon-pos="up-left">License</span></th>
                        <th>Status</th>
                    </tr>
                </thead>
            <tbody>
            `
        for (const key of Object.keys(licensesObject)) {
            licenseTable += `<tr>
                                <td>${key}</td>
                                <td><i class="${licensesObject[key] == 1 ? "fas fa-check green-text" : "fas fa-times red-text"}"></i></td>
                            </tr>`
        }
        licenseTable +=
            `
            </tbody>
        </table>
        `
        $('.account-information-licenses').html(licenseTable);
        if (accountInfo.pagerStatus)
            $('.account-information-toggle-pager').removeClass('red-text').addClass('green-text')
        else
            $('.account-information-toggle-pager').removeClass('green-text').addClass('red-text')
        $('.account-information-primary-job').text(accountInfo.job ? accountInfo.job : "Unemployed.");
        $('.account-information-secondary-job').text(accountInfo.secondaryJob ? accountInfo.secondaryJob : "No secondary job.");
    }
}

function addTweets(tweets, myHandle) {
    $(".twatter-handle").empty();
    $(".twatter-handle").append(myHandle);
    if (tweets && Object.keys(tweets).length > 0) {
        for (let message of tweets) {
            if (message && message.handle && message.message) {
                var twat = message.message;
                if (twat !== "") {
                    var twatEntry = $(`<div class="row no-padding">
                                        <div class="col s12">
                                            <div class="card blue darken-3 twat-card">
                                                <div class="card-content white-text twatter-content">
                                                    <span class="card-title twatter-title">${message.handle}</span>
                                                    <p>${twat}</p>
                                                </div>
                                                <div class="card-action" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;">
                                                    <span data-poster="${message.handle}" class="twat-reply white-text"><i class="fas fa-reply fa-1x"></i></span>
                                                    <span class="right white-text" aria-label="${moment.utc(message.time).local().calendar(null, calendarFormatDate)}" data-balloon-pos="down">${moment.utc(message.time).local().fromNow()}</span>
                                              </div>
                                            </div>
                                            
                                        </div>
                                    </div>`);
                    $('.twatter-entries').prepend(twatEntry);
                }
            }
        }
    }
}

function addCallHistoryEntries(callHistory) {
    if (callHistory && Object.keys(callHistory).length > 0) {
        for (let callEntry of callHistory) {
            if (callEntry && callEntry.type && callEntry.number && callEntry.name) {
                let callIcon = (callEntry.type == 1 ? "call" : "phone_callback")
                let callIconColor = (callEntry.type == 1 ? "green" : "red")

                var number = callEntry.number.toString();
                var phoneNumber = number.slice(0, 3) + '-' + number.slice(3, 6) + '-' + number.slice(6, 10);
                var element = $(`<li>
                    <div class="collapsible-header" style="font-size:12px">
                        <span class="${callIconColor}-text">
                            <i class="material-icons">${callIcon}</i>
                        </span>
                        <span style="word-break: break-word">${callEntry.name}</span>
                        <span class="new badge number-badge" style="width:40%" data-badge-caption="">${phoneNumber}</span>
                    </div>
                    <div class="collapsible-body center-align icon-spacing" style="background-color:white">
                        <i class="fas fa-phone-alt fa-2x btn-contacts-call" data-name="${callEntry.name}" data-number="${callEntry.number}"></i>
                        <i class="fas fa-comment-medical fa-2x btn-contacts-send-message" data-number="${callEntry.number}"></i>
                        <i class="fas fa-user-plus fa-2x btn-call-history-add-contact" data-number="${callEntry.number}"></i>
                    </div>
                </li>`);
                element.data("receiver", number);
                $('.call-history-entries').append(element);
            }
        }
    }
}

function addYellowPage(item) {
    var yellowPage = $(`
        <div class="row no-padding">
            <div class="col s12">
                <div class="card yellow darken-1 yellow-page-entry">
                    <div class="card-content black-text yellow-page-body center-align">
                        <strong>${item.message}</strong>
                    </div>
                    <div class="card-action" style="padding-top: 8px;padding-right: 16px;padding-bottom: 8px;padding-left: 16px;font-size:14px">
                        <div class="row no-padding">
                            <div class="col s6">
                                <span aria-label="Call" data-balloon-pos="up-left" data-number="${item.phoneNumber}" class="yellow-pages-call"><i class="fas fa-phone-alt fa-1x"></i> ${item.phoneNumber}</span>
                            </div>
                            <div class="col s6" data-balloon-length="medium" aria-label="${item.name}" data-balloon-pos="down-right">
                                <span class="truncate"><i class="fas fa-user-circle fa-1x"></i> ${item.name}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>`);
    $('.yellow-pages-entries').prepend(yellowPage);
}

function addMessage(item) {
    var date = (item.date === undefined ? Date.now() : item.date);
    var element = $('<div class="row messages-entry"> <div class="col s2 white-text"> <i class="far fa-user-circle fa-2x"></i> </div> <div class="col s10 messages-entry-details"> <div class="row no-padding"> <div class="col s8 messages-entry-details-sender">' + item.msgDisplayName + '</div> <div class="col s4 messages-entry-details-date right-align">' + moment(date).local().fromNow() + '</div> </div> <div class="row "> <div class="col s12 messages-entry-body">' + item.message + '</div> </div> </div> </div>');
    element.id = item.id;
    element.click(function () {
        $.post('http://phone/messageRead', JSON.stringify({ sender: item.sender, receiver: item.receiver, displayName: item.msgDisplayName }));
    });
    $(".messages-entries").prepend(element);
}

function addMessageOther(item) {
    // Check if message is already added
    var receiver = item.name || item.receiver;
    var date = (item.date === undefined ? Date.now() : item.date);
    var element = $('<div class="row messages-entry"> <div class="col s2 white-text"> <i class="far fa-user-circle fa-2x"></i> </div> <div class="col s10 messages-entry-details"> <div class="row no-padding"> <div class="col s8 messages-entry-details-sender">' + item.msgDisplayName + '</div> <div class="col s4 messages-entry-details-date right-align">' + moment(date).local().fromNow() + '</div> </div> <div class="row "> <div class="col s12 messages-entry-body">' + item.message + '</div> </div> </div> </div>');
    element.id = item.id;
    element.click(function () {
        $.post('http://phone/messageRead', JSON.stringify({ sender: item.sender, receiver: item.receiver, displayName: receiver, clientPhone: item.clientNumber }));
    });
    $(".messages-entries").prepend(element);
}

function addMessageRead(item, clientNumber, displayName) {
    var date = (item.date === undefined ? Date.now() : item.date);
    // If its "us" sending it, place it on the right
    if (item.sender === clientNumber) {
        var element = $('<div class="row message-entry"><div class="chat-bubble right">' + item.message + '<div class="message-details">' + '<span aria-label="' + moment(date).local().calendar(null, calendarFormatDate) + '" data-balloon-pos="left">' + moment(date).local().fromNow() + '</span></div></div></div>');
        element.id = item.id;
        $(".message-entries").append(element);
        $('.message-entries').data("sender", item.receiver);
    } else {
        var element = $('<div class="row message-entry"><div class="chat-bubble left">' + item.message + '<div class="message-details">' + '<span aria-label="' + moment(date).local().calendar(null, calendarFormatDate) + '" data-balloon-pos="down">' + moment(date).local().fromNow() + '</span></div></div></div>');
        element.id = item.id;
        $(".message-entries").append(element);
        $('.message-entries').data("sender", item.sender);
        $('.message-entries').data("receiver", item.sender);
    }
    $('.message-entries').data("displayName", displayName);
    $('.message-entries').data("clientNumber", clientNumber);
}

function addContact(item) {
    if (contactList.some(function (e) { return e.name == item.name && e.number == item.number; })) {
        return;
    }
    contactList.push(item);
    var number = item.number.toString();
    var phoneNumber = number.slice(0, 3) + '-' + number.slice(3, 6) + '-' + number.slice(6, 10);
    var element = $(`
        <li id="${item.name}-${item.number}">
            <div class="collapsible-header" style="font-size:12px">
                <i class="far fa-user-circle fa-2x"></i>
                <span style="word-break: break-word">${item.name}</span>
                <span class="new badge number-badge" style="width:40%" data-badge-caption="">${phoneNumber}</span>
            </div>
            <div class="collapsible-body center-align icon-spacing" style="background-color:white">
                <i class="fas fa-phone-alt fa-2x btn-contacts-call" data-name="${item.name}" data-number="${item.number}"></i>
                <i class="fas fa-comment-medical fa-2x btn-contacts-send-message" data-number="${item.number}"></i>
                <i class="fas fa-user-minus fa-2x btn-contacts-remove" data-name="${item.name}" data-number="${item.number}"></i>
            </div>
        </li>`);
    $(".contacts-entries").append(element);
}

function removeContact(item) {
    $('#' + item.name + '-' + item.number).remove();
    contactList = contactList.filter(function (e) {
        return e.name != item.name && e.number != item.number;
    });
}

function KeysFilter() {
    var filter = $('#keys-search').val();
    $("ul.keys-entries li").each(function () {
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            if (keyFilters.includes($(this).data('key-type')))
                $(this).hide();
            else
                $(this).show()
        }
    });
}

function GPSFilter() {
    var filter = $('#gps-search').val();
    $("ul.gps-entries li").each(function () {
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            if (gpsFilters.includes($(this).data('house-type')))
                $(this).hide();
            else
                $(this).show()
        }
    });
}

function GurgleFilter() {
    $('.gurgle-entries').empty();
    var filter = $('#gurgle-search').val();
    let matchedEntries = gurgleEntries.filter(item => {
        let keys = Object.keys(item);
        for (let itemIndex in keys) {
            if (keys[itemIndex] == 'action')
                continue;
            let key = keys[itemIndex];
            if (key !== 'action') {
                if (item[key].search(new RegExp(filter, "i")) >= 0)
                    return true;
            }
        }
    });
    for (let i = 0; i < matchedEntries.length; i++) {
        let searchElement = `
                            <div class="row no-padding phone-button" >
                                <div class="col s12">
                                    <div class="card white gurgle-card ${matchedEntries[i].action !== undefined ? `phone-button" data-action="${matchedEntries[i].action}">` : '">'}
                                        <div class="card-content gurgle-card-content">
                                            <span class="card-title gurgle-card-title">${matchedEntries[i].webTitle}</span>
                                            <p class="gurgle-card-body black-text">${matchedEntries[i].webDescription}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            `
        $('.gurgle-entries').append(searchElement);
    }
}

function ContactsFilter() {
    var filter = $('#new-contact-search').val();
    $("ul.contacts-entries li").each(function () {
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            $(this).show()
        }
    });
}

function ManageFilter() {
    var filter = $('#group-manage-search').val();
    $("ul.group-manage-entries li").each(function () {
        if ($(this).find('.group-manage-entry-title').text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            $(this).show()
        }
    });
}

function OutstandingFilter() {
    var filter = $('#outstanding-search').val();
    $(".outstanding-payments-entries .outstanding-payment-entry").each(function () {
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            $(this).show()
        }
    });
}

function ManageKeysFilter() {
    var filter = $('#manage-keys-search').val();
    $("ul.manage-keys-entries li").each(function () {
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();
        } else {
            $(this).show()
        }
    });
}

 
// var of Controls
var controlNames = [];
var currentBinds = [];
var currentSettings = [];
var currentSettingWindow = "tokovoip";

var checkedFunctions = ["stereoAudio","localClickOn","localClickOff","remoteClickOn","remoteClickOff"];
var sliderFunctions = ["mainVolume","clickVolume","radioVolume"];


controlNames[0] = ["label","Toko Voip Controls"];
controlNames[1] = ["tokoptt","Toko: Radio Push To Talk",true];
controlNames[2] = ["loudSpeaker","Toko: Loud Speaker",false];
controlNames[3] = ["distanceChange","Toko: Distance Change",false];
controlNames[4] = ["handheld","Toko: Handheld Radio",true];
controlNames[5] = ["carStereo","Toko: Car Stereo",true];
controlNames[6] = ["switchRadioEmergency","Toko: Emergency change radio",false];
controlNames[7] = ["radiovolumedown","Toko: Volume down",true];
controlNames[8] = ["radiovolumeup","Toko: Volume up",true];
controlNames[9] = ["radiotoggle","Toko: Toggle Radio",true];



controlNames[10] = ["label","General Controls"];

controlNames[11] = ["generalPhone","General: Phone",true];
controlNames[12] = ["generalInventory","General: Inventory",true]; 
controlNames[13] = ["generalEscapeMenu","General: Leave Menu",true]; 
controlNames[14] = ["generalChat","General: Chat",true];

controlNames[15] = ["actionBar","General: Action Bar",true];
controlNames[16] = ["generalUse","General: Use Action",false]; // this is set to false , might end up setting true might need testing
controlNames[17] = ["generalUseSecondary","General: Menu Secondary",true];
controlNames[18] = ["generalUseSecondaryWorld","General: World Secondary",true];
controlNames[19] = ["generalUseThird","General: World Third",false];
controlNames[20] = ["generalTackle","General: Tackle",true];
controlNames[21] = ["generalMenu","General: Action Menu",true];
controlNames[22] = ["generalProp","General: Prop Drop",false];
controlNames[23] = ["generalScoreboard","General: Scoreboard",false];

controlNames[24] = ["label","Movement Controls"];
controlNames[25] = ["movementCrouch","Move: Crouch",false];
controlNames[26] = ["movementCrawl","Move: Crawl",false];


controlNames[27] = ["label","Vehicle Controls"];
controlNames[28] = ["vehicleCruise","Vehicle: Cruise Control",false];
controlNames[29] = ["vehicleSearch","Vehicle: Search",false];
controlNames[30] = ["vehicleHotwire","Vehicle: Hotwire",false];
controlNames[31] = ["vehicleDoors","Vehicle: Door Lock",false];
controlNames[32] = ["vehicleBelt","Vehicle: Toggle Belt",false];

controlNames[33] = ["vehicleSlights","Siren: Toggle Lights",false];
controlNames[34] = ["vehicleSsound","Siren: Toggle Sound",false];
controlNames[35] = ["vehicleSnavigate","Siren: Switch Lights",false];



controlNames[36] = ["heliCam","Heli: Cam",false];
controlNames[37] = ["helivision","Heli: Vision",false];
controlNames[38] = ["helirappel","Heli: Rappel",false];
controlNames[39] = ["helispotlight","Heli: Spotlight",false];
controlNames[40] = ["helilockon","Heli: Lockon",false];


controlNames[41] = ["label","News Controls"];
controlNames[42] = ["newsTools","Bring out News Tools",false];
controlNames[43] = ["newsNormal","Camera Normal",false];
controlNames[44] = ["newsMovie","Camera Movie",false];

controlNames[45] = ["label","Motel Controls"];
controlNames[46] = ["housingMain","Motel: Main Useage",false];
controlNames[47] = ["housingSecondary","Motel: Secondary Usage",false];

function updateSettings()
{
    switch (currentSettingWindow) {
        case "tokovoip":
            updateTokoSettings();
            break;
        case "control":
            $.post('http://phone/settingsUpdateToko', JSON.stringify({tag: "controlUpdate",controls: currentBinds}));
            break;
        case "browser":
            break;
        default:
            console.log("Error: incorrect active tab found")
            break;
    }

}

function ResetSettings()
{
    switch (currentSettingWindow) {
        case "tokovoip":
            $.post('http://phone/settingsResetToko', JSON.stringify());
            break;
        case "control":
            $.post('http://phone/settingsResetControls', JSON.stringify());
            break;
        case "browser":
            break;
        default:
            console.log("Error: incorrect active tab found : reset")
            break;
    }
    openContainer(oldContainerHistory.pop(), null, currentContainer);
}


var validBinds = [
    "esc","f1","f2","f3","f5","f5","f6","f7","f8","f9","f10",
    "~","5","6","7","8","9","-","=","backspace",
    "tab","q","e","r","t","y","u","p","[","]","enter",
    "caps","f","g","h","k","l",
    "leftshift","z","x","c","b","n","m",",",".",
    "leftctrl","leftalt","space","rightctrl",
    "home","pageup","pagedown","delete",
    "left","right","top","down",
    "nenter","n4","n5","n6","n7","n8","n9","inputaim"
];

// Util Functions of Controls

function getCurrentBindFromID(bindID)
{
    for (var i = currentBinds.length - 1; i >= 0; i--) {
        if(currentBinds[i][0].toUpperCase() == bindID.toUpperCase())
        {
            return currentBinds[i][1];
        }
    }

    return false;
}

function setBindFromID(bindID,bind)
{
    for (var i = currentBinds.length - 1; i >= 0; i--) {
        if(currentBinds[i][0].toUpperCase() == bindID.toUpperCase())
        {
            currentBinds[i][1] = bind;
        }
    }
}

function validKey(key)
{
    var bindValid = false
    for (var i = validBinds.length - 1; i >= 0; i--) {
        if(validBinds[i].toUpperCase() == key.toUpperCase())
        {
            bindValid = true
        }
    }
    return bindValid
    
}


// Fill fucntion of control
function createControlList()
{
    for (let i = 0; i < controlNames.length; i++) { 
        var bindID = controlNames[i][0];
        var bindIsLocked = controlNames[i][2];

        if(bindID == "label")
        {
             var element = $(`
                <div class="row settings-switchBorder">
                  <div class="col s12 resizeBorder">
                      <label class="resizeBorder-Text">${controlNames[i][1]}</label>
                  </div>
                </div> 
            `);

            $('#controlSettings').append(element);
        }
        else
        {
            var element;
            if(bindIsLocked)
            {
                element = $(`
                    <div class="row settings-switchBorder">
                        <div class="col s8">
                            <label class="resizeBorder2 lockedText">${controlNames[i][1]}</label>
                        </div>
                        <div class="input-field col s4 input-field-small">
                             <input class="errorChecking white-text" id="${bindID}" type="text" onfocusout="TriggerSubmit(id)" data-isUnique="${controlNames[i][2]}"> 
                        </div>
                    </div>
                <span class="error" id="${bindID}-error" aria-live="polite"></span> 
                `);
            }
            else
            {
                element = $(`
                    <div class="row settings-switchBorder">
                        <div class="col s8">
                            <label class="resizeBorder2">${controlNames[i][1]}</label>
                        </div>
                        <div class="input-field col s4 input-field-small">
                             <input class="errorChecking white-text" id="${bindID}" type="text" onfocusout="TriggerSubmit(id)" data-isUnique="${controlNames[i][2]}"> 
                        </div>
                    </div>
                <span class="error" id="${bindID}-error" aria-live="polite"></span> 
                `);
            }
            $('#controlSettings').append(element);
            $("#"+bindID).val(getCurrentBindFromID(bindID).toUpperCase())
        }
         
    }
}

function setSettings()
{
    for (i in currentSettings) {
        for (j in currentSettings[i]) {
            var name = j
            var outcome = currentSettings[i][j]
           
            if(findTypeOf(name) == 1)
            {   
                $('#'+name).prop('checked',outcome);
            }
            else if(findTypeOf(name) == 2)
            {
                var varDataLocal
                if (name.toString() == "mainVolume") {
                    varDataLocal = MinMaxOpposite(10,60,outcome)
                } else if (name.toString() == "clickVolume") {
                    varDataLocal = MinMaxOpposite(5,20,outcome)
                } else if (name.toString() == "radioVolume") {
                    varDataLocal = MinMaxOpposite(0,10,outcome)
                }
                $('#'+name).val(varDataLocal);
            }
        }
    }
}

function updateOnID(settingID,varData)
{
    for (i in currentSettings) {
        for (j in currentSettings[i]) {
            if(j == settingID)
            {   
                currentSettings[i][j] = varData
            }
        }
    }
}
function delay() {
  return new Promise(resolve => setTimeout(resolve, 30));
}

async function delayedLog(item) {
  await delay();
}

// I have autism
// this gets the minimum number in a slider, the maximum, then returns the exact opposite.

function MinMaxOpposite(min,max,num) {
    s = parseInt(num)
    x = parseInt(max)
    n = parseInt(min)
    let response = ((x-n)-((s-n)*2))+s
    return response
}

async function updateTokoSettings()
{

    for (j in checkedFunctions) {
        var name = checkedFunctions[j]
        var varData = $('#'+name).prop('checked');
        updateOnID(name,varData);
        await delayedLog(name);
    }

    for (j in sliderFunctions) {
        var name = sliderFunctions[j]
        var varData = $('#'+name).val();

        if (name == "mainVolume") {
            varData = MinMaxOpposite(10,60,varData)
        } else if (name == "clickVolume") {
            varData = MinMaxOpposite(5,20,varData)
        } else if (name == "radioVolume") {
            varData = MinMaxOpposite(0,10,varData)
        }
        updateOnID(name,varData);
        await delayedLog(name);


    }

    await delayedLog();
    $.post('http://phone/settingsUpdateToko', JSON.stringify({
        tag: "settings",
        settings: currentSettings,
    }));

}



function findTypeOf(settingID)
{
    var type = 0

    for (j in checkedFunctions) {
        if(settingID == checkedFunctions[j])
        {
            type = 1
        }
    }

    if(type == 0)
    {
        for (j in sliderFunctions) {
            if(settingID == sliderFunctions[j])
            {
                type = 2
            }
        }
    }

    return type
}

//Submit Function / check function / main function of control
function TriggerSubmit(name)
{
    var error = $("#"+name+"-error")[0]; 
   
    var valid = true
    var errorMessage = "Invalid Control Input."

    var inputVal = $("#"+name).val();
    var isUnique = $("#"+name).attr("data-isUnique");


     if(inputVal == "")
    {
        valid = false;
        errorMessage = "There must be a bind for this.";
    }

    if(valid)
    {

        if(inputVal.includes('+'))
        {
            var split = inputVal.split("+");
            if(split.length == 2){
                if(!validKey(split[0]))
                {
                    valid = false 
                    errorMessage = "Not a valid bind [1]."
                }
                if(!validKey(split[1]) && valid)
                {
                    valid = false 
                    errorMessage = "Not a valid bind [2]."
                }
            }
            else
            {
                valid = false 
                errorMessage = "Cannot bind 3 keys."
            }
        }
        else
        {
            if(!validKey(inputVal))
            {
                valid = false 
                errorMessage = "Not a valid bind."
            }
        }
    }

    if (valid) {
        for (var i = controlNames.length - 1; i >= 0; i--) {
            if(controlNames[i][0] != "label")
            {
                var nameArr = controlNames[i][0]
                var isUniqueArr = $("#"+nameArr).attr("data-isUnique");
                if(nameArr != name){

                    // If input is the same as another already set input and that found input is unique then error
                    if($("#"+nameArr).val().toUpperCase() == inputVal.toUpperCase() && isUniqueArr == "true"){
                        valid = false;
                        errorMessage = "This Bind is already Being Used";
                    }
                    // if input is same as another already set input and THIS is unique then error
                    
                    if($("#"+nameArr).val().toUpperCase() == inputVal.toUpperCase() && isUnique == "true")
                    {
                        valid = false;
                        errorMessage = "Already in Use : "+controlNames[i][1];
                    }

                    if(inputVal.includes('+'))
                    {
                        var split = inputVal.split("+");
                        var newInput = split[1]+"+"+split[0]

                        if(split[1].toUpperCase() == split[0].toUpperCase()){
                            valid = false;
                            errorMessage = "Both Binds cannot be the same";
                        }

                        // If input is the same as another already set input and that found input is unique then error
                        if($("#"+nameArr).val().toUpperCase() == newInput.toUpperCase() && isUniqueArr == "true"){
                            valid = false;
                            errorMessage = "This Bind is already Being Used";
                        }
                        // if input is same as another already set input and THIS is unique then error
                        
                        if($("#"+nameArr).val().toUpperCase() == newInput.toUpperCase() && isUnique == "true")
                        {
                            valid = false;
                            errorMessage = "Already in Use : "+controlNames[i][1];
                        }
                    }
                }
            }
        }
    }

    if (!valid) {
        error.innerHTML = errorMessage;
        error.className = "error active";
    }
    else
    {
        $("#"+name).val(inputVal.toUpperCase())
        setBindFromID(name,inputVal)
        error.innerHTML = "";
        error.className = "error";
    }
}

function reply_click(clicked_id)
{
  currentSettingWindow = clicked_id;
}


$('#manage-keys-search').keyup(debounce(function () {
    ManageKeysFilter();
}, 500));

$('#outstanding-search').keyup(debounce(function () {
    OutstandingFilter();
}, 500));

$('#keys-search').keyup(debounce(function () {
    KeysFilter();
}, 500));

$('#gps-search').keyup(debounce(function () {
    GPSFilter();
}, 500));

$('#gurgle-search').keyup(debounce(function () {
    GurgleFilter();
}, 500));

$('#new-contact-search').keyup(debounce(function () {
    ContactsFilter();
}, 500));

$('#group-manage-search').keyup(debounce(function () {
    ManageFilter();
}, 500));

$('#racing-create-form').on('reset', function (e) {
    $.post('http://phone/racing:map:cancel', JSON.stringify({}));
});

$('#racing-start-tracks').on('change', function (e) {
    let selectedMap = $(this).val();
    if(maps[selectedMap] !== undefined) {
        $.post('http://phone/racing:map:removeBlips', JSON.stringify({}));
        $.post('http://phone/racing:map:load', JSON.stringify({ id: selectedMap}));
        $('#racing-start-map-creator').text(maps[selectedMap].creator);
        $('#racing-start-map-distance').text(maps[selectedMap].distance);
        $('#racing-start-description').text(maps[selectedMap].description);
    }
});

$('#racing-start').submit(function (e) {
    e.preventDefault();
    let reverseTrack = false;
    if ($('#racing-reverse-track').is(":checked")) { reverseTrack = true };
    $.post('http://phone/racing:event:start', JSON.stringify({
        raceMap: $('#racing-start-tracks').val(),
        raceLaps: $('#racing-start-laps').val(),
        raceStartTime: moment.utc().add($('#racing-start-time').val(), 'seconds'),
        reverseTrack: reverseTrack,
        raceCountdown: $('#racing-start-time').val(),
        raceName: $('#racing-start-name').val(),
        mapCreator: $('#racing-start-map-creator').text(),
        mapDistance: $('#racing-start-map-distance').text(),
        mapDescription: $('#racing-start-description').text()
    }));
});

$('#racing-create-form').submit(function (e) {
    e.preventDefault();
    $.post('http://phone/racing:map:save', JSON.stringify({
        name: escapeHtml($('#racing-create-name').val()),
        desc: escapeHtml($('#racing-create-description').val()),
    }));
});

$("#real-estate-sell-form").submit(function (e) {
    e.preventDefault();
    $.post('http://phone/btnAttemptHouseSale', JSON.stringify({
        cid: escapeHtml($("#real-estate-sell-form #real-estate-sell-id").val()),
        price: escapeHtml($("#real-estate-sell-form #real-estate-sell-amount").val()),
    }));

    $('#real-estate-sell-form').trigger('reset');
    $('#real-estate-sell-modal').modal('close');
});

$('#real-estate-transfer-form').submit(function (e) {
    e.preventDefault();
    $.post('http://phone/btnTransferHouse', JSON.stringify({
        cid: escapeHtml($("#real-estate-transfer-form #real-estate-transfer-id").val()),
    }));
    $('#real-estate-transfer-form').trigger('reset');
    $('#real-estate-transfer-modal').modal('close');
});

$("#group-manage-pay-form").submit(function (e) {
    e.preventDefault();

    let cashToPay = escapeHtml($("#group-manage-pay-form #group-manage-amount").val());
    $.post('http://phone/payGroup', JSON.stringify({
        gangid: escapeHtml($(".group-manage-company-name").data('group-id')),
        cid: escapeHtml($("#group-manage-pay-form #group-manage-id").val()),
        cashamount: cashToPay
    }));

    $('#group-manage-pay-form').trigger('reset');
    $('#group-manage-pay-modal').modal('close');
    let currentValue = $('.group-manage-company-bank').text();
    let newValue = parseInt(currentValue.substring(1, currentValue.length)) - parseInt(cashToPay);
    $('.group-manage-company-bank').text('$' + newValue);

});

$("#group-manage-rank-form").submit(function (e) {
    e.preventDefault();
    $.post('http://phone/promoteGroup', JSON.stringify({
        gangid: escapeHtml($(".group-manage-company-name").data('group-id')),
        cid: escapeHtml($("#group-manage-rank-form #group-manage-rank-id").val()),
        newrank: escapeHtml($("#group-manage-rank-form #group-manage-rank").val()),
    }));
    $('#group-manage-rank-form').trigger('reset');
    $('#group-manage-rank-modal').modal('close');
});

$("#group-manage-bank-form").submit(function (e) {
    e.preventDefault();
    let cashToAdd = escapeHtml($("#group-manage-bank-form #group-manage-bank-amount").val());
    $.post('http://phone/bankGroup', JSON.stringify({
        gangid: escapeHtml($(".group-manage-company-name").data('group-id')),
        cashamount: cashToAdd,
    }));
    $('#group-manage-bank-form').trigger('reset');
    $('#group-manage-bank-modal').modal('close');
    let currentValue = $('.group-manage-company-bank').text();
    let newValue = parseInt(currentValue.substring(1, currentValue.length)) + parseInt(cashToAdd);
    $('.group-manage-company-bank').text('$' + newValue);
});

$("#group-tasks-assign-modal-form").submit(function (e) {
    e.preventDefault();

    $.post('http://phone/btnGiveTaskToPlayer', JSON.stringify({
        taskid: escapeHtml($("#group-tasks-assign-modal-form #group-task-id").val()),
        targetid: escapeHtml($("#group-tasks-assign-modal-form #group-task-target").val()),
    }));

    $("#group-tasks-assign-modal-form").trigger('reset')
    $('#group-tasks-assign-modal').modal('close');
});

$("#contacts-form").submit(function (e) {
    e.preventDefault();
    var escapedName = escapeHtml($("#contacts-form #contacts-new-name").val());
    var clean = escapedName.replace(/[^0-9A-Z]+/gi, "");

    $.post('http://phone/newContactSubmit', JSON.stringify({
        name: clean,
        number: escapeHtml($("#contacts-form #contacts-new-number").val())
    }));

    if (currentContainer === "message") {
        $(".message-recipient").empty();
        $(".message-recipient").append(clean);
    }

    $('#contacts-form').trigger('reset');
    $('#contacts-add-new').modal('close');
});

$("#stock-form").submit(function (event) {
    event.preventDefault();
    $.post('http://phone/stocksTradeToPlayer', JSON.stringify({
        identifier: escapeHtml($("#stock-form #stock-id").val()),
        playerid: escapeHtml($("#stock-form #stock-target-id").val()),
        amount: escapeHtml($("#stock-form #stock-amount").val()),
    }));
    $("#stock-form").trigger("reset");
    $('#stock-modal').modal('close');
});

$("#twat-form").submit(function (event) {
    event.preventDefault();
    $.post('http://phone/newTwatSubmit', JSON.stringify({
        twat: escapeHtml($("#twat-form #twat-body").val()),
        time: moment.utc()
    }));
    $("#twat-form").trigger("reset");
    $('#twat-modal').modal('close');
});

$("#call-form").submit(function (event) {
    event.preventDefault();
    $.post('http://phone/callContact', JSON.stringify({
        name: '',
        number: escapeHtml($("#call-form #call-number").val())
    }));
    $("#call-form").trigger("reset");
    $('#call-modal').modal('close');
});

$("#yellow-pages-form").submit(function (event) {
    event.preventDefault();
    $.post('http://phone/newPostSubmit', JSON.stringify({
        advert: escapeHtml($("#yellow-pages-form #yellow-pages-body").val())
    }));
    $("#yellow-pages-form #yellow-pages-body").attr("style", "").val('')
    $('#yellow-pages-modal').modal('close');
});

$("#new-message-form").submit(function (event) {
    event.preventDefault();

    $.post('http://phone/newMessageSubmit', JSON.stringify({
        number: escapeHtml($("#new-message-form #new-message-number").val()),
        message: escapeHtml($("#new-message-form #new-message-body").val())
    }));

    $('#new-message-form').trigger('reset');
    M.textareaAutoResize($('#new-message-body'));
    $('#messages-send-modal').modal('close');
    switch (currentContainer) {
        case "message":
            setTimeout(function () {
                let sender = $('.message-entries').data("sender");
                let receiver = $('.message-entries').data("clientNumber")
                let displayName = $('.message-entries').data("displayName")
                $.post('http://phone/messageRead', JSON.stringify({ sender: sender, receiver: receiver, displayName: displayName }));
            }, 300);
            break;
        case "messages":
            setTimeout(function () {
                $.post('http://phone/messages', JSON.stringify({}));
            }, 300);
            break;
    }
    //M.toast({ html: 'Message Sent!' });
});


// TODO: Add delete map
/*
$('.racing-map-delete').click(function () {  
    let mapname = $('#racing-map-selected option:selected').text()
    $("#confirm-delete-button").text("Confirm Delete: " + mapname);
    if ( $('.racing-delete-confirm').is(":visible") ) {
        $('.racing-delete-confirm').fadeOut(150)
    } else {
        $('.racing-delete-confirm').fadeIn(150)
    }
});

$('.racing-map-delete-confirm').click(function () {  
    let raceMap = $('#racing-map-selected').val()
    $.post('http://phone/racing:map:delete', JSON.stringify({ id: raceMap }));
    $('.racing-delete-confirm').fadeOut(150)

    $('.racing-map-creation').fadeOut(150)
    $('#racing-information').fadeOut(150)
    $('.racing-map-options').fadeOut(150)
});*/
//

$('#real-estate-evict-modal-accept').click(function () {
    $.post('http://phone/btnEvictHouse', JSON.stringify({}));
    $('#real-estate-evict-modal-').modal('close');
});

$('.btn-racing-clear').click(function() {
    $.post('http://phone/racing:map:removeBlips', JSON.stringify({}));
});

$('.racing-create').click(function () {
    openContainer('racing-create');
});

$('.keys-toggle-filter').click(function () {
    let filterData = $(this).data('filter');

    if ($(this).hasClass("grey-text")) {
        if (!keyFilters.includes(filterData))
            keyFilters.push(filterData);
    }
    else
        keyFilters = keyFilters.filter(filter => filter !== filterData);

    KeysFilter();
    $(this).toggleClass("grey-text white-text");
});

$('.gps-toggle-filter').click(function () {
    let filterData = $(this).data('filter');

    if ($(this).hasClass("grey-text")) {
        if (!gpsFilters.includes(filterData))
            gpsFilters.push(filterData);
    }
    else
        gpsFilters = gpsFilters.filter(filter => filter !== filterData);

    GPSFilter();
    $(this).toggleClass("grey-text white-text");
});

$('.message-send-new').click(function () {
    $('#messages-send-modal').modal('open');
    let sender = $('.message-entries').data("sender");
    $('#messages-send-modal #new-message-number').val(sender);
    M.updateTextFields();
});

$('.messages-call-contact').click(function () {
    $.post('http://phone/callContact', JSON.stringify({
        name: $('.message-entries').data('displayName'),
        number: $('.message-entries').data('sender')
    }));
});

$('.messages-add-new-contact').click(function () {
    $('#contacts-add-new').modal('open');
    $('#contacts-add-new #contacts-new-number').val($('.message-entries').data('sender'));
    M.updateTextFields();
});

$('.twatter-toggle-notification').click(function () {
    icon = $(this).find("i");
    icon.toggleClass("fa-bell fa-bell-slash")
    $.post('http://phone/btnNotifyToggle', JSON.stringify({}));
});

$('.account-information-toggle-pager').click(function () {
    $.post('http://phone/btnPagerToggle', JSON.stringify({}));
    $(this).toggleClass("red-text green-text");
});


$('.racing-entries').on('click', '.racing-entries-entrants', function () {
    $('#racing-entrants-modal').modal('open');
    $('.racing-entrants').empty();
    $('#racing-info-description').text();
    let currentRace = races[$(this).data('id')]
    $('#racing-info-description').text(currentRace.mapDescription);
    if(currentRace.racers !== undefined)
        currentRace.racers = Object.values(currentRace.racers).sort((a,b) => a.total - b.total); 
    for (let id in currentRace.racers) {
        let racer = currentRace.racers[id];
        let racerElement = `
            <li>
                <div class="collapsible-header">${racer.name}</div>
                <div class="collapsible-body">
                    <div class="row">
                        <div class="col s3 right-align">
                            <i class="fas fa-shipping-fast fa-2x icon "></i>
                        </div>  
                        <div class="col s9">
                            <strong>Fastest Lap</strong>
                            <br>${moment(racer.fastest).format("mm:ss.SSS")}
                        </div>
                    </div>
                    <div class="row">
                        <div class="col s3 right-align">
                            <i class="fas fa-stopwatch fa-2x icon"></i>
                        </div>  
                        <div class="col s9">
                            <strong>Total</strong>
                            <br>${moment(racer.total).format("mm:ss.SSS")}
                        </div>
                    </div>
                </div>
            </li>
        `
        $('.racing-entrants').append(racerElement);
    }
});

$('.racing-entries').on('click', '.racing-entries-join', function () {
    $.post('http://phone/racing:event:join', JSON.stringify({ identifier: $(this).data('id') }));
});

$('.keys-entries').on('click', '.manage-keys', function () {
    $.post('http://phone/retrieveHouseKeys', JSON.stringify({}));
});

$('.keys-entries').on('click', '.remove-shared-key', function(e) {
    $.post('http://phone/removeSharedKey', JSON.stringify({
        house_id: $(this).data('house-id'),
        house_model: $(this).data('house-model')
    }))
    $(this).closest('li').remove()
});

$('.manage-keys-entries').on('click', '.manage-keys-remove', function () {
    $.post('http://phone/removeHouseKey', JSON.stringify({
        targetId: $(this).data('target-id')
    }))
    $.post('http://phone/retrieveHouseKeys', JSON.stringify({}));
})

$('.yellow-pages-entries').on('click', '.yellow-pages-call', function () {
    $.post('http://phone/callContact', JSON.stringify({
        name: '',
        number: $(this).data('number')
    }));
});

$('.twatter-entries').on('click', '.twat-reply', function () {
    $('#twat-modal').modal('open');
    $('#twat-form #twat-body').text($(this).data('poster') + " ");
    M.updateTextFields();
});

$('.call-history-entries').on('click', '.btn-call-history-add-contact', function () {
    $('#contacts-add-new').modal('open');
    $('#contacts-add-new #contacts-new-number').val($(this).data('number'));
    M.updateTextFields();
});

$('.group-manage-entries').on('click', '.group-manage-pay', function () {
    $('#group-manage-pay-modal').modal('open');
    $('#group-manage-pay-modal #group-manage-id').val($(this).data('id')).prop('disabled', true);
    M.updateTextFields();
});

$('.group-manage-entries').on('click', '.group-manage-rank', function () {
    $('#group-manage-rank-modal').modal('open');
    $('#group-manage-rank-modal #group-manage-rank-id').val($(this).data('id')).prop('disabled', true);
    $('#group-manage-rank-modal #group-manage-rank').val($(this).data('rank'));
    M.updateTextFields();
});

$('.group-tasks-entries').on('click', '.group-tasks-track', function () {
    $.post('http://phone/trackTaskLocation', JSON.stringify({ TaskIdentifier: $(this).data('id') }));
});

$('.delivery-job-entries').on('click', '.delivery-job-accept', function (e) {
    $.post('http://phone/selectedJob', JSON.stringify({ jobType: $(this).data('job-type'), jobId: $(this).data('job-id') }));
});

$('.stocks-entries').on('click', '.stocks-exchange', function (e) {
    $('#stock-modal').modal('open');
    $('#stock-modal #stock-id').val($(this).data('stock-id'));
    M.updateTextFields();
})

$('.garage-entries').on('click', '.garage-spawn', function (e) {
    e.preventDefault();
    $.post('http://phone/vehspawn', JSON.stringify({ vehplate: $(this).data('plate') }));
    $.post('http://phone/btnGarage', JSON.stringify({}));
});

$('.garage-entries').on('click', '.garage-track', function () {
    $.post('http://phone/vehtrack', JSON.stringify({ vehplate: $(this).data('plate') }));
});

$('.garage-entries').on('click', '.garage-pay', function (e) {
    $.post('http://phone/vehiclePay', JSON.stringify({ vehiclePlate: $(this).data('plate') }));
    setTimeout(function () {
        $.post('http://phone/btnGarage', JSON.stringify({}));
    }, 1500);
});

$('.gps-entries, .keys-entries').on('click', '.gps-location-click', function () {
    $.post('http://phone/loadUserGPS', JSON.stringify({ house_id: $(this).data('house-id'), house_type: $(this).data('house-type') }));
})

$('.contacts-entries, .call-history-entries').on('click', '.btn-contacts-call', function () {
    $.post('http://phone/callContact', JSON.stringify({ name: $(this).data('name'), number: $(this).data('number') }));
});

$('.contacts-entries, .call-history-entries').on('click', '.btn-contacts-send-message', function (event) {
    $('#messages-send-modal').modal('open');
    $('#messages-send-modal #new-message-number').val($(this).data('number'));
    M.updateTextFields();
});

$('.group-tasks-entries').on('click', '.btn-group-tasks-assign', function () {
    $('#group-tasks-assign-modal').modal('open');
    $('#group-tasks-assign-modal #group-task-id').val($(this).data('id'));
    M.updateTextFields();
});

$('.contacts-entries-wrapper').on('click', '.btn-contacts-remove', function () {
    $('#confirm-modal-accept').data('name', $(this).data('name'));
    $('#confirm-modal-accept').data('number', $(this).data('number'));
    $('#confirm-modal').modal('open');
    $('#confirm-modal-question').text(`Are you sure you want to delete ${$(this).data('name')}?`);
});

$('#confirm-modal-accept').click(function (event) {
    $.post('http://phone/removeContact', JSON.stringify({ name: $(this).data('name'), number: $(this).data('number') }));
    $('#confirm-modal').modal('close');
});

$('.dial-button').click(function (e) {
    if ($('#call-number').val().length < 10)
        $('#call-number').val(parseInt($('#call-number').val().toString() + $(this).text()));
    M.updateTextFields();
});


$('.settings-submit').click(function (e) {
    updateSettings();
});

$('.settings-reset').click(function (e) {
    ResetSettings();
});

function openContainer(containerName, fadeInTime = 500, ...args) {
    closeContainer(currentContainer, (currentContainer !== containerName ? 300 : 0));
    $("." + containerName + "-container").hide().fadeIn((currentContainer !== containerName ? fadeInTime : 0));
    if (containerName === "home") {
        $(".phone-screen .rounded-square:not('.hidden-buttons')").each(function () {
            $(this).fadeIn(1000);
        });
        $(".navigation-menu").fadeTo("slow", 0.5, null);
    }
    else
        $(".navigation-menu").fadeTo("slow", 1, null);

    if (containerName === "racing")
        clearInterval(racingStartsTimer);

    if (containerName === "message")
        $('.message-entries-wrapper').animate({
            scrollTop: $('.message-entries-wrapper')[0].scrollHeight
        }, 0);

    if (args[0] === undefined) {
        oldContainerHistory.push(currentContainer);
    }
    currentContainer = containerName;
}

function closeContainer(containerName, fadeOutTime = 500) {
    $.when($("." + containerName + "-container").fadeOut(fadeOutTime).hide()).then(function () {
        if (containerName === "home")
            $(".phone-screen .rounded-square").each(function () {
                $(this).fadeIn(300);
            });
    });
}

function phoneCallerScreenSetup() {
    switch (callStates[currentCallState]) {
        case "isNotInCall":
            if (currentContainer === "incoming-call") {
                currentCallState = 0;
                currentCallInfo = "";
                openContainer("home");
            }
            break;
        case "isDialing":
            $('.incoming-call-header-caller').text("Outgoing call");
            $('.caller').text(currentCallInfo);
            $(".btnAnswer").fadeOut(0);
            $(".btnHangup").fadeIn(0);
            openContainer('incoming-call');
            break;
        case "isReceivingCall":
            $('.incoming-call-header-caller').text("Incoming call");
            $('.caller').text(currentCallInfo);
            $(".btnAnswer").fadeIn(0);
            $(".btnHangup").fadeIn(0);
            openContainer('incoming-call');
            break;
        case "isCallInProgress":
            $('.incoming-call-header-caller').text("Ongoing call");
            $('.caller').text(currentCallInfo);
            $(".btnAnswer").fadeOut(0);
            $(".btnHangup").fadeIn(0);
            break;
    }
}

function openPhoneShell() {
    $(".phone-shell").add($('.phone-screen')).fadeIn(500);
}

function closePhoneShell() {
    $(".phone-shell").add($('.phone-screen')).fadeOut(500);
    $(".phone-screen .hidden-buttons").each(function () {
        $(this).hide().fadeOut(150);
    });
}



var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
        return entityMap[s];
    });
}

function makeTimer(targetTime) {
    var endTime = new Date(targetTime);
    endTime = (Date.parse(endTime) / 1000);

    var now = new Date();
    now = (Date.parse(now) / 1000);

    var timeLeft = endTime - now;

    var days = Math.floor(timeLeft / 86400);
    var hours = Math.floor((timeLeft - (days * 86400)) / 3600);
    var minutes = Math.floor((timeLeft - (days * 86400) - (hours * 3600)) / 60);
    var seconds = Math.floor((timeLeft - (days * 86400) - (hours * 3600) - (minutes * 60)));

    if (hours < "10") { hours = "0" + hours; }
    if (minutes < "10") { minutes = "0" + minutes; }
    if (seconds < "10") { seconds = "0" + seconds; }

    return {
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds
    }
}