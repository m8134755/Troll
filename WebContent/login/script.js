 
if(window.android != undefined) window.android.getRegID();

function getRegID(regID){
	$.post('checkregid.jsp', {regid: regID}, function(data){
		if(data.status == 1) {
			location.href = "/main";
		}
	});
}

$('#login').click(function(event){
	event.preventDefault();
	
	var userid = $('#input_id').val();
	var password = $('#input_password').val();
	
	if(userid.length == 0 || password.length == 0){
		setError('정보를 입력해 주십시오.');
		return;
	}
	
	password = sha256_digest(password);
	
	setProgress('로그인 중입니다..');
	
	$.post('loginProc.jsp', {userid : userid, password : password}, function(data){
		if(data.status == 1){
			location.href = "/main";
		}
		else if(data.status == 0){
			setError("로그인에 실패하였습니다.");
			animation();
		}
	}, 'json');
	
});

$('button#findid').click(function(event){
	event.preventDefault();
	
	var inputname = $('input#input_id_name').val();
	var inputclass = $('input#input_id_class').val();
	
	if(inputname.length == 0 || inputclass.length == 0){
		setError('정보를 모두 입력해 주십시오.');
		return;
	}
	
	setProgress('검색 중입니다..');
	
	$.post('findid.jsp', {username: inputname, userclass: inputclass}, function(data){
		if(data.status == 1) setSuccess('아이디 정보가 푸시 알림으로 전송되었습니다.');
		else setError('검색에 실패하였습니다.<br/>계정 정보가 없거나 푸시가 등록되어 있지 않습니다.');
	});
});

$('button#findpw').click(function(event){
	event.preventDefault();
	
	var inputid = $('input#input_pw_id').val();
	var inputname = $('input#input_pw_name').val();
	var inputclass = $('input#input_pw_class').val();
	
	if(inputid.length == 0 || inputname.length == 0 || inputclass.length == 0){
		setError('정보를 모두 입력해 주십시오.');
		return;
	}
	
	setProgress('검색 중입니다..');
	
	$.post('findpassword.jsp', {userid: inputid, username: inputname, userclass: inputclass}, function(data){
		if(data.status == 1) setSuccess('변경된 비밀번호가 푸시 알림으로 전송되었습니다.');
		else setError('검색에 실패하였습니다.<br/>계정 정보가 없거나 푸시가 등록되어 있지 않습니다.');
	});
});

$('#join').click(function(){
	location.href = "/join";
});

if(localStorage.joinsuccess){
	setSuccess("회원 가입 신청이 완료되었습니다.");
	localStorage.removeItem("joinsuccess");
}

function animation(){
	$('#animated').addClass('shake animated');
	setTimeout(function(){
		$('#animated').removeClass('shake animated');
	}, 1000);
}

function setProgress(string){
	$('<div class="loadingdiv fade"><div class="loading-container container hidden-xs"><div class="loading fade in"></div><img class="fade success" src="/images/success.png"/><img class="fade fail" src="/images/fail.png"/><h2 class="fade in text-right">' + string + '</h2></div>' +
			'<div class="loading-container container visible-xs"><div class="loading fade in"></div><img class="fade success" src="/images/success.png"/><img class="fade fail" src="/images/fail.png"/><h3 class="text-center fade in">' + string + '</h3></div></div>').ready(function(){setTimeout(function(){$('div.loadingdiv').addClass('in');}, 50);}).prependTo('body');
}

function dismissProgress(){
	$('div.loadingdiv').removeClass('in');
	setTimeout(function(){
		$('div.loadingdiv').remove();
	}, 300);
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
