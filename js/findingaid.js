$(document).ready(function(){
  $('#listings ul ul').hide();
  $('#listings li').each(function(){
    if ($(this).find('ul').length > 0) {
      $(this).addClass('has-children');
    }
  });

  $('.has-children').click(function(){
    if (this == event.target) {
      var child = $(this).find('>ul');
      child.toggle();
      if (child.is(':visible')) {
        $(this).addClass('open');
      }
      else {
        $(this).removeClass('open');
      }
    }
  });
});