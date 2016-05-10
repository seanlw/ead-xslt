$(document).ready(function(){
  $('#listings .series ul').hide();
  $('#listings .series li').click(function(){
    var child = $(this).parent().find('> ul');
    child.toggle();
    if (child.is(':visible')) {
      $(this).addClass('open');
    }
    else {
      $(this).removeClass('open');
    }
  });

  $('#listings .series li').each(function(){
    if ($(this).parent().find('> ul').length > 0){
      $(this).addClass('has-children');
    }
  });

});