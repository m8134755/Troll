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

$.post('getuserinfo.jsp', function(data){
	$('#userid').html(data.userid);
	$('#username').html(data.username);
	$('#email').val(data.email);
}, 'json');

var newpasswordgroup = $('#newpassword').add('#newpasswordconfirm'); 

$('#password').keyup(function(){
	var password = $(this).val();
	
	if(password.length == 0){
		$(newpasswordgroup).attr('disabled', 'disabled').val('');
	}
	else{
		$(newpasswordgroup).removeAttr('disabled');
	}
});

$('button#modify').click(function(){
	var ispasswordchanged = $(newpasswordgroup).attr('disabled') == undefined? true : false;
	
	var email = $('#email').val();
	
	var requestdata = {
			email : email,
			pwchanged : ispasswordchanged
	};
	
	if(ispasswordchanged){
		var password = $('#password').val();
		var newpassword = $('#newpassword').val();
		var newpasswordconfirm = $('#newpasswordconfirm').val();
		
		if(newpassword.length == 0){
			setError('비밀번호를 입력해 주십시오.');
			return;
		}
		
		if(newpassword != newpasswordconfirm){
			setError("새 비밀번호가 일치하지 않습니다.");
			return;
		}
		
		password = sha256_digest(password);
		newpassword = sha256_digest(newpassword);
		
		requestdata.password = password;
		requestdata.newpassword = newpassword;
	}
	
	setProgress('서버로 정보를 전송하고 있습니다..');
	
	$.post('modifyuserinfo.jsp', requestdata, function(data){
		if(data.status == 1){
			setSuccess("정보가 수정되었습니다.");
		}
		else if(data.status == 0){
			setError("서버와의 통신 중 에러가 발생했습니다.");
		}
		else if(data.status == -1){
			setError("비밀번호가 맞지 않습니다.");
		}
	}, 'json');
});
	