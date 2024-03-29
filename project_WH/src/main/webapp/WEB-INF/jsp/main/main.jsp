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

 <!-- Leaflet CSS 파일 -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <!-- Leaflet JavaScript 파일 -->
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<style>
.map {
	height: 650px;
    width: 80%;
}
</style>
<script type="text/javascript">
var sdLayer;
var sggLayer;
var bjdLayer;

$( document ).ready(function() {
	   let map = new ol.Map({ // OpenLayer의 맵 객체 생성.
	       target: 'map', // 맵 객체를 연결하기 위한 target. div의 id 값
	       layers: [ // 레이어 목록
	         new ol.layer.Tile({
	           source: new ol.source.XYZ({
	           url: "http://api.vworld.kr/req/wmts/1.0.0/<%= apiKey %>/Base/{z}/{y}/{x}.png"
	           })
	         })
	         ],
	        view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등의 설정
	        center: ol.proj.fromLonLat([128, 38]), // 128, 38
	        zoom: 7
	        })
	       });
	   
	   // 시도를 바꾸면 레이어 띄우고 시군구 출력
	   $('#sido').on('change',function(){
	        var selectSido = $(this).val();
	        var sdLon = $(this).find('option:selected').data('lon');
	        var sdLat = $(this).find('option:selected').data('lat');
	        
	        // 클릭하는 값에 따른 줌인, 줌아웃
	        map.getView().setCenter(ol.proj.fromLonLat([sdLon, sdLat]));
        	if (sdLon == 127.180516378024 && sdLat == 37.53646836591502 
        			|| sdLon == 128.2997863336443 && sdLat == 37.72182212067617
        			|| sdLon == 127.8318072559515 && sdLat == 36.740689905284555
        			|| sdLon == 127.14287064989863 && sdLat == 35.716659228669535
        			|| sdLon == 126.90130324480641 && sdLat == 34.87748508606095
        			|| sdLon == 128.7490633797642 && sdLat == 36.35156109608353
        			|| sdLon == 128.26116952805322 && sdLat == 35.32561264605758
        			|| sdLon == 126.84898689042168 && sdLat == 36.53054996802068){
		        map.getView().setZoom(9);
        	} else {
        		map.getView().setZoom(11);
        	}
	        
        	var cql_filter = "sd_cd = " + selectSido;
	       // console.log(selectSido);
	       // console.log(cql_filter);
	        var mapView = map.getView().calculateExtent();
	 	  // console.log(mapView);
	        
	 	  
	 
	         
	        if (sdLayer || sggLayer || bjdLayer) {
	        map.removeLayer(sdLayer);	
	        map.removeLayer(sggLayer);	
	        map.removeLayer(bjdLayer);	
	        } 
	    	
	        //시도 레이어 불러오기
	   		sdLayer = new ol.layer.Tile({
	   		name : 'selectedLayer',
	   		visible: true,
	   		source : new ol.source.TileWMS({
	   			url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
	   			params : {
	   				'version': '1.1.0',
                    'request': 'GetMap',
                    'CQL_FILTER': cql_filter,
                    'layers': 'now:tl_sd',
                    'bbox': [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997],
                    'width': '768',
                    'height': '718',
                    'srs': 'EPSG:3857',
                    'format': 'image/png'
	   			},
	   			serverType : 'geoserver',
	   		})
	   		});
	   		map.addLayer(sdLayer);
	   	
	   		
	   		// 시도 ajax
	        $.ajax({
	            url: '/selectSido.do',
	            type: 'post',
	            data: {"sido": selectSido},
	            dataType: 'json',
	            success: function(response) {
	                var selectSgg = $("#sgg");
	                var selectBjdRe = $("#bjd");
	                selectSgg.html("<option>-시/군/구-</option>");
	                selectBjdRe.html("<option>-범례선택-</option>");
	                for (var i = 0; i < response.length; i++) {
	                    var item = response[i];
	                    selectSgg.append("<option value='" + item.sgg_cd +"' data-lon = '"+ item.sgg_lon + "' data-lat = '" + item.sgg_lat + "'>" + item.sgg_nm + "</option>");
	                }
	            },
	            error : function(xhr, status, error){
	                alert(xhr + "---" + error + 'ajax 오류' + selectSido + "," + selectSgg);
	            }
	        }); // 시도 ajax end    
	   		
	        
	        
	   		})
	   
	   // 시군구를 선택하면 시군구 레이어 출력, 법정동 출력
	   $('#sgg').change(function(){
			  var selectSgg = $(this).val();
			  var cql_filter1 = "sgg_cd = " + selectSgg;
			  var sggLon = $(this).find('option:selected').data('lon');
		      var sggLat = $(this).find('option:selected').data('lat');
			 
		      map.getView().setCenter(ol.proj.fromLonLat([sggLon, sggLat]));
		      map.getView().setZoom(12);
			  
			  console.log(selectSgg);
			  console.log(cql_filter1);
				  
			   if (sggLayer) {
			        map.removeLayer(sggLayer);	
			        map.removeLayer(bjdLayer);	
			        }  
			  
			  // 시군구 레이어
			  sggLayer = new ol.layer.Tile({
				name : 'selectedLayer',
				visible : true,
				source : new ol.source.TileWMS({
					url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
					params : {
						'version' : '1.1.0',
						'request' : 'GetMap',
						'CQL_FILTER' : cql_filter1,
						'layers' : 'now:tl_sgg',
						'bbox' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5],
						'width' : '768',
						'height' : '718',
						'srs' : 'EPSG:3857',
						'format' : 'image/png'
					},
					serverType : 'geoserver',
				})
			  });
			  console.log(sggLayer);
			  map.addLayer(sggLayer);
			  
			  // 시군구 ajax
			  $.ajax({
					url: '/selectSgg.do',
					type: 'post',
					data: {"sgg": selectSgg},
					dataType: 'json',
					success: function(response) {
						var selectBjd = $("#bjd");
						selectBjd.html("<option>-범례선택-</option>");
						for (var i = 0; i < response.length; i++) {
							var item = response[i];
							selectBjd.append ("<option value='"+item.bjd_cd+"'>" + item.bjd_nm + "</option>");
						}
					},
					error : function(xhr, status, error){
						alert(xhr + "---" + error + 'ajax 오류' + selectSgg + "," + selectBjd);
					}
			  }); // 시군구 ajax end
		});
	   
	// 법정동 선택하면 법정동 레이어 출력
	   $('#bjd').change(function(){
			  var selectBjd = $(this).val();
			  var cql_filter2 = "bjd_cd = " + selectBjd;
			  //var sggLon = $(this).find('option:selected').data('lon');
		      //var sggLat = $(this).find('option:selected').data('lat');
			 
		     
			  
			  console.log(selectBjd);
			  console.log(cql_filter2);
				  
			   if (bjdLayer) {
			        	
			        map.removeLayer(bjdLayer);	 
			        
			        }  
			  
			  // 시군구 레이어
			  bjdLayer = new ol.layer.Tile({
				name : 'selectedLayer',
				visible : true,
				source : new ol.source.TileWMS({
					url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
					params : {
						'version' : '1.1.0',
						'request' : 'GetMap',
						'CQL_FILTER' : cql_filter2,
						'layers' : 'now:tl_bjd',
						'bbox' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5],
						'width' : '557',
						'height' : '768',
						'srs' : 'EPSG:3857',
						'format' : 'image/png'
					},
					serverType : 'geoserver',
				})
			  });
			  console.log(bjdLayer);
			  map.addLayer(bjdLayer);
	   })


 $("#transmit").on("click", function() {
          var test = $("#txtfile").val().split(".").pop();
		
          alert(test);
         var formData = new FormData();
         formData.append("testfile", $("#txtfile")[0].files[0]);
         
         if ($.inArray(test, [ 'txt' ]) == -1) {
             alert("pem 파일만 업로드 할 수 있습니다.");
             $("#txtfile").val("");
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

	// 범례
	function addLegend() {
                // 범례 내용을 HTML 형식으로 작성합니다.
                var legendContent = '<h4>범례</h4>' +
                                    '<p>카테고리 1: <span style="color:red;">■</span></p>' +
                                    '<p>카테고리 2: <span style="color:blue;">■</span></p>' +
                                    '<p>카테고리 3: <span style="color:green;">■</span></p>';

                // 범례를 지정한 div에 추가합니다.
                $('#legend').html(legendContent);
            }

            // 페이지 로드 시 범례를 추가합니다.
            addLegend();
      
	})
	

</script>
</head>
<body>

<!-- 지도가 들어갈 영역 시작 -->
<div id="map" class="map"></div>
<!-- 지도가 들어갈 영역 끝 -->

<!-- 주어진 코드에서 지도 영역 아래에 범례를 표시할 div를 추가합니다. -->
<!-- <div id="legend" style="padding: 10px; background-color: white; position: absolute; float:right ; bottom: 10px; left: 10px; z-index: 1000;"></div> -->

	
	<div>
	<select id="sido">
		<option>-시/도-</option>
		<c:forEach items="${list}" var="sd" >
		<option value="${sd.sd_cd}" data-lon="${sd.sd_lon}" data-lat="${sd.sd_lat}">${sd.sd_nm }</option>
		</c:forEach>
	</select>
	
	<select id="sgg">
		<option>-시/군/구-</option>
	</select>
	
	<select id="bjd">
		<option>-범례선택-</option>
	</select>
	
	<!-- 파일 업로드하기 -->
	<form id="uploadForm">
    	<input type="file" accept=".txt" id="txtfile" name="txtfile">
    </form>
    <button id="transmit">전송하기</button>
	</div>
	
</body>

</html>