$(function(){
	$('.noscroll').click(function(event) {
		event.preventDefault();
	});
	$('.noscroll').on('click', function(e) {e.preventDefault(); return true;});
});


$('.noscroll').on('click', function(e) {e.preventDefault(); console.log('This was in yagg_js'); return true;});   
