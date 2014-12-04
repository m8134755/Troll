<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	
%>
<div class="title">
    <div class="container">
    	<%= session.getAttribute("boardtitle") %>
    </div>
</div>
<div class="modal fade">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h4 class="modal-title">멤버추가/삭제</h4>
               <h4>추가할 멤버의 아이디를 입력하세요.</h4>
            </div>
            <div class="modal-body">
               <h3>멤버 추가</h3>
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
               <h4>삭제하고 싶은 멤버의 아이디를 클릭하세요.</h4>
					<form class="form-horizontal">
					<div class="form-group member">
			
					</div>
					<!--  <button id="findpw" type="button" class="btn btn-default btn-block">멤버삭제</button>-->
					</form>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
         </div>
      </div>
   </div>
   <div class="text-center">
           <a data-toggle="modal" data-target=".modal">멤버추가/삭제</a> 
     </div>
<div class="col-md-2 col-xs-3">
	<ul class="list-unstyled"  id = "history">
	</ul>
</div>

<article class="container">
	<div class="row">
		<div class="col-md-12" id="userlist">
		</div>
		<div class="col-md-12" id="makinglist">
		</div>
	</div>
</article>

