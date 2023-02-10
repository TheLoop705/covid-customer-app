import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            Consumer<ThemeNotifier>(
              builder: (context,notifier,child) => WidgetAnimator(
                Card(
                  child: SwitchListTile(
                    activeColor: primary,
                    title: Text("Dark Mode"),
                    onChanged: (val){
                      notifier.toggleTheme();
                    },
                    value: notifier.darkTheme,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
