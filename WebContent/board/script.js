var listnum=0;
$(function() {
	$.post('checklist.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#userlist').append('<div class="col-xs-4 usercard">' + data[i].listtitle + 
			'<br><button type="submit" class="btn btn-default deletelist">삭제하기</button><br>' + 
			'<form method="post"><input class = "listid" type="text" value="' + data[i].listid + '" hidden>' + 
			'<div>새 카드 생성하기<br><input class="cardcontent" type="text" name="cardname" placeholder="내용을 입력하세요.">' +
			'<button type="submit" class="btn btn-default createcard">생성하기</button></div></form><div>');
			listnum++;
		}
		for(i=0; i<listnum; i++){
			showcard(i);
		}
		
		$('.createcard').click(function (event) {
			var test = $('.createcard').index(this);
			event.preventDefault();
		    $.post('createcard.jsp', {listid:$('.listid').eq(test).val(), cardcontent:$('.cardcontent').eq(test).val()}, function(data){
		    	 location.replace('/board');
		    });	    
		});
		
		$('#userlist').append('<div class="col-xs-4">새 리스트 생성하기<br><form method="post">' +
		'<input id="listtitle" type="text" name="listname" placeholder="리스트명을 입력하세요">' +
		'<button type="submit" class="btn btn-default" id="createlist">생성하기</button></form></div>');
		
		$('#createlist').click(function (event) {
			event.preventDefault();
		    $.post('createlist.jsp', {listtitle:$('#listtitle').val()}, function(data){
		    	 location.replace('/board');
		    });	    
		});

		$('.deletelist').click(function (event) {
			var test = $(this).index('.deletelist');
			event.preventDefault();
			if (confirm("리스트를 삭제하시겠습니까?")) {
				$.post('deletelist.jsp', {listid:$('.listid').eq(test).val()}, function(){
			    	location.replace('/board');
			    });
			}else{
				return false;
			} 	    
		});
		
		function showcard(num){
			$.post('checkcard.jsp', {listid:$('.listid').eq(num).val()}, function(data){	
				for(j=0; data[j]!=null; j++){
					$('.usercard').eq(num).append('<div><form><input class="cardid" type="text" value="' +
							data[j].cardid + '" hidden>' + data[j].cardcontent +
					'<button type="submit" class="btn btn-default deletecard">카드삭제</button><form></div>');
				}
				$('.deletecard').click(function (event) {
					var test = $('.deletecard').index(this);
					event.preventDefault();
					$.post('deletecard.jsp', {cardid:$('.cardid').eq(test).val()}, function(data){
						location.replace('/board');
			    	});
				});
			})	
		}
	});
});