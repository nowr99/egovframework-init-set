<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지도지도</title>

<script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?apiKey=F3FE0D54-D4E4-31CE-8F63-D78D91404A35"></script>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<script>
</script>
<style>
    .map {
      height: 1060px;
      width: 100%;
    }
</style>
</head>
<body>
<script type="text/javascript">
  var map = null;  
  var draggableMarker;
  var testMarker;
  vworld.showMode = false;
   
   // 통합지도 초기화
  vworld.init(
    "vMap"  // rootDiv
    , "map-first" // mapType
    ,function() {         
      map = this.vmap;
      map.setBaseLayer(map.vworldBaseMap);
      map.setControlsType({"simpleMap":true});  //간단한 화면   
      
      map.zoomToExtent( new OpenLayers.Bounds(14123035.724857,4509818.1653226,14134921.682753,4514996.773988));
      map.zoomTo(8);

    }
    ,function (obj){SOPPlugin = obj; }//initCallback
    ,function (msg){alert('vworld init fail');}//failCallback
  );
  
  function callWhiteMode(){
    var wMode = new vworld.WhiteLayer();
    document.getElementById('mapType').value = 'WHITE';
  }
  
  function callMidnightMode(){
    var midnightMode = new vworld.MidnightLayer();
    document.getElementById('mapType').value = 'MIDNIGHT';
  }
  
  function setMode(type){
    vworld.setMode(type);
    if(type == 0){
      document.getElementById('mapType').value = '2D BASE';
    } else {
      document.getElementById('mapType').value = '2D RASTER';
    }
  }
  
  /**
   * 생산자가 가지고 있는 데이터 wms 방식으로 지도에 표출
   */
  // bjd
  function importWMS() {
     map.ImportWMSLayer('geoserver', {
        params : 'now',
        url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
        layers : 'tl_bjd', // 사용할 레이어
        bbox : [ 1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5 ],
        styles : '',
        version : '1.1.0', // WMS 버전
        srs : 'EPSG:3857', // SRS 좌표계
        format : 'image/png' // 리턴 타입
     });
  }
  // sgg
  function importWMS1() {
     map.ImportWMSLayer('geoserver1', {
        params : 'now',
        url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
        layers : 'tl_sgg', // 사용할 레이어
        bbox : [ 1.386872E7, 3906626.5, 1.4428071E7, 4670269.5 ],
        styles : '',
        version : '1.1.0', // WMS 버전
        srs : 'EPSG:3857', // SRS 좌표계
        format : 'image/png' // 리턴 타입
     });
  }
  // sd
  function importWMS2() {
     map.ImportWMSLayer('geoserver2', {
        params : 'now',
        url : 'http://localhost:8080/geoserver/now/wms?service=WMS',
        layers : 'tl_sd', // 사용할 레이어
        bbox : [ 1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997 ],
        styles : '',
        version : '1.1.0', // WMS 버전
        srs : 'EPSG:3857', // SRS 좌표계
        format : 'image/png' // 리턴 타입
     });
  }
  /**
   * 레이어 삭제
   */
  function removeWMS(geoserver) {

     //import한 레이어 이름 (ex:행정경계)
     var layer = map.getThemeLayerByName(geoserver);
     if (layer != null) {
        map.removeLayer(layer);
     }

  }

  function removeWMS1(geoserver1) {

     //import한 레이어 이름 (ex:행정경계)
     var layer = map.getThemeLayerByName(geoserver1);
     if (layer != null) {
        map.removeLayer(layer);
     }

  }
  function removeWMS2(geoserver2) {

     //import한 레이어 이름 (ex:행정경계)
     var layer = map.getThemeLayerByName(geoserver2);
     if (layer != null) {
        map.removeLayer(layer);
     }

  }
  function testEvt() {
     alert("evt start");
     map.addEvent("movestart", test123);
  }

  function test123(e) {
     alert("지도 시작이벤트");
  }
  
</script>

<!-- 지도가 들어갈 영역 시작 -->
<div id="vMap" style="width:70%;height:650px;left:0px;top:0px"></div>
<!-- 지도가 들어갈 영역 끝 -->
<div id="desc" style="padding:5px 0 0 5px;">
  <button type="button" onclick="javascript:setMode(0);" name="rpg_10" >base</button>
  <button type="button" onclick="javascript:setMode(1);" name="rpg_10" >raster</button>
  <button type="button" onclick="javascript:callWhiteMode();" name="rpg_10" >white</button>
  <button type="button" onclick="javascript:callMidnightMode();" name="rpg_10" >midnight</button>
  <input type="label" value="2D BASE"  id="mapType" style="border:none"/>
</div>

<!-- 외부레이어 시작-->
   <div id="desc" style="padding: 5px 0 0 5px;">
      <button type="button" onclick="javascript:importWMS();"
         name="importwms">BJD 추가</button>
      <button type="button" onclick="javascript:removeWMS('geoserver');"
         name="removewms">BJD 삭제</button>
      <button type="button" onclick="javascript:importWMS1();"
         name="importwms1">SGG 추가</button>
      <button type="button" onclick="javascript:removeWMS1('geoserver1');"
         name="removewms1">SGG 삭제</button>
      <button type="button" onclick="javascript:importWMS2();"
         name="importwms2">SD 추가</button>
      <button type="button" onclick="javascript:removeWMS2('geoserver2');"
         name="removewms2">SD 삭제</button>
   </div>


</body>

</html>