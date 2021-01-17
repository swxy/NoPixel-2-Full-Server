var open = false;
$('#carmenu').fadeOut(0);

function checkElement(settings, element, settingName) {
    if (settings[settingName] == true) {
        $(element).parent().addClass('active');
    }
    else {
        $(element).parent().removeClass('active');
    }
}

function checkSeat(settings, element, settingName) {
    var parent = $(element).parent();
    parent.removeClass('disabled');
    parent.removeClass('active');
    if (settings[settingName] === parseInt($(element).attr('value'))) {
        parent.addClass('active');
    }
    else if (settings[settingName] === true) {
        return;
    }
    else {
        parent.addClass('active');
        parent.addClass('disabled');
    }
}

$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == "enablecarmenu") {
            open = event.data.enable;
            if (open) {
                document.body.style.display = "block";
                setTimeout(function(){
                    $('#carmenu').fadeIn(500);
                }, 1);
            }
            else {
                $('#carmenu').fadeOut(500);
                setTimeout(function(){
                    document.body.style.display = "none";
                }, 500);
            }
        }
        if (event.data.type == "refreshcarmenu") {
            settings = event.data.settings
            $('.seat').each(function(i, v) {
                var val = parseInt($(v).attr('value'));
                if (val == -1)
                    checkSeat(settings, $(v), 'seat1');
                if (val == 0)
                    checkSeat(settings, $(v), 'seat2');
                if (val == 1)
                    checkSeat(settings, $(v), 'seat3');
                if (val == 2)
                    checkSeat(settings, $(v), 'seat4');
            });
            $('.door').each(function(i, v) {
                if (!settings.doorAccess) {
                    $(v).parent().addClass('disabled');
                }
                else {
                    $(v).parent().removeClass('disabled');
                }
                var val = parseInt($(v).attr('value'));
                if (val == 0)
                    checkElement(settings, $(v), 'door0');
                if (val == 1)
                    checkElement(settings, $(v), 'door1');
                if (val == 2)
                    checkElement(settings, $(v), 'door2');
                if (val == 3)
                    checkElement(settings, $(v), 'door3');
                if (val == 4)
                    checkElement(settings, $(v), 'hood');
                if (val == 5)
                    checkElement(settings, $(v), 'trunk');
            });
            $('.window').each(function(i, v) {
                var val = parseInt($(v).attr('value'));
                if (val == 0)
                    checkElement(settings, $(v), 'windowr1');
                if (val == 1)
                    checkElement(settings, $(v), 'windowl1');
                if (val == 2)
                    checkElement(settings, $(v), 'windowr2');
                if (val == 3)
                    checkElement(settings, $(v), 'windowl2');
            });


            // setup engine
            // $('.engine').parent().addClass('disabled');
            $('.engine').parent().removeClass('active');

            if (settings['engine'] === true) {
                $('.engine').parent().addClass('active');
            }
            // if (settings['engineAccess'] === true) {
            //     $('.engine').parent().removeClass('disabled');
            // }
            // end engine
        }
    });

    $('.door').on('click', function() {
        if ($(this).parent().hasClass('disabled')) return;
        var doorIndex = $(this).attr('value');
        $.post('http://raid_carmenu/openDoor', JSON.stringify({
                doorIndex: doorIndex
            })
        );
    });

    $('.seat').on('click', function() {
        var seatIndex = $(this).attr('value');
        $.post('http://raid_carmenu/switchSeat', JSON.stringify({
                seatIndex: seatIndex
            })
        );
    });

    $('.window').on('click', function() {
        var windowIndex = $(this).attr('value');
        $.post('http://raid_carmenu/togglewindow', JSON.stringify({
                windowIndex: windowIndex
            })
        );
    });

    $('.engine').on('click', function() {
        if ($(this).parent().hasClass('disabled')) return;
        $.post('http://raid_carmenu/toggleengine', JSON.stringify({}));
    });

    document.onkeyup = function (data) {
        if (open) {
            // data.getModifierState("Shift") &&
            if ((
                data.which == 90) ||
                data.which == 27
            ) {
                // Z or Esc
                $.post('http://raid_carmenu/escape', JSON.stringify({}));
            }
        }
    };
});
