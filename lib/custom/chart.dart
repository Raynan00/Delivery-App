import 'package:active_ecommerce_seller_app/data_model/chart_response.dart';
import 'package:active_ecommerce_seller_app/my_theme.dart';
import 'package:active_ecommerce_seller_app/repositories/shop_repository.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';


// class TimeSeriesBar extends StatefulWidget {
//
//
//   TimeSeriesBar();
//
//
//   @override
//   State<TimeSeriesBar> createState() => _TimeSeriesBarState();
// }
//
// class _TimeSeriesBarState extends State<TimeSeriesBar> {
//
//
//
//   /// Create one series with sample hard coded data.
//   List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
//     final data =
//
//     return [
//       new charts.Series<TimeSeriesSales, DateTime>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//          domainFn: (TimeSeriesSales sales, _) => sales.time,
//          measureFn: (TimeSeriesSales sales, _) => sales.sales,
//         data: data,
//       )
//     ];
//   }
//
//
//   @override
//   void initState() {
//     getChart();
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return chartList.isEmpty ?Container():new charts.TimeSeriesChart(
//        _createSampleData(),
//       animate: false,
//       // Set the default renderer to a bar renderer.
//       // This can also be one of the custom renderers of the time series chart.
//       defaultRenderer: new charts.BarRendererConfig<DateTime>(),
//       // It is recommended that default interactions be turned off if using bar
//       // renderer, because the line point highlighter is the default for time
//       // series chart.
//       defaultInteractions: false,
//       // If default interactions were removed, optionally add select nearest
//       // and the domain highlighter that are typical for bar charts.
//       behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
//     );
//   }
// }
//
// /// Sample time series data type.
// class TimeSeriesSales {
//   final DateTime time;
//   final int sales;
//
//   TimeSeriesSales(this.time, this.sales);
// }
//


class SimpleBarChart extends StatefulWidget {

  final bool animate;

  SimpleBarChart( {this.animate});



  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();

  /// Create one series with sample hard coded data.

}

class _SimpleBarChartState extends State<SimpleBarChart> {
  List<ChartResponse> chartList = [];

   List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = List.generate(chartList.length, (index) {
      return OrdinalSales( chartList[index].date, (chartList[index].total.toInt()));
      // return OrdinalSales("Sep-"+(10+ index).toString(), (chartList[0].total.toInt()-index));

    });

    return [
       Series<OrdinalSales, String>(
         colorFn: (__,_)=> charts.ColorUtil.fromDartColor(MyTheme.app_accent_color),
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,

      )
    ];
  }

  getChart() async {
    var response = await ShopRepository().chartRequest();
    chartList.addAll(response);
    setState(() {
    });
  }


  @override
  void initState() {
    getChart();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return chartList.isEmpty ?Container(): BarChart( _createSampleData(),
      domainAxis: OrdinalAxisSpec(
        renderSpec: SmallTickRendererSpec(
          labelStyle: TextStyleSpec(
              fontSize: 10, // size in Pts.
              color: charts.ColorUtil.fromDartColor(MyTheme.grey_153),

          ),

        ),

      ),
      defaultRenderer:  charts.BarRendererConfig(
        maxBarWidthPx: 12,
        fillPattern: charts.FillPatternType.solid,

      ),

      animate: widget.animate,
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec:  charts.GridlineRendererSpec(
            labelJustification:charts.TickLabelJustification.outside ,
            minimumPaddingBetweenLabelsPx: 1,
            //axisLineStyle:charts.LineStyleSpec() ,
            // Tick and Label styling here.
              labelStyle:  charts.TextStyleSpec(
                  fontSize: 10, // size in Pts.
                  color: charts.MaterialPalette.gray.shadeDefault
              ),
          ),
      ),

    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;


  OrdinalSales(this.year, this.sales);
}



