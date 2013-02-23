$(function(){
	$('.noscroll').click(function(event) {
		event.preventDefault();
	});
	$('.noscroll').on('click', function(e) {e.preventDefault(); return true;});
});

