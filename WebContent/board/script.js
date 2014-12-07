var listnum=0;
var before = [];
var after = [];
var beforecard = [];
var aftercard = [];
var startarea;
var arrivalarea;

$(function(){
	showlist();
	showcard();
	createlist();
	boardnavi();
	currentmember();
});



function showlist(){
	$.post('checklist.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#userlist').append('<div class="col-md-2 col-xs-12 usercard">' +
					'<div class="panel panel-default"><div class="panel-heading">'+
					'<h3 class="panel-title">'+data[i].listtitle+'<input class = "listid" type="text" value="' + data[i].listid + '" hidden>'+	
					'<button class="btn btn-xs btn-default pull-right editlist" data-toggle="modal" '+
					' data-target=".editlistdiv' + data[i].listid + '">수정</button></div></h3>'+
					'<ul class="list-group" style="padding-left: 0px;"><li class="list-group-item cardarea"></li>' + 
					'<li class="list-group-item createcardarea"></li></ul>' +

					
					'<div class="modal fade editlistdiv' + data[i].listid + '"><div class="modal-dialog"><div class="modal-content">'+
					'<div class="modal-header"><h4 class="modal-title">리스트 수정 및 삭제</h4></div><div class="modal-body">' +
					'<div class="form-group"><label class="control-label">List Title</label>'+
					'<input class="form-control editlisttitle" type="text" value="' + data[i].listtitle + '">' +
					'</div></div><div class="modal-footer"><button class="btn btn-primary editlistbtn" type="button">리스트수정</button>'+
					'<button class="btn btn-danger deletelist" type="button">리스트삭제</button>' +
					'<button type="button" class="btn btn-default" data-dismiss="modal">취소</button></div></div></div></div>');
			
			listnum++;
		}
		
		$(function() {
			$( "#userlist" ).sortable({
				start: function (event, ui) {
					for(i=0; i<$('.usercard').length; i++){
						before[i] = $('.listid').eq(i).val();
						after[i] = $('.listid').eq(i).val();
			    	}
			    },
			    receive : function (event, ui)
			    {
			    },
			    stop: function (event, ui) {
			    	var check=0;
			    	var start=0;
			    	for(i=0; i<$('.usercard').length; i++){
			    		after[i] = $('.listid').eq(i).val();
			    	}
			    	for(i=0; i<$('.usercard').length; i++){
				    	if(before[i] != after[i]){
				    		start=i+1;
				    		check++;
				    	}
			    	}
			    	
			    	
			    	if(before[start-check] == after[start-check+1] && before[start-check+1] == after[start-check]){
			    		$.post('changelist.jsp', {beforearrayfirst:before[start-check], beforearraysecond:before[start-check+1],
			    		afterarrayfirst:after[start-check], afterarraysecond:after[start-check+1], check:check, endarray:before[start-1]}, function(){
			    			location.replace('/board');
		    			});
			    	}else if(after[start-check+1] == before[start-check]){
			    		$.post('changelist.jsp', {beforearrayfirst:before[start-check], beforearraysecond:before[start-check+1],
				    		afterarrayfirst:after[start-check], afterarraysecond:after[start-check+1], check:check, endarray:before[start-1]}, function(){
				    		location.replace('/board');
		    			});
			    	}else if(before[start-check+1] == after[start-check]){
			    		$.post('changelist.jsp', {beforearrayfirst:before[start-check], beforearraysecond:before[start-check+1],
				    		afterarrayfirst:after[start-check], afterarraysecond:after[start-check+1], check:check, endarray:before[start-1]}, function(){
				    		location.replace('/board');
		    			});
			    	}
			    }
			});
			$( "#userlist" ).disableSelection();
		});
		
        
		$('.editlistbtn').click(function (event) {
			event.preventDefault();
			var test = $(this).index('.editlistbtn');
			if($('.editlisttitle').eq(test).val() == "" || $('.editlisttitle').eq(test).val().trim() == 0){
				setError("타이틀을 입력해주세요");
			}else{
				$.post('updatelist.jsp', {liststatus:test, listtitle:$('.editlisttitle').eq(test).val()}, function(){
			    	location.replace('/board');
			    });	
			}   
		});
		
		$('.deletelist').click(function (event) {
			var test = $(this).index('.deletelist');
			event.preventDefault();
			if (confirm("리스트를 삭제하시겠습니까?")) {
				$.post('deletelist.jsp', {liststatus:test}, function(){
			    	location.replace('/board');
			    });
			}else{
				return false;
			} 	    
		});			
	});	
}


function showcard(){
	$.post('checkcard.jsp', function(data){
		for(k=0; k<listnum; k++){
			for(j=0; data[j]!=null; j++){
				if(data[j].cardmaster==$('.listid').eq(k).val()){
					$('.cardarea').eq(k).append('<li class="list-group-item card_obj"><input class="cardid" type="text" value="' +
					data[j].cardid + '" hidden><button class="btn btn-md btn-default btn-block editlist" data-toggle="modal" '+
					' data-target=".editcarddiv' + data[j].cardid + '">' + data[j].cardcontent +'</button>' +
					
					'<div class="modal fade editcarddiv' + data[j].cardid + '"><div class="modal-dialog"><div class="modal-content">'+
					'<div class="modal-header"><h4 class="modal-title">카드 수정 및 삭제</h4></div><div class="modal-body">' +
					'<div class="form-group"><label class="control-label">Card Content</label>'+
					'<input class="form-control editcardcontent" type="text" value="' + data[j].cardcontent + '">' +
					'</div></div><div class="modal-footer"><button class="btn btn-primary editcardbtn" type="button">카드수정</button>'+
					'<button class="btn btn-danger deletecard" type="button">카드삭제</button>' +
					'<button type="button" class="btn btn-default" data-dismiss="modal">취소</button></div></div></div></div></li>');
					
				}
			}
			$('.createcardarea').eq(k).append('<li class="list-group-item"><button class="btn btn-md btn-default createnewcard" data-toggle="modal" '+
				' data-target=".createcarddiv' + $('.listid').eq(k).val() + '">새 카드 생성하기</button>' +
			
			'<div class="modal fade createcarddiv' + $('.listid').eq(k).val() + '"><div class="modal-dialog"><div class="modal-content">'+
			'<div class="modal-header"><h4 class="modal-title">카드 생성</h4></div><div class="modal-body">' +
			'<div class="form-group"><label class="control-label">Card Content</label>'+
			'<input class="form-control cardcontent" type="text" placeholder="카드 내용을 입력하세요.">' +
			'</div></div><div class="modal-footer"><button class="btn btn-primary createcard" type="button">카드생성</button>'+
			'<button type="button" class="btn btn-default" data-dismiss="modal">취소</button></div></div></div></li>');
		}
		
		$(function() {
		    $( ".cardarea" ).sortable({
		    	connectWith:".cardarea",
	    		start: function (event, ui){
	    			var test = $('.cardarea').index(this);
	    			startarea = $('.listid').eq(test).val();
	    			arrivalarea = $('.listid').eq(test).val();
	    			for(i=0; i<$('.cardid').length; i++){
	    				beforecard[i] = $('.cardid').eq(i).val();
	    				aftercard[i] = $('.cardid').eq(i).val();
			    	}
	            },
	            receive : function (event, ui)
	            {
	            	var test = $('.cardarea').index(this);
	            	arrivalarea = $('.listid').eq(test).val();
	            },
	            stop: function (event, ui) {
	            	var check=0;
			    	var start=0;
			    	for(i=0; i<$('.cardid').length; i++){
			    		aftercard[i] = $('.cardid').eq(i).val();
			    	}
			    	for(i=0; i<$('.cardid').length; i++){
				    	if(beforecard[i] != aftercard[i]){
				    		start=i+1;
				    		check++;
				    	}
			    	}
			    	
			    	if(check==0 && startarea != arrivalarea){
			    		$.post('changecard.jsp', {status:0, beforearrayfirst:beforecard[start-check], beforearraysecond:beforecard[start-check+1],
			    			afterarrayfirst:aftercard[start-check], afterarraysecond:aftercard[start-check+1], check:check, 
			    			startarea:startarea, arrivalarea:arrivalarea}, function(){
			    				location.replace('/board');
		    			});
			    	}else if(check!=0 && startarea == arrivalarea){
			    		$.post('changecard.jsp', {status:1, beforearrayfirst:beforecard[start-check], beforearraysecond:beforecard[start-check+1],
			    			afterarrayfirst:aftercard[start-check], afterarraysecond:aftercard[start-check+1], check:check, 
			    			startarea:startarea, arrivalarea:arrivalarea}, function(){
			    				location.replace('/board');
		    			});
			    	}else if(check!=0 && startarea != arrivalarea){
			    		$.post('changecard.jsp', {status:2, beforearrayfirst:beforecard[start-check], beforearraysecond:beforecard[start-check+1],
			    			afterarrayfirst:aftercard[start-check], afterarraysecond:aftercard[start-check+1], check:check, 
			    			startarea:startarea, arrivalarea:arrivalarea}, function(){
			    				location.replace('/board');
		    			});
			    	}
	            }
		    });
		    $( ".cardarea" ).disableSelection();
		});
		
		
		
		$('.createcard').click(function (event) {
			var test = $('.createcard').index(this);
			event.preventDefault();
			if($('.cardcontent').eq(test).val() == "" || $('.cardcontent').eq(test).val().trim() == 0){
				setError("내용을 입력해주세요");
			}else{
				$.post('createcard.jsp', {liststatus:test, cardcontent:$('.cardcontent').eq(test).val()}, function(data){
			    	 location.replace('/board');
			    });
			} 
		   	    
		});
		
		$('.editcardbtn').click(function (event) {
			var test = $(this).index('.editcardbtn');
			event.preventDefault();
			if($('.editcardcontent').eq(test).val() == "" || $('.editcardcontent').eq(test).val().trim() == 0){
				setError("내용을 입력해주세요");
			}else{
				$.post('updatecard.jsp', {cardid:$('.cardid').eq(test).val(), cardcontent:$('.editcardcontent').eq(test).val()},
						function(){
					location.replace('/board');
					});	
			} 
			    
		});
		
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
}

function boardnavi(){
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
	$.post('/main/checkinvitedboard.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#boardlist').append('<li><a class="enterinvitedboardmenu" href=#>' + data[i].boardtitle + '</a></li>');
		}
		$('.enterinvitedboardmenu').click(function (event) {
			var test = $(this).index('.enterinvitedboardmenu');
			event.preventDefault();
			$.post('/main/enterinvitedboard.jsp', {boardid:test}, function(){
		    	location.replace('/board/');
		    });	    
		});
	});
	
	$.post('checkhistory.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#history').append('<div class="alert alert-info alert-dismissible" role="alert">'+
				'<button class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span></button>'
				+'<small>'+data[i].historycontent+'</small></div>');
		}
		for(i=0; data[i]!=null && i!=5; i++){

				$('#historylist').append('<li><div class="alert alert-info alert-dismissible" role="alert">'+
						'<button class="close" data-dismiss="alert"></button>'
						+'<small>'+data[i].historycontent+'</small></div></li>');
			
		}
	});
}

function createlist(){
	$('#createlist').click(function (event) {
		event.preventDefault();
		if($('#listtitle').val() == "" || $('#listtitle').val().trim() == 0){
			setError("타이틀을 입력해주세요");
		}else{
			 $.post('createlist.jsp', {listtitle:$('#listtitle').val()}, function(data){
		    	 location.replace('/board');
		    });
		} 
	   	    
	});
}

$('#findmember').click(function (event) {
	event.preventDefault();
	var id=$('#member_id').val();
	$.post('member.jsp', {userid: id} ,function(data1){
		if(data1.status == 1)
		{
			if(confirm(data1.memberid + "님을 현재보드의 멤버로 추가하시겠습니까?"))
			{
				$.post('addmember.jsp', {userid: id},function(data2){
					if(data2.status == 1)
					{
						
						setSuccess("현재 보드에 새 멤버가 추가되었습니다.");
						location.replace('/board');
						
					}
					else
					{
						setError("멤버추가에 실패하였습니다.");
					}
					
				});
			}
		}
		else if(data1.status == 2)
		{
			setError("초대 권한이 없습니다.");
		}
		else if (data1.status == 3)
		{
			setError("자신은 초대할 수 없습니다.");
		}
		else if (data1.status == 4)
		{
			setError("이미 초대되어있는 아이디입니다.");
		}
		else if(data1.status == 0)
		{
			setError("검색에 실패하였습니다.");
		}
		
	});
	
});
function setSuccess(string){

if($('div.loadingdiv').length == 0){
  $('<div class="loadingdiv fade"><div class="loading-container container hidden-xs"><img class="fade in success" src="/images/success.png"/><h2 class="fade in text-right">' + string + '</h2></div>' +
        '<div class="loading-container container visible-xs"><img class="fade in success" src="/images/success.png"/><h3 class="text-center fade in">' + string + '</h3></div></div>').ready(function(){setTimeout(function(){$('div.loadingdiv').addClass('in');}, 50);}).prependTo('body');
  $('div.loading-container h2, div.loading-container h3').html(string).addClass('in').css('color', '#3c763d');
  $('div.loadingdiv').click(function(){
     $(this).removeClass('in');
     setTimeout(function(){
        $('div.loadingdiv').remove();
     }, 300);
  });
  return;
}

$('div.loading-container h2, div.loading-container h3, div.loading').removeClass('in');
setTimeout(function(){
  $('div.loading-container h2, div.loading-container h3').html(string).addClass('in').css('color', '#3c763d');
  $('img.success').addClass('in');
}, 300);

$('div.loadingdiv').click(function(){
  $(this).removeClass('in');
  setTimeout(function(){
     $('div.loadingdiv').remove();
  }, 300);
});
}
function setError(string){

if($('div.loadingdiv').length == 0){
  $('<div class="loadingdiv fade"><div class="loading-container container hidden-xs"><img class="fade in fail" src="/images/fail.png"/><h2 class="fade in text-right">' + string + '</h2></div>' +
        '<div class="loading-container container visible-xs"><img class="fade in fail" src="/images/fail.png"/><h3 class="text-center fade in">' + string + '</h3></div></div>').ready(function(){setTimeout(function(){$('div.loadingdiv').addClass('in');}, 50);}).prependTo('body');
  $('div.loading-container h2, div.loading-container h3').html(string).addClass('in').css('color', '#a94442');
  $('div.loadingdiv').click(function(){
     $(this).removeClass('in');
     setTimeout(function(){
        $('div.loadingdiv').remove();
     }, 300);
  });
  return;
}

$('div.loading-container h2, div.loading-container h3, div.loading').removeClass('in');
setTimeout(function(){
  $('div.loading-container h2, div.loading-container h3').html(string).addClass('in').css('color', '#a94442');
  $('img.fail').addClass('in');
}, 300);

$('div.loadingdiv').click(function(){
  $(this).removeClass('in');
  setTimeout(function(){
     $('div.loadingdiv').remove();
  }, 300);
});
}
function currentmember(){
	$.post('currentmember.jsp',function(data){
		for(i=0 ; data[i] != null ; i++)
		{
			$('.member_area').append('<label class=rmmember>'+ data[i].member +'<input class="btn btn-danger removemember" type="button" value="' + data[i].memberid + '"></label>');
		}
		if(data[0] == null)
		{
			$('.member_area').append('<div class=nomember>현재 초대되어 있는 멤버가 없습니다</div>');
		}
		$('.removemember').click(function(event){
			event.preventDefault();
			if(confirm($(this).val()+"님을 멤버에서 삭제하시겠습니까?"))
			{
				var memberid = $(this).val();
				$.post('deletemember.jsp',{memberid: memberid} ,function(data){
					if(data.status == 0)
					{
						setError("멤버 삭제를 실패하였습니다.");
						
					}
					else if(data.status == 1)
					{
						setSuccess("멤버삭제에 성공하였습니다.");
						location.replace('/board');
					}
					else if(data.status == 2)
					{
						setError("멤버를 삭제할 권한이 없습니다.");
					}
					
				});
				
			}
			else
			{		
			}
		});
	});
}
