<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	
%>
<div class="title">
    <div class="container">
    	<h2><%= session.getAttribute("boardtitle") %></h2>
    </div>
</div>

<div class="row">
	<div class="col-md-2">
		<div id="history">
		</div>
	</div>
	<div class="col-md-9">
		<div class="row">
			<div id="userlist">
				
			</div>
			<div class="col-md-2">
				<button class="btn btn-default" data-toggle="modal" data-target="#list_create_modal">리스트 생성</button>
			</div>

		</div>
	</div>
	<div class="col-md-1">
		<button class="btn btn-primary btn-block" data-toggle="modal" data-target="#addmember">멤버 추가</button>
	</div>
</div>

   


<div class="modal fade" id="addmember">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h4 class="modal-title">멤버 추가</h4>
            </div>
            <div class="modal-body">
               <h3>멤버 추가</h3>
               <h4><small>추가하고 싶은 멤버의 아이디를 입력하세요.</small></h4>
               <form class="form-horizontal">
                  <div class="form-group">
                     <label for="member_id" class="col-xs-2 control-label">아이디</label>
                     <div class="col-xs-10">
                        <input type="text" class="form-control" id="member_id"/>
                     </div>
                  </div>
                  <button id="findmember" type="button" class="btn btn-default btn-block">멤버 검색</button>
               </form>
               <h3>멤버삭제</h3>
               <h4><small>삭제하고 싶은 멤버의 아이디를 클릭하세요.</small></h4>
					<form class="form-horizontal">
						<div class="member_area">
						</div>
					</form>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
         </div>
      </div>
   </div>

<div class="modal fade" id="list_create_modal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">List 생성</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label class="control-label">List Title</label>
					<input class="form-control" id="listtitle" type="text" placeholder="타이틀을 입력하세요">
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-primary" type="button" id="createlist">생성</button>  
		        <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>
