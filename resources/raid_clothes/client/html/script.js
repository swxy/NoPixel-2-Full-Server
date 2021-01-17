var open = false;
$('#clothesmenu').fadeOut(0);
$('#barbermenu').fadeOut(0);
var currentMenu = null;
var hairColors = null;
var makeupColors = null;
let headBlend = {};

var isService = false;

let whitelisted = {
    male:[
    ],
    female:[
    ]
};

whitelisted["male"] = {
    jackets:[19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,35,67,68,70,71,73,74,76,81,82,83,105,149,205],
    undershirts:[16,17,19,20,22,24,25,26,28,29,33,34,35,36,39,40,42,57,58,102,115,116,166,173,174],
    pants:[21,22,23,24,25,28,35],
    decals:[1,2,3,4,5,6,58],
    vest:[1,2,7,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
    hats:[20,21,24,25,26,27,30,33,34,50,90,166],
}

whitelisted["female"] = {
    jackets:[17,18,19,20,21,22,23,24,25,26,27,28,29,30,67,68,102,157],
    undershirts:[16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,66,67,68,70,71,72,78,79,105,143,198],
    pants:[18,19,20,21,22,23,24,39],
    vest:[8,9,11,12,13,14,15,16,17,18,19,21,22],
    hats:[20,21,23,24,25,26,28,29,31,37,39,75,77,153],
}

const throttle = (func, limit) => {
    let inThrottle
    return (...args) => {
        if (!inThrottle) {
            func(...args)
            inThrottle = setTimeout(() => inThrottle = false, limit)
        }
    }
}

$(function () {
    $('.modal').modal();

    window.addEventListener('message', function (event) {
        if (event.data.type == "enableclothesmenu") {
            open = event.data.enable;
            if (open) {
                currentMenu = $('#'+event.data.menu);
                isService = event.data.isService;
                document.body.style.display = "block";
                setTimeout(function () {
                    currentMenu.fadeIn(500);
                }, 1);
            } else {
                currentMenu.fadeOut(500);
                setTimeout(function () {
                    document.body.style.display = "none";
                }, 500);
            }
        }

        if (event.data.type == "colors") {
            hairColors = createPalette(event.data.hairColors);
            makeupColors = createPalette(event.data.makeupColors);
            AddPalettes();
            SetHairColor(event.data.hairColor);
        }

        if (event.data.type == "menutotals") {
            let drawTotal = event.data.drawTotal;
            let propDrawTotal = event.data.propDrawTotal;
            let textureTotal = event.data.textureTotal;
            let headoverlayTotal = event.data.headoverlayTotal;
            let skinTotal = event.data.skinTotal;
            UpdateTotals(drawTotal, propDrawTotal, textureTotal, headoverlayTotal, skinTotal);
        }
        if (event.data.type == "clothesmenudata") {
            let drawables = event.data.drawables;
            let props = event.data.props;
            let drawtextures = event.data.drawtextures;
            let proptextures = event.data.proptextures;
            let skin = event.data.skin;
            UpdateInputs(drawables, props, drawtextures, proptextures, skin);
        }

        if (event.data.type == "barbermenu") {
            headBlend = event.data.headBlend;
            SetupHeadBlend();
            SetupHeadOverlay(event.data.headOverlay);
            SetupHeadStructure(event.data.headStructure);
        }

        if (event.data.type == "tattoomenu") {
            headBlend = event.data.headBlend;
            SetupTatTotals(event.data.totals)
            SetupTatValues(event.data.values)
        }
    });

    document.onkeyup = function (data) {
        if (open) {
            // data.getModifierState("Shift") &&
            if (data.which == 27) {
                if ($('#closemenu').hasClass('open')) {
                    $('#closemenu').modal('close');
                }
                else {
                    $('#closemenu').modal('open');
                }
            }
        }
    };

    $('#save').on('click', function() {
        CloseMenu(true)
    })
    $('#discard').on('click', function() {
        CloseMenu(false)
    })

    function CloseMenu(save) {
        $.post('http://raid_clothes/escape', JSON.stringify({save:save}));
    }

    $(document).on('contextmenu', function() {
        $.post('http://raid_clothes/togglecursor', JSON.stringify({}));
    })

    $('.button-menu').on('click', function () {
        $('.button-menu').removeClass('active')
        $('.button-menu').each(function() {
            $("#" + $(this).attr('data-target')).fadeOut(100);
        })

        let t = $("#" + $(this).attr('data-target'))
        $(this).addClass('active');
        t.fadeIn(100);
    })

    function UpdateTotals(drawTotal, propDrawTotal, textureTotal, headoverlayTotal, skinTotal) {
        for (var i = 0; i < Object.keys(drawTotal).length; i++) {
            if (drawTotal[i][0] == "hair") {
                $('.hair').each(function() {
                    $(this).find('.total-number').eq(0).text(drawTotal[i][1]);
                })
            }
            $("#" + drawTotal[i][0]).find('.total-number').eq(0).text(drawTotal[i][1]);
        }

        for (var i = 0; i < Object.keys(propDrawTotal).length; i++) {
            $("#" + propDrawTotal[i][0]).find('.total-number').eq(0).text(propDrawTotal[i][1]);
        }

        for (const key of Object.keys(textureTotal)) {
            $("#" + key).find('.total-number').eq(1).text(textureTotal[key]);
        }

        for (const key of Object.keys(headoverlayTotal)) {
            $("#" + key).find('.total-number').eq(0).text(headoverlayTotal[key]);
        }

        let skinConts = $('#skins').find('.total-number');
        skinConts.eq(0).text(skinTotal[0]+1);
        skinConts.eq(1).text(skinTotal[1]+1);
    }

    function UpdateInputs(drawables, props, drawtextures, proptextures, skin) {
        for (var i = 0; i < Object.keys(drawables).length; i++) {
            if (drawables[i][0] == "hair") {
                $('.hair').each(function() {
                    $(this).find('.input-number').eq(0).val(drawables[i][1]);
                })
            }
            $("#" + drawables[i][0]).find('.input-number').eq(0).val(drawables[i][1]);
        }

        for (var i = 0; i < Object.keys(props).length; i++) {
            $("#" + props[i][0]).find('.input-number').eq(0).val(props[i][1]);
        }

        for (var i = 0; i < Object.keys(drawtextures).length; i++) {
            $("#" + drawtextures[i][0]).find('.input-number').eq(1).val(drawtextures[i][1]);
        }
        for (var i = 0; i < Object.keys(proptextures).length; i++) {
            $("#" + proptextures[i][0]).find('.input-number').eq(1).val(proptextures[i][1]);
        }

        if (skin['name'] == "skin_male") {
            $('#skin_male').val(skin['value'])
            if($('#skin_female').val() != 0){$('#skin_female').val(0)}
        }
        else {
            $('#skin_female').val(skin['value'])
            if($('#skin_male').val() != 0){$('#skin_male').val(0)}
        }
    }

    $('.button-left').on('click', function () {
        var input = $(this).parent().find('.input-number')
        input.val(parseInt(input.val()) - 1)
        inputChange(input,false)
    })
    $('.button-right').on('click', function () {
        var input = $(this).parent().find('.input-number')
        input.val(parseInt(input.val()) + 1)
        inputChange(input,true)
    })

    $('.input-number').on('input', function () {
        inputChange($(this),true)
    })

    $('.input-number').on('mousewheel', function () {})

    $('#skin_string').find('input').keypress(function (e) {
        if (e.which == 13) {
            $.post('http://raid_clothes/customskin', JSON.stringify($(this).val()));
        }
    })

    function inputChange(ele,inputType) {
        var inputs = $(ele).parent().parent().find('.input-number');
        var total = 0;

        if (currentMenu.is($('#clothesmenu')) || $(ele).parents('.panel').hasClass('hair')) {
            if (ele.is(inputs.eq(0))) {
                total = inputs.eq(0).parent().find('.total-number').text();
                inputs.eq(1).val(0);
            } else {
                total = inputs.eq(1).parent().find('.total-number').text();
            }

            if (parseInt($(ele).val()) > parseInt(total)-1) {
                $(ele).val(-1)
            } else if (parseInt($(ele).val()) < -1) {
                $(ele).val(parseInt(total)-1)
            }
            if (ele.is(inputs.eq(1)) && $(ele).val() == -1) {
                $(ele).val(0)
            }

            if(!isService && ($('#skin_female').val() == 1 || $('#skin_male').val() == 1)) {
                let clothingName = $(ele).parents('.panel').attr('id');
                let clothingID = parseInt($(ele).val());
                let isNotValid = true
                let gender = "male";
                if($('#skin_female').val() >= 1 && $('#skin_male').val() == 0)
                    gender = "female";

                if(ele.is(inputs.eq(0)) && whitelisted[gender][clothingName]){
                    while (isNotValid) {
                        if(whitelisted[gender][clothingName].indexOf(clothingID) > -1 ){
                            isNotValid = true
                            if(inputType){clothingID++;}else{clothingID--;}

                        }
                        else
                        {
                            isNotValid = false;
                        }
                    }
                }
                $(ele).val(clothingID)
            }

            if ($(ele).parents('.panel').attr('id') == "skins") {
                $.post('http://raid_clothes/setped', JSON.stringify({
                    "name": $(ele).attr('id'),
                    "value": $(ele).val()
                }))
            }
            else {
                let nameId = "";
                if (currentMenu.is($('#barbermenu')))
                    nameId = "hair"
                else
                    nameId = $(ele).parent().parent().parent().attr('id').split('#')[0]
                $.post('http://raid_clothes/updateclothes', JSON.stringify({
                    "name": nameId,
                    "value": inputs.eq(0).val(),
                    "texture": inputs.eq(1).val()
                })).done(function (data) {
                    inputs.eq(1).parent().find('.total-number').text(data);
                });
            }
        }
        else if (currentMenu.is($('#barbermenu'))) {
            if (ele.is(inputs.eq(0))) {
                total = inputs.eq(0).parent().find('.total-number').text();
            } else {
                total = inputs.eq(1).parent().find('.total-number').text();
            }

            var value = parseInt($(ele).val(), 10);
            total = parseInt(total, 10) - 1;

            if (value > 255) {
                value = 0;
            }
            else if (value === 254) {
                value = total;
            }
            else if (value < 0 || value > total) {
                value = 255;
            }

            $(ele).val(value);

            var activeID = $('#barbermenu').find('.active').attr('id');
            switch (activeID) {
                case "button-inheritance":
                    SaveHeadBlend();
                    break;
                case "button-appear":
                case "button-hair":
                case "button-features":
                    SaveHeadOverlay(ele);
                    break;
            }
        }
        else if (currentMenu.is($('#tattoomenu'))) {
            total = inputs.eq(0).parent().find('.total-number').text();
            if (parseInt($(ele).val()) > parseInt(total)-1) {
                $(ele).val(0)
            } else if (parseInt($(ele).val()) < 0) {
                $(ele).val(parseInt(total)-1)
            }
            let tats = {}
            let categEles = $('#tattoos .scroll-container').children()
            categEles.each(function () {
                tats[$(this).attr('id')] = $(this).find('.input-number').val();
            })
            $.post('http://raid_clothes/settats', JSON.stringify({tats}))
        }
    }

    $('.slider-range').on('input', function() {
        if (currentMenu.is($('#barbermenu'))) {
            var activeID = $('#barbermenu').find('.active').attr('id');
            switch (activeID) {
                case "button-inheritance":
                    SaveHeadBlend();
                    break;
                case "button-faceshape":
                    SaveFaceShape($(this));
                    break;
                case "button-appear":
                case "button-hair":
                case "button-features":
                    SaveHeadOverlay($(this));
                    break;
            }
        }
    })

    // camera buttons
    function toggleCam(ele) {
        $('tog_head').removeClass('active');
        $('tog_torso').removeClass('active');
        $('tog_leg').removeClass('active');
        ele.addClass('active');
    }

    $('.tog_head').on('click', function() {
        toggleCam($(this));
        $.post('http://raid_clothes/switchcam', JSON.stringify({name: 'head'}))
    })
    $('.tog_torso').on('click', function() {
        toggleCam($(this));
        $.post('http://raid_clothes/switchcam', JSON.stringify({name: 'torso'}))
    })
    $('.tog_leg').on('click', function() {
        toggleCam($(this));
        $.post('http://raid_clothes/switchcam', JSON.stringify({name: 'leg'}))
    })
    $('.tog_cam').on('click', function() {
        toggleCam($(this));
        $.post('http://raid_clothes/switchcam', JSON.stringify({name: 'cam'}))
    })


    $('.tog_hat').on('click', function() {
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "hats"}))
    })
    $('.tog_glasses').on('click', function() {
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "glasses"}))
    })
    $('.tog_tops').on('click', function() {
        // dont look at this :)
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "jackets"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "undershirts"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "torsos"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "vest"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "bags"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "neck"}))
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "decals"}))
    })
    $('.tog_legs').on('click', function() {
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "legs"}))
    })
    $('.tog_mask').on('click', function() {
        $.post('http://raid_clothes/toggleclothes', JSON.stringify({name: "masks"}))
    })

    $('#reset').on('click', function() {
        $.post('http://raid_clothes/resetped', JSON.stringify({}))
    })


    window.addEventListener("keydown", throttle(function (ev) {
        var input = $(ev.target);
        var num = input.hasClass('input-number');
        var _key = false;
        if (ev.which == 39 || ev.which == 68) {
            if (num === false) {
                _key = "left"
            }
            else if (num) {
                input.val(parseInt(input.val()) + 1)
                inputChange(input,true)
            }
        }
        if (ev.which == 37 || ev.which == 65) {
            if (num === false) {
                _key = "right"
            }
            else if (num) {
                input.val(parseInt(input.val()) - 1)
                inputChange(input,false)
            }
        }

        if (_key) {
            $.post('http://raid_clothes/rotate', JSON.stringify({key: _key}))
        }
    }, 50))




    /////////////////////////////////////////////////////////////////////////////////////////
    // Barber

    function SetHairColor(data) {
        $('.hair').each(function() {
            var palettes = $(this).find('.color_palette_container').eq(0).find('.color_palette')
            $(palettes[data[0]]).addClass('active')
            palettes = $(this).find('.color_palette_container').eq(1).find('.color_palette')
            $(palettes[data[1]]).addClass('active')
        })
    }

    function SetupHeadBlend() {
        if (headBlend == null) return;
        var sf = $('#shapeFirstP');
        var ss = $('#shapeSecondP');
        var st = $('#shapeThirdP');

        sf.find('.input-number').eq(0).val(headBlend['shapeFirst'])
        sf.find('.input-number').eq(1).val(headBlend['skinFirst'])
        ss.find('.input-number').eq(0).val(headBlend['shapeSecond'])
        ss.find('.input-number').eq(1).val(headBlend['skinSecond'])
        st.find('.input-number').eq(0).val(headBlend['shapeThird'])
        st.find('.input-number').eq(1).val(headBlend['skinThird'])

        $('#fmix').find('input').val(parseFloat(headBlend['shapeMix']) * 100)
        $('#smix').find('input').val(parseFloat(headBlend['skinMix']) * 100)
        $('#tmix').find('input').val(parseFloat(headBlend['thirdMix']) * 100)
    }

    function SaveHeadBlend() {
        headBlend = {}
        headBlend["shapeFirst"] = $("#shapeFirst").val()
        headBlend["shapeSecond"] = $("#shapeSecond").val()
        headBlend["shapeThird"] = $("#shapeThird").val()
        headBlend["skinFirst"] = $("#skinFirst").val()
        headBlend["skinSecond"] = $("#skinSecond").val()
        headBlend["skinThird"] = $("#skinThird").val()
        headBlend["shapeMix"] = $("#shapeMix").val()
        headBlend["skinMix"] = $("#skinMix").val()
        headBlend["thirdMix"] = $("#thirdMix").val()
        $.post('http://raid_clothes/saveheadblend', JSON.stringify(headBlend))
    }

    function SaveFaceShape(ele) {
        $.post('http://raid_clothes/savefacefeatures', JSON.stringify({name: ele.attr('data-value'), scale: ele.val()}))
    }

    function SetupHeadStructure(data) {
        let sliders = $('#faceshape').find('.slider-range')
        for (const key of Object.keys(data)) {
            sliders.each(function() {
                if ($(this).attr('data-value') == key) {
                    $(this).val(parseFloat(data[key]) * 100)
                }
            })
        }
    }

    function SetupHeadOverlay(data) {
        for (var i = 0; i < data.length; i++) {
            var ele = $("#"+data[i]['name'])
            var inputs = ele.find("input")
            inputs.eq(0).val(parseInt(data[i]['overlayValue']))
            inputs.eq(1).val(parseInt(data[i]['overlayOpacity'] * 100))
            var palettes = ele.find('.color_palette_container').eq(0).find('.color_palette')
            $(palettes[data[i]['firstColour']]).addClass('active')
            palettes = ele.find('.color_palette_container').eq(1).find('.color_palette')
            $(palettes[data[i]['secondColour']]).addClass('active')
        }
    }

    function SaveHeadOverlay(ele) {
        var id = ele.parents('.panel').attr('id')
        var inputs = ele.parents('.panel-bottom').find('input')
        let opacity = inputs.eq(1).val() ? inputs.eq(1).val() : 0
        $.post('http://raid_clothes/saveheadoverlay', JSON.stringify({
            name: id,
            value: inputs.eq(0).val(),
            opacity: opacity
        }))
    }

    function AddPalettes() {
        $('.collapsible').collapsible();
        $('.color_palette_container').each(function () {
            $(this).empty()
            if ($(this).hasClass('haircol')) {
                $(this).append($(hairColors))
            }
            if ($(this).hasClass('makeupcol')) {
                $(this).append($(makeupColors))
            }
        });
        $('.color_palette').on('click', function() {
            var palettes = $(this).parents('.panel').find('.color_palette_container')

            $(this).parent().find('.color_palette').removeClass('active')
            $(this).addClass('active')

            if ($(this).parents('.panel').hasClass('hair')) {
                $.post('http://raid_clothes/savehaircolor', JSON.stringify({
                    firstColour: palettes.eq(0).find('.active').attr('value'),
                    secondColour: palettes.eq(1).find('.active').attr('value')
                }));
            }
            else {
                $.post('http://raid_clothes/saveheadoverlaycolor', JSON.stringify({
                    firstColour: palettes.eq(0).find('.active').attr('value'),
                    secondColour: palettes.eq(1).find('.active').attr('value'),
                    name: $(this).parents('.panel').attr('id')
                }));
            }
        })
    }

    function createPalette(array) {
        var ele_string = ""
        for (var i = 0; i < Object.keys(array).length; i++) {
            var color = array[i][0]+","+array[i][1]+","+array[i][2]
            ele_string += '<div class="color_palette" style="background-color: rgb('+color+')" value="'+i+'"></div>'
        }
        return ele_string
    }

    function SetupTatTotals(totals) {
        for (let i = 0; i < Object.keys(totals).length; i++) {
            $('#'+totals[i][0]).find('.total-number').text(totals[i][1])
        }
    }

    function SetupTatValues(data) {
        for (let i = 0; i < Object.keys(data).length; i++) {
            $('#'+data[i][0]).find('.input-number').val(data[i][1])
        }
    }
});
