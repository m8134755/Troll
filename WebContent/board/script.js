var listnum=0;
$(function() {
	$.post('checklist.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#userlist').append('<div class="col-md-4 col-xs-12 usercard">' + data[i].listtitle + 
			'<br><button type="submit" class="btn btn-default deletelist">삭제하기</button><br>' + 
			'<form method="post"><input class = "listid" type="text" value="' + data[i].listid + '" hidden>' + 
			'<div>새 카드 생성하기<br><input class="cardcontent" type="text" name="cardname" placeholder="내용을 입력하세요.">' +
			'<button type="submit" class="btn btn-default createcard">생성하기</button></div></form><div>');
			listnum++;
		}
		
		$.post('checkcard.jsp', function(data){
			for(k=0; k<listnum; k++){
				for(j=0; data[j]!=null; j++){
					if(data[j].cardmaster==$('.listid').eq(k).val()){
						$('.usercard').eq(k).append('<div><form><input class="cardid" type="text" value="' +
								data[j].cardid + '" hidden>' + data[j].cardcontent +
						'<button type="submit" class="btn btn-default deletecard">카드삭제</button><form></div>');	
					}
				}
			}
			$('.deletecard').click(function (event) {
				var test = $('.deletecard').index(this);
				event.preventDefault();
				if (confirm("카드를 삭제하시겠습니까?")) {
					$.post('deletecard.jsp', {cardid:$('.cardid').eq(test).val()}, function(data){
						location.replace('/board');
			    	});
				}else{
					return false;
				}
			});
		})
		
		$.post('/main/checkboard.jsp', function(data){
			for(i=0; data[i]!=null; i++){
				$('#boardlist').append('<li><a class="enterboardmenu" href=#>' + data[i].boardtitle + '</a></li>');
			}
			$('.enterboardmenu').click(function (event) {
				var test = $(this).index('.enterboardmenu');
				event.preventDefault();
				$.post('/main/enterboard.jsp', {boardid:test}, function(){
			    	location.replace('/board/');
			    });	    
			});
		});
		
		$('.createcard').click(function (event) {
			var test = $('.createcard').index(this);
			event.preventDefault();
		    $.post('createcard.jsp', {listid:$('.listid').eq(test).val(), cardcontent:$('.cardcontent').eq(test).val()}, function(data){
		    	 location.replace('/board');
		    });	    
		});
		
		$('#userlist').append('<div class="col-md-4 col-xs-12">새 리스트 생성하기<br><form method="post">' +
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
		
		$.post('checkhistory.jsp', function(data){
			for(i=0; data[i]!=null; i++){
				$('#history').append('<li>' + data[i].historycontent + '</li>');
			}
		});
	});
});