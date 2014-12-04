var idok = false;
var errorid = $('#errorid');
$('#inputid').change(function () {
    var userid = $(this).val();
    
    var re = /.*[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+.*/;
    var patt = new RegExp(" ");
    
    if(userid.length < 4){
    	$(errorid).removeClass('text-success hidden').addClass('text-danger').html('아이디가 너무 짧습니다.');
    	idok = false;
    }
    else if(re.test(userid)){
    	$(errorid).removeClass('text-success hidden').addClass('text-danger').html('아이디에 한글을 사용할 수 없습니다.');
    	idok = false;
    }
    else if(patt.test(userid)){
    	$(errorid).removeClass('text-success hidden').addClass('text-danger').html('아이디에 띄어쓰기를 사용할 수 없습니다.');
    	idok = false;
    }
    else{
    	$(errorid).removeClass('text-danger text-success hidden').html('아이디 중복 확인 중..');
        
        $.post('checkduplicateid.jsp', {userid : userid}, function(data){
        	if(data.status){
        		$(errorid).addClass('text-success').html('사용 가능한 아이디입니다.');
        		idok = true;
        	}
        	else{
        		$(errorid).addClass('text-danger').html('중복된 아이디입니다.');
        		idok = false;
        	}
        }, 'json');
        
    }
    toggleButton();
    
}); // 아이디를 입력하여 텍스트가 변경되고 다른 곳을 클릭할때
// 실시간으로 서버와 통신하여 아이디 중복 여부 확인

var errorpassword = $('#errorpassword');
var password;

$('#inputpassword').keyup(function () {
    password = $(this).val();
    
    if(password.length < 8){
    	$(errorpassword).removeClass('text-warning hidden').addClass('text-warning').html('좀 더 긴 비밀번호를 권장합니다.');
    }
    else{
    	$(errorpassword).removeClass('text-warning').addClass('hidden');
    }
    toggleButton();
}); // 비밀번호를 입력할 때마다 호출
// 비밀번호의 길이 및 보안 확인

var pwconfirmok = false;
var errorpasswordconfirm = $('#errorpasswordconfirm');

$('#inputpasswordconfirm').keyup(function(){
	
	var passwordconfirm = $(this).val();
	
	if(passwordconfirm == password || passwordconfirm.length == 0){
		$(errorpasswordconfirm).removeClass('text-danger').addClass('hidden').html('');
		pwconfirmok = true;
	}
	else{
		$(errorpasswordconfirm).removeClass('hidden').addClass('text-danger').html('비밀번호가 맞지 않습니다.');
		pwconfirmok = false;
	}
	toggleButton();
});

var erroremail = $('#erroremail');
var emailok = false;
$('#inputemail').keyup(function(){
	
	var emailconfirm = $(this).val();
	
	var re = /^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[@]{1}[-A-Za-z0-9_]+[-A-Za-z0-9_.]*[.]{1}[A-Za-z]{2,5}$/;
	
	if(re.test(emailconfirm) || emailconfirm.length == 0){
		$(erroremail).addClass('hidden').html('');
		emailok = true;
	}
	else{
		$(erroremail).removeClass('hidden').html('이메일 표현이 잘못되었습니다.');
		emailok = false;
	}
	toggleButton();
});


function toggleButton(){
	if(idok && pwconfirmok && emailok){
		$('#button_requestjoin').removeAttr('disabled');
	}
	else{
		$('#button_requestjoin').attr('disabled', 'disabled');
	}
}

$('#button_requestjoin').click(function(event){
	event.preventDefault();
	
	var password = $('#inputpassword').val();
	var pwdconfirm = $('#inputpasswordconfirm').val();
	
	if(password != pwdconfirm) {
		setError('비밀번호가 같지 않습니다.');
		return;
	}

	
	password = sha256_digest(password);
	pwdconfirm = sha256_digest(pwdconfirm);
	
	var requestdata = {
		userid : $('#inputid').val(),
		password : password,
		pwdconfirm : pwdconfirm,
		name : $('#inputname').val(),
		email : $('#inputemail').val()
	};
	
	$.post('requestjoin.jsp', requestdata, function(data){
		if(data.status){
			localStorage.joinsuccess = 1;
			location.replace('/login');
		}
		else{
			
			$('div.alert').removeClass('hidden').addClass('in');
			setTimeout(function(){
				$('div.alert').removeClass('in');
				setTimeout(function(){
					$('div.alert').addClass('hidden');
				}, 150);
			}, 3000);
		}
	}, 'json');
});

$('#cancel').click(function (event) {
    event.preventDefault();
    location.replace('/login');
});