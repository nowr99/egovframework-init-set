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

<link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v6.15.1/build/ol.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<style>
.map {
	height: 650px;
    width: 80%;


}
#legend-container {
	position: absolute;
	bottom: 100px;
	right: 400px;
}

  
</style>
<script type="text/javascript">
var sdLayer;
var sdLayer1;
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
	        center: ol.proj.fromLonLat([128, 36]), // 128, 38
	        zoom: 7,
	        minZoom : 7,
            maxZoom : 17 
	        })
	       });
	   
	   // 시도를 바꾸면 시군구 출력
	   $('#sido').on('change',function(){
	        var selectSido = $(this).val();
	   		
	   		// 시도 ajax
	        $.ajax({
	            url: '/selectSido.do',
	            type: 'post',
	            data: {"sido": selectSido},
	            dataType: 'json',
	            success: function(response) {
	                var selectSgg = $("#sgg");
	                selectSgg.html("<option>-시/군/구-</option>");
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
	   
	   // 시군구를 법정동 출력
	   $('#sgg').change(function(){
			  var selectSgg = $(this).val();
			  
			  // 시군구 ajax
			  $.ajax({
					url: '/selectSgg.do',
					type: 'post',
					data: {"sgg": selectSgg},
					dataType: 'json',
					success: function(response) {
						var selectBjd = $("#bjd");
						selectBjd.html("<option>-법정동-</option>");
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
	
   // 범례 숨기기
   function hideLegend() {
	    var legendContainer1 = document.querySelector('#legend-container');
	    if (legendContainer1) {
	        legendContainer1.parentNode.removeChild(legendContainer1);
	    }
	}
      
            
     	   // 아무것도 선택하지 않고 검색 눌렀을때 시도 레이어 띄우기
     	   $('#search').on("click", function(){
     		  var selectedLegend = $('#legend1 option:selected').text();
     		  var selectedSido = $('#sido option:selected').text();
     		  var selectedSgg = $('#sgg option:selected').text();
     		  
     		  var sd = $('#sido').val();
     		  var sgg = $('#sgg').val();
     		  console.log(sd);
     		  console.log(sgg);
     		  
     		  var sdLon1 = $('#sido').find('option:selected').data('lon');
 	          var sdLat1 = $('#sido').find('option:selected').data('lat');
     		  
     		 	 if (sdLayer || sggLayer || bjdLayer || sdLayer1) {
     			        map.removeLayer(sdLayer);	
     			        map.removeLayer(sggLayer);	
     			        map.removeLayer(bjdLayer);	
     			        map.removeLayer(sdLayer1);	
     			        } 
     		 	 
     		   if (selectedSido == "-시/도-" && selectedLegend == "natural break") {
     		   sdLayer1 = new ol.layer.Tile({
     		   		name : 'selectedLayer',
     		   		visible: true,
     		   		source : new ol.source.TileWMS({
     		   			url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
     		   			params : {
     		   				'version': '1.1.0',
     	                    'request': 'GetMap',
     	                    'layers': 'now:b1_sd_view',
     	                    'bbox': [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997],
     	                    'width': '768',
     	                    'height': '718',
     	                    'srs': 'EPSG:3857',
     	                    'format': 'image/png'
     		   			},
     		   			serverType : 'geoserver',
     		   		})
     		   		});
     		   		hideLegend();
     		   		map.addLayer(sdLayer1);
     		   		map.getView().setCenter(ol.proj.fromLonLat([128, 36]));
     		     	map.getView().setZoom(7);
     		     	
     		    // 범례 이미지를 감싸는 새로운 <div> 요소를 만듭니다.
     		     	var legendContainer = document.createElement('div');
     		     	legendContainer.setAttribute('id', 'legend-container');
     		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
     		     	map.getTargetElement().appendChild(legendContainer);

     		     	// 범례 이미지 요청을 위한 URL 생성
     		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
     		     	    'service=WMS' +
     		     	    '&VERSION=1.0.0' +
     		     	    '&REQUEST=GetLegendGraphic' +
     		     	    '&LAYER=now:b1_sd_view' +
     		     	    '&FORMAT=image/png' +
     		     	    '&WIDTH=80' +
     		     	    '&HEIGHT=20';

     		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
     		     	var legendImg = document.createElement('img');
     		     	legendImg.src = legendUrl;

     		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
     		     	legendContainer.appendChild(legendImg);
     		     	
     		     	
     		   } else if (selectedSido == "-시/도-" && selectedLegend == "등간격"){
     			
     			  sdLayer1 = new ol.layer.Tile({
       		   		name : 'selectedLayer',
       		   		visible: true,
       		   		source : new ol.source.TileWMS({
       		   			url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
       		   			params : {
       		   				'version': '1.1.0',
       	                    'request': 'GetMap',
       	                    'layers': 'now:b1_sd_view1',
       	                    'bbox': [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997],
       	                    'width': '768',
       	                    'height': '718',
       	                    'srs': 'EPSG:3857',
       	                    'format': 'image/png'
       		   			},
       		   			serverType : 'geoserver',
       		   		})
       		   		});
     				hideLegend();
       		   		map.addLayer(sdLayer1);
	       		   	map.getView().setCenter(ol.proj.fromLonLat([128, 36]));
	 		     	map.getView().setZoom(7);
	 		     
	 		     	var legendContainer = document.createElement('div');
     		     	legendContainer.setAttribute('id', 'legend-container');
     		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
     		     	map.getTargetElement().appendChild(legendContainer);

     		     	// 범례 이미지 요청을 위한 URL 생성
     		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
     		     	    'service=WMS' +
     		     	    '&VERSION=1.0.0' +
     		     	    '&REQUEST=GetLegendGraphic' +
     		     	    '&LAYER=now:b1_sd_view1' +
     		     	    '&FORMAT=image/png' +
     		     	    '&WIDTH=80' +
     		     	    '&HEIGHT=20';

     		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
     		     	var legendImg = document.createElement('img');
     		     	legendImg.src = legendUrl;

     		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
     		     	legendContainer.appendChild(legendImg);
	 		     	
	 		     	
	 		     	
     		   } else if (selectedSido != "-시/도-" && selectedSgg == "-시/군/구-" && selectedLegend == "natural break") {
     			    var sdLon = $('#sido').find('option:selected').data('lon');
     		        var sdLat = $('#sido').find('option:selected').data('lat');
     		        var selectSido1 = $('#sido').val();
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
     		        
     	        	var cql_filter = "sgg_cd like " + "'" + selectSido1 + "%'";
     		       // console.log(selectSido);
     		       // console.log(cql_filter);
     		         
     		        if (sdLayer || sggLayer || bjdLayer || sdLayer1) {
     		        map.removeLayer(sdLayer);	
     		        map.removeLayer(sggLayer);	
     		        map.removeLayer(bjdLayer);	
     		        map.removeLayer(sdLayer1);	
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
     	                    'layers': 'now:b1_sgg_view',
     	                    'bbox': [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997],
     	                    'width': '768',
     	                    'height': '718',
     	                    'srs': 'EPSG:3857',
     	                    'format': 'image/png'
     		   			},
     		   			serverType : 'geoserver',
     		   		})
     		   		});
     		        hideLegend();
     		   		map.addLayer(sdLayer);
     		   		
     		   	var legendContainer = document.createElement('div');
 		     	legendContainer.setAttribute('id', 'legend-container');
 		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
 		     	map.getTargetElement().appendChild(legendContainer);

 		     	// 범례 이미지 요청을 위한 URL 생성
 		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
 		     	    'service=WMS' +
 		     	    '&VERSION=1.0.0' +
 		     	    '&REQUEST=GetLegendGraphic' +
 		     	    '&LAYER=now:b1_sgg_view' +
 		     	    '&FORMAT=image/png' +
 		     	    '&WIDTH=80' +
 		     	    '&HEIGHT=20';

 		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
 		     	var legendImg = document.createElement('img');
 		     	legendImg.src = legendUrl;

 		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
 		     	legendContainer.appendChild(legendImg);
     		   		
     		   		
     		   	
     		   } else if (selectedSido != "-시/도-" && selectedSgg == "-시/군/구-" && selectedLegend == "등간격") {
     			    var sdLon = $('#sido').find('option:selected').data('lon');
     		        var sdLat = $('#sido').find('option:selected').data('lat');
     		        var selectSido1 = $('#sido').val();
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
     		        
     	        	var cql_filter = "sgg_cd like " + "'" + selectSido1 + "%'";
     		       // console.log(selectSido);
     		       // console.log(cql_filter);
     		         
     		        if (sdLayer || sggLayer || bjdLayer || sdLayer1) {
     		        map.removeLayer(sdLayer);	
     		        map.removeLayer(sggLayer);	
     		        map.removeLayer(bjdLayer);	
     		        map.removeLayer(sdLayer1);	
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
     	                    'layers': 'now:b1_sgg_view1',
     	                    'bbox': [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997],
     	                    'width': '768',
     	                    'height': '718',
     	                    'srs': 'EPSG:3857',
     	                    'format': 'image/png'
     		   			},
     		   			serverType : 'geoserver',
     		   		})
     		   		});
     		        hideLegend();
     		   		map.addLayer(sdLayer);
     		   		
     		   	var legendContainer = document.createElement('div');
 		     	legendContainer.setAttribute('id', 'legend-container');
 		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
 		     	map.getTargetElement().appendChild(legendContainer);

 		     	// 범례 이미지 요청을 위한 URL 생성
 		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
 		     	    'service=WMS' +
 		     	    '&VERSION=1.0.0' +
 		     	    '&REQUEST=GetLegendGraphic' +
 		     	    '&LAYER=now:b1_sgg_view1' +
 		     	    '&FORMAT=image/png' +
 		     	    '&WIDTH=80' +
 		     	    '&HEIGHT=20';

 		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
 		     	var legendImg = document.createElement('img');
 		     	legendImg.src = legendUrl;

 		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
 		     	legendContainer.appendChild(legendImg);
     		   		
     		  } else if (selectedLegend == "-범례선택-") {
        		   
    			   alert ("범례를 선택 해주세요.");
    		   }
    		  
     		   		
     		  // 시군구에 법정동 포함 레이어 natural break
     		  if (selectedSgg != "-시/군/구-" && selectedLegend == "natural break") {
  			  var cql_filter = "bjd_cd like " + "'" + sgg + "%'";
  			  var sggLon = $('#sgg').find('option:selected').data('lon');
  		      var sggLat = $('#sgg').find('option:selected').data('lat');
  			 
  		      map.getView().setCenter(ol.proj.fromLonLat([sggLon, sggLat]));
  		      map.getView().setZoom(12);
  				  
  			   if (sggLayer) {
  			        map.removeLayer(sggLayer);	
  			        }  
  			   
  			  sggLayer = new ol.layer.Tile({
  				name : 'selectedLayer',
  				visible : true,
  				source : new ol.source.TileWMS({
  					url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
  					params : {
  						'version' : '1.1.0',
  						'request' : 'GetMap',
  						'CQL_FILTER' : cql_filter,
  						'layers' : 'now:b1_bjd_view',
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
  			  hideLegend();
  			  map.addLayer(sggLayer);
     		   		
  			var legendContainer = document.createElement('div');
		     	legendContainer.setAttribute('id', 'legend-container');
		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
		     	map.getTargetElement().appendChild(legendContainer);

		     	// 범례 이미지 요청을 위한 URL 생성
		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
		     	    'service=WMS' +
		     	    '&VERSION=1.0.0' +
		     	    '&REQUEST=GetLegendGraphic' +
		     	    '&LAYER=now:b1_bjd_view' +
		     	    '&FORMAT=image/png' +
		     	    '&WIDTH=80' +
		     	    '&HEIGHT=20';

		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
		     	var legendImg = document.createElement('img');
		     	legendImg.src = legendUrl;

		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
		     	legendContainer.appendChild(legendImg);
  			  
  			   } else if (selectedSgg != "-시/군/구-" && selectedLegend == "등간격") {
  				 var cql_filter = "bjd_cd like " + "'" + sgg + "%'";
  	  			  var sggLon = $('#sgg').find('option:selected').data('lon');
  	  		      var sggLat = $('#sgg').find('option:selected').data('lat');
  	  			 
  	  		      map.getView().setCenter(ol.proj.fromLonLat([sggLon, sggLat]));
  	  		      map.getView().setZoom(12);
  	  				  
  	  			   if (sggLayer) {
  	  			        map.removeLayer(sggLayer);	
  	  			        }  
  	  			   
  	  			  sggLayer = new ol.layer.Tile({
  	  				name : 'selectedLayer',
  	  				visible : true,
  	  				source : new ol.source.TileWMS({
  	  					url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
  	  					params : {
  	  						'version' : '1.1.0',
  	  						'request' : 'GetMap',
  	  						'CQL_FILTER' : cql_filter,
  	  						'layers' : 'now:b1_bjd_view1',
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
  	  			  hideLegend();
  	  			  map.addLayer(sggLayer);
  	  			  
  	  			var legendContainer = document.createElement('div');
 		     	legendContainer.setAttribute('id', 'legend-container');
 		     	// 맵 요소의 상대적인 위치에 범례 컨테이너를 추가합니다.
 		     	map.getTargetElement().appendChild(legendContainer);

 		     	// 범례 이미지 요청을 위한 URL 생성
 		     	legendUrl = 'http://localhost:8080/geoserver/now/wms?' +
 		     	    'service=WMS' +
 		     	    '&VERSION=1.0.0' +
 		     	    '&REQUEST=GetLegendGraphic' +
 		     	    '&LAYER=now:b1_bjd_view1' +
 		     	    '&FORMAT=image/png' +
 		     	    '&WIDTH=80' +
 		     	    '&HEIGHT=20';

 		     	// 범례 이미지를 추가할 HTML <img> 엘리먼트를 생성합니다.
 		     	var legendImg = document.createElement('img');
 		     	legendImg.src = legendUrl;

 		     	// 범례 이미지를 범례 컨테이너에 추가합니다.
 		     	legendContainer.appendChild(legendImg);
  	  			  
  			   }
     		   		
     	   });
	
     	//epsg_cd값 설정
     	  var epsg_cd = 'EPSG:3857';

     	  //map클릭했을 때 이벤트
     	  map.on('singleclick', function(evt) {
     	      map.forEachLayerAtPixel(evt.pixel, function(layer) {
     	              showLayer(layer, evt.coordinate); //layer와 coordinate넘기기
     	          });
     	  });
     	   
     	  function showLayer(layer, coordinate) {
     	  var viewResolution = /** @type {number} */ (map.getView().getResolution());
     	  		//featureInfoUrl설정
     	          var url = layer.getSource().getGetFeatureInfoUrl(
     	              coordinate, viewResolution, epsg_cd,
     	              {
     	                  'INFO_FORMAT': 'application/json',      
     	                  'VERSION': '1.1.1',
     	                  'FEATURE_COUNT' : 10,
     	              }
     	  		);
     	  		url = changeXY(url);
     	  	
     	      //ajax를 통해 feature값 가져오기
     	  	$.ajax({
     	  		url : "/selectSido.do",
     	  		dataType : "json",
     	  		success : function(data) {
     	  			//console.log(data.features[0]);
     	  			var value = data.features[0].properties.sig_cd;
     	         		 }
     	          });
     	  	}
	
     	   
     	   
     	   
	
	})
	

</script>
</head>
<body>

<!-- 지도가 들어갈 영역 시작 -->
<div id="map" class="map"></div>
<!-- 지도가 들어갈 영역 끝 -->


<!-- 팝업 -->
<div id="popup" class="ol-popup">
      <a href="#" id="popup-closer" class="ol-popup-closer"></a>
      <div id="popup-content"></div>
</div>


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
	
	<select id="legend1">
		<option>-범례선택-</option>
		<option>등간격</option>
		<option>natural break</option>
	</select>
	
	<button id="search">검색</button>
	
	<!-- 파일 업로드하기 -->
	<form id="uploadForm">
    	<input type="file" accept=".txt" id="txtfile" name="txtfile">
    </form>
    <button id="transmit">전송하기</button>
	</div>
	
</body>

</html>