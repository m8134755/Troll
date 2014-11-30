$(function() {
	$.post('checkboard.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#userboard').append('<div class="col-md-3 col-xs-12"><a class="enterboard" href=#>' + data[i].boardtitle + '</a><br>' + 
			'<form><input class = "boardid" type="text" value="' + data[i].boardid + '" hidden>' + 
			'<button type="submit" class="btn btn-default deleteboard">삭제하기</button></form></div>');
			$('#boardlist').append('<li><a class="enterboardmenu" href=#>' + data[i].boardtitle + '</a></li>');
		}
		
		$('#userboard').append('<div class="col-md-3 col-xs-12">새 보드 생성하기<br><form method="post"><input id="boardtitle" type="text" name="titlename" placeholder="타이틀을 입력하세요">' +
		'<button type="submit" class="btn btn-default" id="createboard">생성하기</button></form></div>');

		$('#createboard').click(function (event) {
			event.preventDefault();
		    $.post('createboard.jsp', {boardtitle:$('#boardtitle').val()}, function(data){
		    	 location.replace('/main');
		    });	    
		});

		$('.deleteboard').click(function (event) {
			var test = $(this).index('.deleteboard');
			event.preventDefault();
			if (confirm("보드를 삭제하시겠습니까?")) {
				$.post('deleteboard.jsp', {boardid:$('.boardid').eq(test).val()}, function(){
			    	location.replace('/main');
			    });
			}else{
				return false;
			}
		    	    
		});
		
		$('.enterboard').click(function (event) {
			var test = $(this).index('.enterboard');
			event.preventDefault();
			$.post('enterboard.jsp', {boardid:test}, function(){
		    	location.replace('/board/');
		    });	    
		});
		
		$('.enterboardmenu').click(function (event) {
			var test = $(this).index('.enterboardmenu');
			event.preventDefault();
			$.post('enterboard.jsp', {boardid:test}, function(){
		    	location.replace('/board/');
		    });	    
		});
		
	});
});