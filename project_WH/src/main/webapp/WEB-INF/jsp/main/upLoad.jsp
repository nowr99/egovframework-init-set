<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>파일 업로드</title>
<!-- SweetAlert2 -->

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@latest"></script>

<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>


<script type="text/javascript">

$("#transmit").on("click", function() {
    var test = $("#file").val().split(".").pop();
	
    //alert(test);
   var formData = new FormData();
   formData.append("file", $("#file")[0].files[0]);
   
   if ($.inArray(test, [ 'txt' ]) == -1) {
       alert("txt 파일만 업로드 할 수 있습니다.");
       $("#file").val("");
       return false;
    }
   
   $.ajax({
       url : "/fileUpload.do",
       type : 'post',
       enctype : 'multipart/form-data',
       //contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
       data : formData,
       contentType : false,
       processData : false,
       beforeSend : function() {
          modal();
       },
       success : function() {
          $('#uploadtext').text("업로드 완료");
          setTimeout(timeout,5000);
       } 
    })
       
 })


var timeout = function(){
$('#mask').remove();
$('#loading').remove();

}
function modal(){
    var maskHeight = $(document).height();
    var maskWidth = window.document.body.clientWidth;
    
    var mask = "<div id='mask' style='position:absolute;z-indx:5;background-color: rgba(0, 0, 0, 0.13);display:none;left:0;top:0;'></div>";
    var loading = "<div id='loading' style='background-color:white;width:500px'><h1 id='uploadtext' style='text-align:center'>업로드 진행중</h1></div>";
    
    $('body').append(mask);
    $('#mask').append(loading);
    
    $("#mask").css({
       'height':maskHeight,
       'width':maskWidth
    });
    
    $('#loading').css({
       /* 'position': 'absolute',
        'top': '50%',
         'left': '50%',
         'transform': 'translate(-50%, -50%)' */
       'position': 'absolute',
       'left': '800px',
       'top': '100px'

    })
    $('#mask').show();
    $('#loading').show();
 }

</script>
</head>
<body>

<!-- 파일 업로드하기 -->
	<div>
	<form id="uploadForm">
    	<input type="file" accept=".txt" id="file" name="file">
    </form>
    <button id="transmit">전송하기</button>
	</div>
</body>
</html>