var Yum = {
  // Ripped from hurl.it
  // apply label hints to inputs based on their title attribute
  labelHints: function(el) {
    $(el).each(function() {
      var self = $(this), title = self.attr('title')
 
      // indicate inputs using defaults
      self.addClass('defaulted')
 
      if (self.val() === '' || self.val() === title) {
        self.val(title).css('color', '#aaa')
      } else {
        self.addClass('focused')
      }
 
      self.focus(function() {
        if (self.val() === title) {
          self.val('').addClass('focused').css('color', '#333')
        }
      })
 
      self.blur(function() {
        if (self.val() === '') {
          self.val(title).removeClass('focused').css('color', '#aaa')
        }
      })
    })
  }
}

$(document).ready(function() {
  // in-field labels
  Yum.labelHints('input');
  
  $('.playembed').click(function(event){
    //alert("Clicked!");
    $(this).children('#embed').toggle();
    // $('#player').append(self.code)
  });

})