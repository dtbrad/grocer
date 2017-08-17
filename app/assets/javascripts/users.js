$(document).ready(function() {

	$('#reset_password').hide()
  $('#resend_confirmation_instructions').hide()

  $('#toggle_reset_password').click(function(){
    $('#reset_password').toggle()
    if ($('#reset_password').is(':visible')){
      $('#resend_confirmation_instructions').hide()
    }
  });
  $('#toggle_resend_confirmation_instructions').click(function(){
    $('#resend_confirmation_instructions').toggle()
    if ($('#resend_confirmation_instructions').is(':visible')){
      $('#reset_password').hide()
    }

  })



});
