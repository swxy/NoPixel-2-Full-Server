// Credit to Kanersps @ EssentialMode and Eraknelo @FiveM
function addGaps(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
  }
  return x1 + x2;
}
function addCommas(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',<span style="margin-left: 0px; margin-right: 1px;"/>' + '$2');
  }
  return x1 + x2;
}

$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;

  // Partial Functions
  function closeMain() {
    $(".home").css("display", "none");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function openMain() {
    $(".home").css("display", "block");
  }
  function closeAll() {
    $(".body").css("display", "none");
  }
  function openBalance() {
    $(".balance-container").css("display", "block");
  }
  function openWithdraw() {
    $(".withdraw-container").css("display", "block");
  }
  function openDeposit() {
    $(".deposit-container").css("display", "block");
  }
  function openTransfer() {
    $(".transfer-container").css("display", "block");
  }
  function openContainer() {
    $(".bank-container").css("display", "block");
  }
  function closeContainer() {
    $(".bank-container").css("display", "none");
  }
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Update HUD Balance
    if(item.updateBalance == true) {
      $('.balance').hide();
      if(item.show != false){
        $('.balance').show();
      }
      $('.balance').html('<p id="balance"><img id="icon" src="bank-icon.png" alt=""/>' +addGaps(event.data.balance)+'</p>');
      $('.currentBalance').html('$'+addCommas(event.data.balance));
      $('.username').html(event.data.name);
      if(item.show != false){
        setTimeout(function(){
          $('.balance').fadeOut(600)
        }, 4000)
      }
    }
    if(item.viewBalance == true) {
      $('.balance').show();
      $('.cash').show();
      setTimeout(function(){
        $('.balance').fadeOut(600)
        $('.cash').fadeOut(600)
      }, 8000)
    }
    if(item.viewCash == true) {
      $('.cash').show();
      setTimeout(function(){
        $('.cash').fadeOut(600)
      }, 8000)
    }
    if(item.updateCash == true) {
      $('.cash').hide();
      if(item.show != false){
        $('.cash').show();
      }
      $('.cash').html('<p id="cash"><span class="green"> $ </span>' +addGaps(event.data.cash)+'</p>');
      if(item.show != false){
        setTimeout(function(){
          $('.cash').fadeOut(600)
        }, 4000)
      }
    }
    // Trigger Add Balance Popup
    if(item.addBalance == true) {
      $('.transaction').show();
      var element = $('<p id="add-balance"><span class="pre">+</span><span class="green"> $ </span>' +addGaps(event.data.amount)+'</p>');
      $(".transaction").append(element);

      setTimeout(function(){
        $(element).fadeOut(600, function() { $(this).remove(); })
      }, 2000)
    }
    //Trigger Remove Balance Popup
    if(item.removeBalance == true) {
      $('.transaction').show();
      var element = $('<p id="add-balance"><span class="pre">-</span><span class="red"> $ </span>' +addGaps(event.data.amount)+'</p>');
      $(".transaction").append(element);
      setTimeout(function(){
        $(element).fadeOut(600, function() { $(this).remove(); })
      }, 2000)
    }
        // Trigger Add Balance Popup
    if(item.addCash == true) {
      $('.cashtransaction').show();
      var element = $('<p id="add-balance"><span class="pre">+</span><span class="green"> $ </span>' +addGaps(event.data.amount)+'</p>');
      $(".cashtransaction").append(element);

      setTimeout(function(){
        $(element).fadeOut(600, function() { $(this).remove(); })
      }, 2000)
    }
    //Trigger Remove Balance Popup
    if(item.removeCash == true) {
      $('.cashtransaction').show();
      var element = $('<p id="add-balance"><span class="pre">-</span><span class="red"> $ </span>' +addGaps(event.data.amount)+'</p>');
      $(".cashtransaction").append(element);
      setTimeout(function(){
        $(element).fadeOut(600, function() { $(this).remove(); })
      }, 2000)
    }
    // Open & Close main bank window
    if(item.openBank == true) {
      openContainer();
      openMain();
    }
    if(item.openBank == false) {
      closeContainer();
      closeMain();
    }
    // Open sub-windows / partials
    if(item.openSection == "balance") {
      closeAll();
      openBalance();
    }
    if(item.openSection == "withdraw") {
      closeAll();
      openWithdraw();
    }
    if(item.openSection == "deposit") {
      closeAll();
      openDeposit();
    }
    if(item.openSection == "transfer") {
      closeAll();
      openTransfer();
    }
  });
  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://banking/close', JSON.stringify({}));
    }
  };
  // Handle Button Presses
  $(".btnWithdraw").click(function(){
      $.post('http://banking/withdraw', JSON.stringify({}));
  });
  $(".btnDeposit").click(function(){
      $.post('http://banking/deposit', JSON.stringify({}));
  });
  $(".btnTransfer").click(function(){
      $.post('http://banking/transfer', JSON.stringify({}));
  });
  $(".btnBalance").click(function(){
      $.post('http://banking/balance', JSON.stringify({}));
  });
  $('.btnQuick').click($.throttle( 2000, true, function(e){
    $.post('http://banking/quickCash', JSON.stringify({}));
  }));
  $(".btnClose").click(function(){
      $.post('http://banking/close', JSON.stringify({}));
  });
  $(".btnHome").click(function(){
      closeAll();
      openMain();
  });
  // Handle Form Submits
  $("#withdraw-form").submit(function(e) {
      e.preventDefault();
      $.post('http://banking/withdrawSubmit', JSON.stringify({
          amount: $("#withdraw-form #amount").val()
      }));
      $("#withdraw-form #amount").prop('disabled', true)
      $("#withdraw-form #submit").css('display', 'none')
      setTimeout(function(){
        $("#withdraw-form #amount").prop('disabled', false)
        $("#withdraw-form #submit").css('display', 'block')
      }, 2000)

      $("#withdraw-form #amount").val('')
  });
  $("#deposit-form").submit(function(e) {
      e.preventDefault();
      $.post('http://banking/depositSubmit', JSON.stringify({
          amount: $("#deposit-form #amount").val()
      }));
      $("#deposit-form #amount").prop('disabled', true)
      $("#deposit-form #submit").css('display', 'none')
      setTimeout(function(){
        $("#deposit-form #amount").prop('disabled', false)
        $("#deposit-form #submit").css('display', 'block')
      }, 2000)
      $("#deposit-form #amount").val('')
  });
  $("#transfer-form").submit(function(e) {
      e.preventDefault();
      $.post('http://banking/transferSubmit', JSON.stringify({
          amount: $("#transfer-form #amount").val(),
          toPlayer: $("#transfer-form #toPlayer").val()
      }));
      $("#transfer-form #amount").prop('disabled', true)
      $("#transfer-form #toPlayer").prop('disabled', true)
      $("#transfer-form #submit").css('display', 'none')
      setTimeout(function(){
        $("#transfer-form #amount").prop('disabled', false)
        $("#transfer-form #submit").css('display', 'block')
        $("#transfer-form #toPlayer").prop('disabled', false)
      }, 2000)
      $("#transfer-form #amount").val('')
      $("#transfer-form #toPlayer").val('')
  });
});
