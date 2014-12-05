var listnum=0;
var first = [];
var after = [];
var firstcard = [];
var aftercard = [];
var startarea;
var arrivalarea;


$(function(){
	showlist();
	showcard();
	listmaking();
	listmakingcheck();
	createlist();
	boardnavi();
	currentmember();
});

function showlist(){
	$.post('checklist.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#userlist').append('<div class="col-md-2 col-xs-12 usercard">' + 
			'<div><a class="editlist" href=#>' + data[i].listtitle + '</a>' +
			'<form method="post"><input class = "listid" type="text" value="' + data[i].listid + '" hidden>' + 
				
			'<div class="editlistdiv hidden"><input class="editlisttitle" type="text" value="' + data[i].listtitle + '">' +
			'<button type="submit" class="btn btn-default editlistbtn">리스트수정</button>' + 
			'<button type="submit" class="btn btn-default deletelist">리스트삭제</button></form></div></div>' + 
			
			'<div class="cardarea"><br></div></div>');
			
			listnum++;
		}
		
		$(function() {
			$( "#userlist" ).sortable({
				start: function (event, ui) {
					for(i=0; i<$('.usercard').length; i++){
				    	first[i] = $('.listid').eq(i).val();
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
				    	if(first[i] != after[i]){
				    		start=i+1;
				    		check++;
				    	}
			    	}
			    	if(check != 0){
				    	$.post('changelist.jsp', {first:first[start-check], last:first[start-2], after:after[start-2], check:check}, function(){
							location.replace('/board');
					    });
			    	}
			    }
			});
			$( "#userlist" ).disableSelection();
		});
		
        
		$('.editlistbtn').click(function (event) {
			var test = $(this).index('.editlistbtn');
			event.preventDefault();
			$.post('updatelist.jsp', {liststatus:test, listtitle:$('.editlisttitle').eq(test).val()}, function(){
		    	location.replace('/board');
		    });	    
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
		
		$(".editlist").click(function(event){
		    var test = $('.editlist').index(this);
		    event.preventDefault();
		    $.ajax({
			    type: "POST", 
			    data: { 
			    	status: "editlist"+test
			    } ,
			    url: "checkedit.jsp",
			    cache: false,
			    success: function(data){
			    	if(data==0){
			    		$('.editlistdiv').eq(test).removeClass('hidden');
			    	}else{
			    		$('.editlistdiv').eq(test).addClass('hidden');
			    	}	        
			    }
		    });
		});
		
		
	});	
}



function showcard(){
	$.post('checkcard.jsp', function(data){
		for(k=0; k<listnum; k++){
			for(j=0; data[j]!=null; j++){
				if(data[j].cardmaster==$('.listid').eq(k).val()){
					$('.cardarea').eq(k).append('<div class="cardobj"><input class="cardid" type="text" value="' +
					data[j].cardid + '" hidden><a class="editcard" href=#>' + data[j].cardcontent +
					'</a>' + '<div class="editcarddiv hidden">' +
					'<form><input class="editcardcontent" type="text" value="' + data[j].cardcontent + '">' + 
					'<button type="submit" class="btn btn-default editcardbtn">카드수정</button>' + 
					'<button type="submit" class="btn btn-default deletecard">카드삭제</button><div><form></div>');	
				}
			}
			$('.usercard').eq(k).append('<div><a class="createnewcard" href=#>새 카드 생성하기</a>' + 
			'<div class="createcarddiv hidden"><form method="post"><input class="cardcontent" type="text" placeholder="내용을 입력하세요.">' +
			'<button type="submit" class="btn btn-default createcard">카드생성</button></form></div>');
		}
		
		$(function() {
		    $( ".cardarea" ).sortable({
		    	connectWith:".cardarea",
	    		start: function (event, ui){
	    			startarea = $('.cardarea').index(this);
	    			arrivalarea = $('.cardarea').index(this);
	    			for(i=0; i<$('.cardobj').length; i++){
				    	firstcard[i] = $('.cardid').eq(i).val();
			    	}
	            },
	            receive : function (event, ui)
	            {
	            	arrivalarea = $('.cardarea').index(this);
	            },
	            stop: function (event, ui) {
	            	var check=0;
			    	var start=0;
			    	for(i=0; i<$('.cardobj').length; i++){
			    		aftercard[i] = $('.cardid').eq(i).val();
			    	}
			    	for(i=0; i<$('.cardobj').length; i++){
				    	if(firstcard[i] != aftercard[i]){
			            	console.log(firstcard[i], aftercard[i]);
				    		start=i+1;
				    		check++;
				    	}
			    	}
			    	if(check != 0){
				    	$.post('changecard.jsp', {first:firstcard[start-check],
				    		after:aftercard[start-check+1], check:check, startarea:startarea, arrivalarea:arrivalarea,
				    		beforelist:$('.listid').eq(startarea).val(), afterlist:$('.listid').eq(arrivalarea).val()}, function(){
					    });
			    	}
			    	//if(check == 0 && startarea!=arrivalarea){
			    	//	$.post('changecard.jsp', {first:0, last:0,
				    //		after:0, check:0, startarea:startarea, arrivalarea:arrivalarea,
				    //		beforelist:$('.listid').eq(startarea).val(), afterlist:$('.listid').eq(arrivalarea).val()}, function(){
					 //   });
			    	//}
	            }
		    });
		    $( ".cardarea" ).disableSelection();
		    
		});
		
		
		
		$('.createcard').click(function (event) {
			var test = $('.createcard').index(this);
			event.preventDefault();
		    $.post('createcard.jsp', {liststatus:test, cardcontent:$('.cardcontent').eq(test).val()}, function(data){
		    	 location.replace('/board');
		    });	    
		});
		
		$(".createnewcard").click(function(event){
		    var test = $('.createnewcard').index(this);
		    event.preventDefault();
		    $.ajax({
			    type: "POST", 
			    data: { 
			    	status: "createcard"+test
			    } ,
			    url: "checkedit.jsp",
			    cache: false,
			    success: function(data){
			    	if(data==0){
			    		$('.createcarddiv').eq(test).removeClass('hidden');
			    	}else{
			    		$('.createcarddiv').eq(test).addClass('hidden');
			    	}	        
			    }
		    });
		});	
		
		$('.editcardbtn').click(function (event) {
			var test = $(this).index('.editcardbtn');
			event.preventDefault();
			$.post('updatecard.jsp', {cardid:$('.cardid').eq(test).val(), cardcontent:$('.editcardcontent').eq(test).val()},
				function(){
		    		location.replace('/board');
		    });	    
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
		
		$(".editcard").click(function(event){
		    var test = $('.editcard').index(this);
		    event.preventDefault();
		    $.ajax({
			    type: "POST", 
			    data: { 
			    	status: "editcard"+test
			    } ,
			    url: "checkedit.jsp",
			    cache: false,
			    success: function(data){
			    	if(data==0){
			    		$('.editcarddiv').eq(test).removeClass('hidden');
			    	}else{
			    		$('.editcarddiv').eq(test).addClass('hidden');
			    	}	        
			    }
		    });
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
	$.post('checkhistory.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$('#history').append('<li>' + data[i].historycontent + '</li>');
		}
	});
}

function listmaking(){
$('#makinglist').append('<div class="col-md-2 col-xs-12 makelist"><a id="createnewlist" href=#>새 리스트 생성하기</a>' +
		'<div id = "createnewlistdiv" class="hidden"><form method="post">' +
		'<input id="listtitle" type="text" name="listname" placeholder="리스트명을 입력하세요">' +
		'<button type="submit" class="btn btn-default" id="createlist">생성하기</button></form></div></div>');
}
function listmakingcheck(){
	$("#createnewlist").click(function(event){
	    event.preventDefault();
	    $.ajax({
		    type: "POST", 
		    data: { 
		    	status: "createlist"
		    } ,
		    url: "checkedit.jsp",
		    cache: false,
		    success: function(data){
		    	if(data==0){
		    		$('#createnewlistdiv').removeClass('hidden');
		    	}else{
		    		$('#createnewlistdiv').addClass('hidden');
		    	}	        
		    }
	    });
	});	
}

function createlist(){
	$('#createlist').click(function (event) {
		event.preventDefault();
	    $.post('createlist.jsp', {listtitle:$('#listtitle').val()}, function(data){
	    	 location.replace('/board');
	    });	    
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
			console.log("1");
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
			$('.form-group.member').append('<label class=rmmember>'+ data[i].member +'<input class="btn btn-danger removemember" type="button" value="' + data[i].memberid + '"></label>');
		}
		if(data[0] == null)
		{
			$('.form-group.member').append('<div class=nomember>현재 초대되어 있는 멤버가 없습니다</div>');
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
