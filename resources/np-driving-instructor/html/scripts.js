$(document).ready(function () {
  let isOpen = false;
  let readOnly = false;
  let curTest = {
    cid: 0,
    instructor: '',
    points: 10,
    passed: true,
    results: {}
  };
  const passingGrade = 0;

  function setData(data, readOnly) {
    curTest = Object.assign({ cid: 0, instructor: '', points: 10, passed: true, results: {} }, data);
    curTest.points = 10;

    $("#instructor-name").html(curTest.instructor);
    if (parseInt(curTest.cid) != -1) {
      $("input[name='cid']").val(parseInt(curTest.cid));
    } else {
      $("input[name='cid']").val('');
    }
    
    if (readOnly) {
      $("input[name='cid']").attr("disabled", true);
    } else {
      $("input[name='cid']").removeAttr("disabled");
    }
    
    $('.input__group input').each(function () {
      const _self = $(this);
      const name = _self.prop('name');
      
      if (curTest.results[name]) {
        if (typeof curTest.results[name] === "boolean") {
          curTest.results[name] = 1;
        }
        const amount = Number(curTest.results[name]);
        _self.val(amount);
      } else {
      	_self.val(0);
      }
      
      if (readOnly) {
        _self.attr("disabled", true);
      } else {
        _self.removeAttr("disabled");
      }
    });    

    checkScore();
  }

  function closeGui() {
    if (readOnly) {
      // Don't record data
      $.post('http://np-driving-instructor/close', JSON.stringify({ cid: -1, points: 10, passed: true, results: {} }));
    } else {
      curTest.results = {};

      $('.input__group input').each(function () {
        const _self = $(this);
        const name = _self.prop('name');
        curTest.results[name] = Number($(this).val());
      });

      $.post('http://np-driving-instructor/close', JSON.stringify({ cid: curTest.cid, points: curTest.points, passed: curTest.passed, results: curTest.results }));
    }
  }

  function calculatePoints() {
    curTest.points = 10; // Reset points to calculate off of
    $('.input__group input').each(function () {
      const _self = $(this);
      const name = _self.prop('name');            
      if (curTest.results[name]) {
        const amount = Number(curTest.results[name]);
        curTest.points = curTest.points - Number(_self.data('points') * amount);        
      }
    });
  }

  function checkScore() {
  	calculatePoints();
    
    let display = $('#points-remaining').first();
    if (curTest.points > passingGrade) {
      display.removeClass('fail').addClass('pass');
      curTest.passed = true;
    } else {
      display.removeClass('pass').addClass('fail');
      curTest.passed = false;
    }
    display.text(curTest.points);
  }

  // Listen for NUI Events
  window.addEventListener('message', function (event) {
    let item = event.data;

    if (item.close === true) {
      closeGui();
    } else if (item.show === true) {
      setData(item.data, item.readonly);
      $('.container').fadeIn(100);
      $('.clipboard').fadeIn(100);
      $('#cursor').css('display', 'block');
      // Delay so it has time to load
      setTimeout(() => {
        isOpen = true;
        if (item.readonly) {
          readOnly = true;
          $('.clipboard').attr("disabled", true);
        } else {
          readOnly = false;
          $('.clipboard').removeAttr("disabled");
        }
      }, 500);
    } else if (item.show === false) {
      $('.container').fadeOut(100);
      $('.clipboard').fadeOut(100);
      $('#cursor').css('display', 'none');
      isOpen = false;
    }
  });

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (!isOpen) return;

    if (data.which === 27) { // Escape
      closeGui();
      return;
    } else if ($(".input__number input").is(":focus")) {
      if (data.which === 13) { // Enter
        $(".input__number input").blur(); // Unfocus input box
        return;
      }
    }
  };

  $('.input__group input').on('focusin', function(){
    $(this).data('val', $(this).val());
  }).on('change', function(){
    const _self = $(this);
    const name = _self.prop('name');
    const prev = $(this).data('val');
    const current = $(this).val();
    let amount = current;
    
    // If new value is below 0, ignore the change and use the old value again
    if (current < 0) {
    	amount = prev;
      $(this).val(amount);
    }   

    curTest.results[name] = amount;

    $(this).data('val', amount);
    checkScore();
  });

  $("input[name='cid']").keyup(function () {
    curTest.cid = Number($(this).val());
  });
});
