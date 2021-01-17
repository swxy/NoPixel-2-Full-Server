$(document).ready(function () {

    $('.timepicker').timepicker({
        twelveHour: false
    });

    $('textarea.lined').each(function (index, element) {
        let oldValue = this.value;

        $(this).on('input', function (e) {
            if (this.offsetHeight < this.scrollHeight) {
                this.value = oldValue;
            } else {
                oldValue = this.value;
            }
        });
    });

    // Mouse Controls
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var cursor = $('#cursor');
    var cursorX = documentWidth / 2;
    var cursorY = documentHeight / 2;

    $(document).mousemove(function (event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    function UpdateCursorPos() {
        $('#cursor').css('left', cursorX + 2);
        $('#cursor').css('top', cursorY + 2);
    }

    document.onkeyup = function (data) {
        // If Key == ESC -> Close Phone
        if (data.which == 27) {
            $.post('http://np-evidence/close', JSON.stringify({}));
        }
    }

    window.addEventListener('message', function (event) {
        var item = event.data;
        switch (item.openSection) {
            case "newEvidenceBag":
                $('.evidence-bag-container').fadeIn(300);
                let currentTime = moment().valueOf().toString();
                currentTime = currentTime.substr(currentTime.length - 8, currentTime.length);
                $('.evidence-bag-id').val(currentTime);
                $("#cursor").css("display", "block");
                break;
            case "close":
                $('.evidence-bag-container').fadeOut(300);
                $("#cursor").css("display", "none");
                break;
        }
    });
});