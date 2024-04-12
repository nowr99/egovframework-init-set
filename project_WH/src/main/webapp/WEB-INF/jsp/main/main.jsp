<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.springframework.core.io.support.PropertiesLoaderUtils" %>
<%@ page import="java.util.Properties" %>

<%
   // 프로퍼티 파일에서 API 키를 읽어옴
   Properties properties = PropertiesLoaderUtils.loadAllProperties("property/globals.properties");
   String apiKey = properties.getProperty("Globals.apiKey");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta charset="UTF-8">
<title>지도지도</title>

<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<link rel="stylesheet"  href="https://cdn.jsdelivr.net/npm/ol@v6.15.1/ol.css">
<!-- bootstarp -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>

<style>
.map {
	height: 650px;
    width: 80%;
}
#menu{
cursor:pointer;
}

</style>
<script type="text/javascript">
var map;
$( document ).ready(function() {
	   
	 map = new ol.Map({ // OpenLayer의 맵 객체 생성.
	       target: 'map', // 맵 객체를 연결하기 위한 target. div의 id 값
	       layers: [ // 레이어 목록
	         new ol.layer.Tile({
	           source: new ol.source.XYZ({
	           url: "http://api.vworld.kr/req/wmts/1.0.0/<%= apiKey %>/Base/{z}/{y}/{x}.png"
	           })
	         })
	         ],
	        view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등의 설정
	        center: ol.proj.fromLonLat([128, 36]), // 128, 38
	        zoom: 7,
	        minZoom : 7,
            maxZoom : 17 
	        })
	       });
	   
	// upLoad jsp 불러오기
	$(".upLoad").click(function(e){
		e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
		$.ajax({
			type:'get',
			url : '/upLoad.do',
			dataType:'html',
			success:function(response){
				$("#views").html(response);
			},
			error:function(error){
				alert("업로드 에러");
			}
		});
	});  
	
	$(".mapp").click(function(e){
		e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
		
		$.ajax({
			type:'get',
			url : '/mapp.do',
			dataType:'html',
			success:function(response){
				$("#views").html(response);
			},
			error:function(error){
				alert("지도정보 에러");
			}
		});
	});	
	
	$(".statistics").click(function(e){
		e.preventDefault(); // 기본 동작 방지(화면 이동 방지)
		
		$.ajax({
			type:'get',
			url : '/statistics.do',
			dataType:'html',
			success:function(response){
				$("#views").html(response);
			},
			error:function(error){
				alert("통계정보 에러");
			}
		});
	});	
	
	
	})

</script>
</head>
<body>
<header class="bg-primary text-light py-3">
  		<div class="container text-center">
  		</div>
	</header>
<div class="container-fluid d-flex flex-column my-4" style="height: 80%;">
    <div class="row flex-grow-1 mx-3">
        <div class="col-md-4 d-flex flex-column pe-0">
            <div class="row">
                <div class="col-md-12 border border-dark">
                    <div class="text-center bold fs-3" style="height: 50px;">에너지 지도</div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 border border-dark border-end-0 border-top-0 p-0">
                        <div class="mapp align-middle border-bottom border-dark py-2" id="menu">
                            <i class="bi fs-5 ps-4"></i>지도보기
                        </div>
                        <div class="upLoad align-middle border-bottom border-dark py-2" id="menu">
                            <i class="bi fs-5 ps-3 pe-1"></i>업로드
                        </div>
                        <div class="statistics align-middle border-bottom border-dark py-2" id="menu">
                            <i class="bi fs-5 ps-3 pe-1"></i>통계
                        </div>
                </div>
                <div id ="views" class="col-md-9 p-3 fs-4 bold border border-dark border-top-0" style="height: 600px;">
					메뉴를 선택하세요.
                </div>
            </div>
        </div>
		<!-- 지도가 들어갈 영역 시작 -->
		<div class="col-md-8 pe-0">
			<div id="map" class="map"></div>
		</div>
		<!-- 지도가 들어갈 영역 끝 -->
    </div>
</div>

	
	
</body>

</html>