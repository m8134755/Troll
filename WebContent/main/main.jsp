<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	
%>
<div class="title">
    <div class="container">
    	사용할 보드(Board)를 선택해주세요.
    </div>
</div>


<article class="container">
		<div class="row" id = "userboard">
			<h4>내가 생성한 보드</h4>
			<div class="col-md-3">
				<button id="createnewboard" class="btn btn-lg btn-default btn-block" style="margin-top:20px;" data-toggle="modal" data-target="#board_create_modal">Board 생성</button>
			</div>
		</div>
		<div class="row" id = "invitedboard">
			<h4>내가 초대되어있는 보드</h4>
		</div>
</article>


<div class="modal fade" id="board_create_modal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Board 생성</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label class="control-label">Board Title</label>
					<input class="form-control" id="boardtitle" type="text" placeholder="타이틀을 입력하세요">
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-primary" type="button" id="createboard">생성</button>  
		        <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
