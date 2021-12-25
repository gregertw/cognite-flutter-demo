import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cognite_flutter_demo/models/heartbeatstate.dart';
import 'package:cognite_flutter_demo/models/chartstate.dart';
import 'package:cognite_flutter_demo/ui/pages/timeseries_chart/history.dart';

class CheckBoxButtons extends StatelessWidget {
  const CheckBoxButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var chart = Provider.of<ChartFeatureModel>(context);
    var hbm = Provider.of<HeartBeatModel>(context, listen: false);
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartLeft,
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              chart.setNewRange(pan: -0.5);
              chart.applyRangeController();
              hbm.setFilter(
                  start: chart.startRange,
                  end: chart.endRange,
                  resolution: chart.resolution);
              // Only load raw datapoints when we have a short range
              if (((chart.endRange! - chart.startRange!) / 1000).round() <
                  3600) {
                hbm.loadTimeSeries(raw: true);
              } else {
                hbm.loadTimeSeries();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartRight,
            icon: Icon(Icons.arrow_forward,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              chart.setNewRange(pan: 0.5);
              chart.applyRangeController();
              hbm.setFilter(
                  start: chart.startRange,
                  end: chart.endRange,
                  resolution: chart.resolution);
              // Only load raw datapoints when we have a short range
              if (((chart.endRange! - chart.startRange!) / 1000).round() <
                  3600) {
                hbm.loadTimeSeries(raw: true);
              } else {
                hbm.loadTimeSeries();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartZoomIn,
            icon:
                Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              // We don't want to zoom in more than 11s
              if ((chart.endRange! - chart.startRange!).round() > 11000) {
                chart.setNewRange(zoom: 0.4);
                chart.applyRangeController();
                hbm.setFilter(
                    start: chart.startRange,
                    end: chart.endRange,
                    resolution: chart.resolution);
                // Only load raw datapoints when we have a short range
                if (((chart.endRange! - chart.startRange!) / 1000).round() <
                    3600) {
                  hbm.loadTimeSeries(raw: true);
                } else {
                  hbm.loadTimeSeries();
                }
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartZoomOut,
            icon: Icon(Icons.remove,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              hbm.zoomOut();
              chart.setNewRange(zoom: -0.4);
              chart.applyRangeController();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartReset,
            icon: Icon(Icons.refresh,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              while (hbm.zoomOut()) {}
              chart.setNewRange(
                  start: (hbm.rangeStart + (hbm.rangeEnd - hbm.rangeStart) / 3)
                      .round(),
                  end: (hbm.rangeEnd - (hbm.rangeEnd - hbm.rangeStart) / 3)
                      .round());
              chart.applyRangeController();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartHistory,
            icon: Icon(Icons.history,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              historyDialog(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          child: IconButton(
            tooltip: AppLocalizations.of(context)!.chartInfo,
            icon: Icon(Icons.info,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              launch('https://docs.cognite.com/dev/concepts/aggregation/');
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.chartTooltip),
            Checkbox(
              value: chart.showToolTip,
              activeColor: Theme.of(context).toggleButtonsTheme.focusColor,
              hoverColor: Theme.of(context).toggleButtonsTheme.hoverColor,
              checkColor: Theme.of(context).toggleButtonsTheme.selectedColor,
              onChanged: (newVal) {
                chart.toggleToolTip();
              },
            ),
            Text(AppLocalizations.of(context)!.chartMarkers),
            Checkbox(
              value: chart.showMarker,
              activeColor: Theme.of(context).toggleButtonsTheme.focusColor,
              hoverColor: Theme.of(context).toggleButtonsTheme.hoverColor,
              checkColor: Theme.of(context).toggleButtonsTheme.selectedColor,
              onChanged: (newVal) {
                chart.toggleMarker();
              },
            ),
          ],
        ),
      ],
    );
  }
}
