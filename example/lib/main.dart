/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 09-May-2021
 */

import 'package:es_utils/es_utils.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<bool> varList = [false, false, true, true, false, false];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ES-Utils Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ESPlatform.isSmallScreen(context) ? 50 : 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ESButton(
                'Progress Dialog',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 2)),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return ESMessage.showProgressIndicator(title: 'New Screen');
                        }
                        return Scaffold(
                          appBar: AppBar(title: const Text('New Screen')),
                          body: const Text('New Screen'),
                        );
                      },
                    ),
                  ),
                ),
              ),
              ESButton(
                'Show Input Dialog',
                onPressed: () => ESMessage.showInputDialog(
                  context: context,
                  title: 'Title',
                  message: 'Test Message',
                  defaultValue: 'Default Value',
                  hitText: 'Enter Value',
                  onSubmit: (TextEditingController controller) => ESMessage.showInfoMessage(
                    context,
                    message: controller.text,
                  ),
                ),
              ),
              ESButton(
                'Show Question Dialog',
                onPressed: () => ESMessage.showQuestionMessage(
                  context: context,
                  title: 'Question Dialog',
                  message: 'Are you sure?',
                ),
              ),
              ESButton(
                'Show Confirm Dialog',
                onPressed: () => ESMessage.showConfirmDialog(
                  context: context,
                  title: 'Confirm Dialog',
                  message: 'Are you sure you want to remove all the existing items ?',
                  primaryButton: 'OK',
                  // buttonRight: 'Cancel',
                ),
              ),
              ESButton(
                'Show Info Dialog',
                onPressed: () => ESMessage.showInfoMessage(
                  context,
                  title: 'Info Dialog',
                  message: 'Are you sure?',
                ),
              ),
              ESButton(
                'Show Warning Dialog',
                onPressed: () => ESMessage.showWarningMessage(
                  context,
                  title: 'Warning Dialog',
                  message: 'Are you sure?',
                ),
              ),
              ESButton(
                'Show Error Dialog',
                onPressed: () => ESMessage.showErrorMessage(
                  context,
                  title: 'Error Dialog',
                  message: 'Are you sure?',
                ),
              ),
              ESButton(
                'List Dialog',
                onPressed: () => ESMessage.showListDialog(
                  context: context,
                  suffixText: 'Rows',
                  selectedValue: 20,
                  title: 'Row Count',
                  multiSelectValues: varList,
                  options: const [10, 20, 30, 50, 100, 120],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
