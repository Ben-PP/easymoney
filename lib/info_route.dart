import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import './widgets/data_widget.dart';
import './utils/open_url.dart';

/// Route for showing info about the app
///
/// {@nodoc}
class InfoRoute extends StatelessWidget {
  const InfoRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = PackageInfo.fromPlatform();
    return Scaffold(
      appBar: AppBar(
        // FIXME Localization
        title: const Text('About EasyMoney'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          // FIXME Localization
                          Text(
                            'Want to contribute?',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Opening chrome on android emulator freezes
                                // the emulator so don't use this button there
                                openUrl('https://github.com/Ben-PP/easymoney');
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Github',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // FIXME Localization
                      const DataWidget(
                          title: 'Developer', content: 'Karel Parkkola'),
                      FutureBuilder(
                          future: packageInfo,
                          builder: (BuildContext context,
                              AsyncSnapshot<PackageInfo> snapshot) {
                            return DataWidget(
                              // FIXME Localization
                              title: 'Version',
                              content: snapshot.hasData
                                  ? snapshot.data!.version
                                  : '',
                            );
                          }),
                    ],
                  ),
                ),
                Text(
                  'Libraries used',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
