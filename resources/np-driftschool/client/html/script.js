var open = false;
$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type == "enabletestdrive") {
            open = event.data.enable;
            if (open) {
                document.body.style.display = "block";
                $("#testdrive").attr("style", "display: block");
            } else {
                document.body.style.display = "none";
                $("#testdrive").attr("style", "display: none");
            }
        }
    })

    function closeMenu() {
        document.body.style.display = "none";
        $("#testdrive").attr("display", "none");
    }

    $('.secondary-content').on('click', function() {
        closeMenu();
        $.post('http://np-driftschool/spawntestdrive', JSON.stringify({model: $(this).parents('li').attr('value')}));
    })

    $('#close').on('click', function() {
        closeMenu();
        $.post('http://np-driftschool/closemenu', JSON.stringify({}));
    })
})