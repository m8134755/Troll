$(function() {
	setProgress("정보를 받아오고 있습니다");
	$.post('checkboard.jsp', function(data){
		dismissProgress();
		for(i=0; data[i]!=null; i++){
			$('#userboard').append('<div class="col-md-3"><button type="button" class="close deleteboard"><span aria-hidden="true">&times;</span></button>'+
					'<button class="btn btn-lg btn-primary btn-block enterboard" style="line-height: 5;">'+data[i].boardtitle+'</button>'+
					'<div class="editboard"><form><input class = "boardid" type="text" value="' + data[i].boardid + '" hidden>' + 
					'</form></div>');
			
			$('#boardlist').append('<li><a class="enterboardmenu" href=#>' + data[i].boardtitle + '</a></li>');
		}
		
		$("#createnewboard").click(function(event){
			$('#boardtitle').val("");
		});
		
		$('#createboard').click(function (event) {
			event.preventDefault();
			var board_title = $('#boardtitle').val();
			if(board_title == ""){
				setError("타이틀을 입력해주세요");
			} else {
			    $.post('createboard.jsp', {boardtitle:board_title}, function(data){
			    	 location.replace('/main');
			    });	    
			}
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
	
	setProgress("정보를 받아오고 있습니다");
	$.post('checkinvitedboard.jsp', function(data){
		dismissProgress();
		for(j=0; data[j]!=null; j++){
			$('#invitedboard').append('<div class="col-md-3"><button type="button" class="close leaveboard"><span aria-hidden="true">&times;</span></button>'+
					'<button class="btn btn-lg btn-primary btn-block enterinvitedboard">'+data[j].boardtitle+'</button>'+data[j].boardmaster+'</div>' +
					'<form><input class = "invitedboardid" type="text" value="' + data[j].boardid + '" hidden>' + 
					'</form></div>');
			$('#boardlist').append('<li><a class="enterinvitedboardmenu" href=#>' + data[j].boardtitle + '</a></li>');
		}
		$('.enterinvitedboard').click(function (event) {
			var test = $(this).index('.enterinvitedboard');
			event.preventDefault();
			$.post('enterinvitedboard.jsp', {boardid:test}, function(){
		    	location.replace('/board/');
		    });	    
		});		
		$('.enterinvitedboardmenu').click(function (event) {
			var test = $(this).index('.enterinvitedboardmenu');
			event.preventDefault();
			$.post('enterinvitedboard.jsp', {boardid:test}, function(){
		    	location.replace('/board/');
		    });	    
		});
		$('.leaveboard').click(function(event){
			var test = $(this).index('.leaveboard');
			event.preventDefault();
			if (confirm("보드에서 나가시겠습니까?")) {
				$.post('leaveboard.jsp', {boardid:$('.invitedboardid').eq(test).val()}, function(){
			    	location.replace('/main');
			    });
			}else{
				return false;
			}
		});
	});
	$.post('checknotice.jsp', function(data){
		for(i=0; data[i]!=null && i!=5; i++){
				$('#historylist').append('<li><div class="alert alert-info alert-dismissible" role="alert">'+
						'<button class="close" data-dismiss="alert"></button>'
						+'<small>'+data[i].noticecontent+'</small></div></li>');
			
		}
	});
});