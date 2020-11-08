import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/appstate.dart';
import 'package:first_app/ui/pages/login/index.dart';
import 'package:first_app/ui/pages/config/index.dart';
import 'package:first_app/ui/pages/timeseries_chart/index.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    if (!appState.authenticated) {
      return Scaffold(
        body: LoginPage(),
      );
    }

    if (!appState.cdfLoggedIn) {
      return Scaffold(
        body: ConfigPage(),
      );
    }

    // as documented in appstate.dart, we here set the defaultLokale
    // from appState to apply loaded locale from sharedpreferences on
    // startup.
    Intl.defaultLocale = appState.locale;

    var apiClient = appState.mocks.getMock('heartbeat') ??
        CDFApiClient(
            project: appState.cdfProject,
            apikey: appState.cdfApiKey,
            baseUrl: appState.cdfURL,
            debug: false);

    return TimeSeriesHome(apiClient: apiClient, appState: appState);
  }
}
