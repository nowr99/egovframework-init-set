<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>통계 페이지</title>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<!-- jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- Bootstrap JavaScript 파일 추가 -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
   
	google.charts.load('current', {'packages':['bar']});   // Google Charts 로드
    google.charts.setOnLoadCallback(drawChart);  // 로드 완료 후 drawChart 함수 호출


        $(function() {
            $('#showStatus').click(function(){
                var sdCd1 = $('#loc').val();
                var allSelected = $('#loc option:selected').attr('id') === 'all';
                //alert(sdCd1);
                //alert(allSelected);
                console.log(sdCd1);
                console.log(allSelected);
                
                if(allSelected){   // 전체 선택 옵션
                    $.ajax({
                        type     : 'POST',
                        url      : 'allSelec.do',
                        dataType : 'json',
                        success: function(response){
                            drawChart(response);
                            drawTable(response);
                        },
                        error: function(xhr, status, error) {
                            console.error(error);
                        }
                    });
                }else if(!allSelected){    // 시 선택 옵션
                	$.ajax({
                        type     : 'POST',
                        url      : 'siSelecChart.do',
                        dataType : 'json',
                        data: { 'sdCd1': sdCd1 },  //선택된 값 전송
                        success: function(response){
                            drawChart22(response);
                        },
                        error: function(xhr, status, error) {
                            console.error(error);
                        }
                    });
                	$.ajax({     // 시 선택 옵션
                        type     : 'POST',
                        url      : 'siSelecTable.do',
                        dataType : 'json',
                        data: { 'sdCd1': sdCd1 },  //선택된 값 전송
                        success: function(response){
                        	drawTable22(response);
                        },
                        error: function(xhr, status, error) {
                            console.error(error);
                        }
                    });
                }
            });
        });

    function drawChart(response) {   // 전체 선택시 차트 만드는 함수 
        if (!response || response.length < 1) {
            //alert('시/도를 선택해 주세요.');
            return;
        }

        var data = [['Category','전기 사용량']];
        response.forEach(function(item) {
            data.push([item.sd_nm, item.sitotalusage]);
        });

        var chartData = google.visualization.arrayToDataTable(data);

        var options = {
            chart: {
                title: '시도 사용량',
                subtitle: 'Sales, Expenses, and Profit: 2014-2017',
            },
            tooltip: {trigger: 'both', isHtml: true },
            bar: {groupWidth: '50%'},
            animation: {
                startup: true,
                duration: 1000,
                easing: 'linear'
            },
            hAxis: {
                textStyle: { fontSize: 10 }, 
            },
            vAxis: {
                textStyle: { fontSize: 12, fontWeight: 'bold'}
            },
            chartArea: { 
                width: '75%',
                height: '93%'
            },
            bars: 'horizontal',
            focusTarget: 'category'
        };

        var chart = new google.visualization.BarChart(document.getElementById('charts'));
        chart.draw(chartData, options);
    }
    
    function drawChart22(response) {   // 특정 시 선택시 차트 만드는 함수
        if (!response || response.length < 1) {
            alert('시/도를 선택해 주세요.');
            return;
        }

        var data = [['Category','전기 사용량']];
        response.forEach(function(item) {
            data.push([item.sd_nm, item.usage]);
        });

        var chartData = google.visualization.arrayToDataTable(data);

        var options = {
            chart: {
                title: '시도 사용량',
                subtitle: 'Sales, Expenses, and Profit: 2014-2017',
            },
            /*
            tooltip: {trigger: 'both', isHtml: true },
            bar: {groupWidth: '50%'},
            animation: {
                startup: true,
                duration: 1000,
                easing: 'linear'
            },
            hAxis: {
                textStyle: { fontSize: 10 }, 
            },
            vAxis: {
                textStyle: { fontSize: 12, fontWeight: 'bold'}
            },
            chartArea: { 
                width: '75%',
                height: '143%'
            },
            bars: 'horizontal',
            focusTarget: 'category'
        };
        */
            tooltip: { trigger: 'both', isHtml: true },
            bar: { groupWidth: '50%' },
            animation: {
                startup: true,
                duration: 1000,
                easing: 'linear'
            },
            hAxis: {
                textStyle: { fontSize: 10 },
            },
            vAxis: {
                textStyle: { fontSize: 12, fontWeight: 'bold' }
            },
            bars: 'horizontal',
            focusTarget: 'category'
        };

        // 데이터 개수에 따라 차트 영역 크기 설정
        if (response.length > 10 && response.length <= 16) {
            options.chartArea = { width: '75%', height: '143%' };
            options.hAxis.textStyle.fontSize = 8; // hAxis의 폰트 크기 조정
            options.vAxis.textStyle.fontSize = 10; // vAxis의 폰트 크기 조정
        } else if (response.length > 17){
            options.chartArea = { width: '75%', height: '223%' };
            options.hAxis.textStyle.fontSize = 6; // hAxis의 폰트 크기 조정
            options.vAxis.textStyle.fontSize = 8; // vAxis의 폰트 크기 조정
        }
        
        var tableDiv = document.getElementById('table');
        if (response.length > 10) {
            tableDiv.style.maxHeight = '1600px';
        } else if (response.length > 17) {
            tableDiv.style.maxHeight = '2400px';
        }
		
        var chart = new google.visualization.BarChart(document.getElementById('charts'));
        chart.draw(chartData, options);
    }

    function drawTable(response) {
        var tableHtml = '<table class="table"><thead style="position: sticky; top: 0; background-color: white; z-index: 1;"><tr><th>지역 이름</th><th>전기 사용량(kWh)</th></tr></thead><tbody>';
        
        response.forEach(function(item) {
            tableHtml += '<tr><td>' + item.sd_nm + '</td><td>' + item.sitotalusage.toLocaleString() + '</td></tr>';
        });

        tableHtml += '</tbody></table>';
        $('#table').html(tableHtml).css({
            'max-height': '450px',
            'overflow-y': 'auto',
            'background-color': 'white'
        });
        
    }
    
    function drawTable22(response) {
        var tableHtml = '<table class="table"><thead style="position: sticky; top: 0; background-color: white; z-index: 1;"><tr><th>지역 이름</th><th>전기 사용량(kWh)</th></tr></thead><tbody>';
        
        response.forEach(function(item) {
            tableHtml += '<tr><td>' + item.sgg_nm + '</td><td>' + item.usage.toLocaleString() + '</td></tr>';
        });

        tableHtml += '</tbody></table>';
        $('#table').html(tableHtml).css({
            'max-height': '450px',
            'overflow-y': 'auto',
            'background-color': 'white'
        });
    }
</script>
<style>
#table thead th {
    border: 1px solid black;
}

#table tbody td {
    border: 1px solid black;
}
</style>
</head>
<body>
<div>
   <div>
        <select id="loc" name="loc">
            <option>시/도 선택</option>
            <option id="all" value="${sitotalusage}">전체 선택</option>
            <c:forEach items="${list}" var="row2">
                <option id="sd" value="${row2.sd_cd}">${row2.sd_nm}</option>
            </c:forEach>
        </select>
   </div><br>
   <button type="button" class="btn btn-secondary" id="showStatus" data-bs-toggle="modal" data-bs-target="#myModal">통계 보기</button>
	   
   <!-- 위 버튼 누르면 작동하는 모달 -->
   <div class="modal fade" id="myModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
     <div class="modal-dialog modal-xl">
       <div class="modal-content" style="width: 1300px; height: 1050px;">
         <div class="modal-header">
           <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
         </div>
         <div class="modal-body">
           <div>
		       <div id="charts" style="width: 1200px; height: 400px;"></div>
		       <div id="table" style="max-height: 1200px; overflow-y: auto;"></div>
  			</div>
         </div>
         <div class="modal-footer">
           <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
         </div>
       </div>
     </div>
   </div>
	   
	   
</div>
</body>
</html>