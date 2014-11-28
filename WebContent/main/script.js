var array = $("arrayNum").val();

$(function() {
	$.post('checkboard.jsp', function(data){
		for(i=0; data[i]!=null; i++){
			$("#userboard").append("<li><a href=\"/board/main.jsp\">" + data[i].boardtitle + "</a></li>");
		}
		$("#userboard").append("<li>새 보드 생성하기<br>" +
				"<form method=\"post\"><input id=\"boardtitle\" type=\"text\" name=\"titlename\" placeholder=\"타이틀을 입력하세요\">" +
				"<button type=\"submit\" class=\"btn btn-default\" id=\"createboard\">생성하기</button></form></li>");
	});
});

$('#createboard').click(function(){
	$.post('createboard.jsp', {boardmaster:"qookms", boardtitle:$('#boardtitle').val()});
});