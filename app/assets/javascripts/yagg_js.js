$(function(){
	$('.noscroll').click(function(event) {
		event.preventDefault();
	});
	$("[id$=link]").on('click', function(e) {e.preventDefault(); return true;});
});
