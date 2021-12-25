import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cognite_flutter_demo/models/appstate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppStateModel>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          buildDrawerHeader(context),
          ListTile(
            key: const Key("DrawerMenuTile_Config"),
            title: Text(AppLocalizations.of(context)!.drawerConfig),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed('/ConfigPage');
            },
          ),
          ListTile(
            key: const Key("DrawerMenuTile_Localisation"),
            title: Text(AppLocalizations.of(context)!.drawerLocalisation),
            subtitle: Text(appState.localeAbbrev!),
            onTap: () {
              // Here you should have a widget to select among
              // supported locales. This is just a quick and dirty
              // switch
              appState.switchLocale();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.drawerLocalisationResultMsg +
                        appState.localeAbbrev!),
                duration: const Duration(seconds: 3),
              ));
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            key: const Key("DrawerMenuTile_About"),
            title: Text(AppLocalizations.of(context)!.drawerAbout),
            onTap: () {
              showSimpleNotification(
                  Text(AppLocalizations.of(context)!.drawerAboutTitle),
                  key: const Key('DrawerMenu_NotificationAbout'),
                  leading: Icon(
                    Icons.info_outline,
                    size: 28,
                    color: Colors.blue.shade300,
                  ), trailing: Builder(builder: (context) {
                return TextButton(
                  autofocus: true,
                  style: TextButton.styleFrom(primary: Colors.yellow),
                  onPressed: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                    launch(
                        "https://github.com/gregertw/cognite-flutter-demo/issues");
                  },
                  child:
                      Icon(Icons.link, size: 28, color: Colors.blue.shade300),
                );
              }),
                  subtitle:
                      Text(AppLocalizations.of(context)!.drawerAboutMessage),
                  duration: const Duration(seconds: 4),
                  position: NotificationPosition.bottom);
            },
          ),
          ListTile(
            key: const Key('DrawerMenuTile_LogOut'),
            leading: const Icon(
              Icons.exit_to_app,
              color: Color(0xe81751ff),
            ),
            trailing: Text(AppLocalizations.of(context)!.logoutButton),
            onTap: () {
              appState.logOut();
            },
          ),
        ],
      ),
    );
  }
}

Widget buildDrawerHeader(BuildContext context) {
  var appState = Provider.of<AppStateModel>(context);
  return UserAccountsDrawerHeader(
    key: const Key("DrawerMenu_Header"),
    accountName: Text(appState.cdfProject == ''
        ? AppLocalizations.of(context)!.drawerHeaderInitialName
        : appState.cdfProject),
    accountEmail: Text(appState.cdfLoggedIn == true
        ? '(${AppLocalizations.of(context)!.drawerHeaderLoggedIn})'
        : '(${AppLocalizations.of(context)!.drawerHeaderLoggedOut})'),
    onDetailsPressed: () => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        var container = Container(
          key: const Key("DrawerMenu_BottomSheet"),
          alignment: Alignment.center,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.drawerProjectName),
                subtitle: Text(appState.cdfProject == ''
                    ? AppLocalizations.of(context)!.drawerEmptyProject
                    : appState.cdfProject),
              ),
              ListTile(
                title: Text(
                    AppLocalizations.of(context)!.drawerButtomSheetProjectId),
                subtitle: Text(appState.cdfProjectId == 0
                    ? ''
                    : appState.cdfProjectId.toString()),
              ),
            ],
          ),
        );
        return container;
      },
    ),
    currentAccountPicture: CircleAvatar(
      child: Image.asset('assets/actingweb-header-small.png'),
      backgroundColor: Colors.white,
    ),
  );
}
