$(document).ready(function(){
  
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var curTask = 0;
  var processed = []
  var spaceHeld = false;
  var moveType = "cam"

  function openMain() {
    $(".furnitureMenu").fadeIn(10);
    $(".Help").fadeIn(10);
    
  }

  var help = false

  function closeMain() {
    
    $(".Help").css("display", "none");
    $(".furnitureMenu").css("display", "none");
    $(".SelectObject").css("display", "none");
  }  

  $(".btnClose").click(function(){
      closeMain()
      $.post('http://np-furniture/close', JSON.stringify({}));
  });

  $(".btnNew").click(function(){
      $(".wrapSelectObjects").css("display", "block");
      $(".SelectObject").css("display", "block");
  });

  $(".btnHelp").click(function(){
      if ( help ) {
        help = false;
        $(".Help").css("display", "none");
      } else {
        help = true;
        $(".Help").css("display", "block");
      }
  });

  $(".btnMove").click(function(){
      $(".wrapSelectObjects").css("display", "none");
      $(".SelectObject").css("display", "none");
      $.post('http://np-furniture/scanObject', JSON.stringify({}));
  });

  $(".btnFree").click(function(){
      $(".wrapSelectObjects").css("display", "none");
      $(".SelectObject").css("display", "none");
      $.post('http://np-furniture/FreeCam', JSON.stringify({}));
  });


  $(".btnModify").click(function(){
      $(".wrapSelectObjects").css("display", "none");
      $(".SelectObject").css("display", "none");
      $.post('http://np-furniture/newObject', JSON.stringify({}));

  });
  $(".btnLeaveDel").click(function(){
    $(".NextPrev").css("display", "none");
    $(".wrapbuttons").css("display", "block");
  });

  $(".btnDelObj").click(function(){
    $.post('http://np-furniture/DelSelectedObj', JSON.stringify({}));
  });


  $(".btnDel").click(function(){
      $(".wrapSelectObjects").css("display", "none");
      $(".SelectObject").css("display", "none");
      $(".wrapbuttons").css("display", "none");
      $(".NextPrev").css("display", "block");
      $.post('http://np-furniture/DelObj', JSON.stringify({}));
  });

  $(".btnNextObj").click(function(){
    $.post('http://np-furniture/NextObj', JSON.stringify({}));
  });
  $(".btnPrevObj").click(function(){
    $.post('http://np-furniture/PrevObj', JSON.stringify({}));
  });





  window.addEventListener('message', function(event){

    var item = event.data;
    if(item.openFurniture === true) {
      openMain();
    }

    if(item.wipeCategories === true) {
      $(".SelectObject").html("");

    }


    if(item.newOption === true) {

       var opt = document.createElement("option");

       opt.value = item.objectvar;
       opt.innerHTML = item.objectname;
      document.getElementById(item.category).append(opt);
    }

    if(item.newCategory === true) {
      g = document.createElement('select');
      g.setAttribute("id", item.category);
      $(".SelectObject").append(g); 
       var opt = document.createElement("option");
       opt.value = "none";
       opt.innerHTML = " * " + item.categoryname + " * ";
       g.append(opt);
    }

    if(item.redoCSS === true) {
      $('select').each(function(){
          var $this = $(this), numberOfOptions = $(this).children('option').length;
        
          $this.addClass('select-hidden'); 
          $this.wrap('<div class="select"></div>');
          $this.after('<div class="select-styled"></div>');

          var $styledSelect = $this.next('div.select-styled');
          $styledSelect.text($this.children('option').eq(0).text());
        
          var $list = $('<ul />', {
              'class': 'select-options'
          }).insertAfter($styledSelect);
        
          for (var i = 0; i < numberOfOptions; i++) {
              $('<li />', {
                  text: $this.children('option').eq(i).text(),
                  rel: $this.children('option').eq(i).val()
              }).appendTo($list);
          }
        
          var $listItems = $list.children('li');
        
          $styledSelect.click(function(e) {
              e.stopPropagation();
              $('div.select-styled.active').not(this).each(function(){
                  $(this).removeClass('active').next('ul.select-options').hide();
              });
              $(this).toggleClass('active').next('ul.select-options').toggle();
          });
        
          $listItems.click(function(e) {
              e.stopPropagation();
              $styledSelect.text($(this).text()).removeClass('active');
              $this.val($(this).attr('rel'));
              $list.hide();


              $.post('http://np-furniture/selectObject', JSON.stringify({selectObject: $this.val()}));
          });
        
          $(document).click(function() {
              $styledSelect.removeClass('active');
              $list.hide();
          });

      });
    }

    if(item.closeProgress === true) {
      closeMain();
    }

  });

});