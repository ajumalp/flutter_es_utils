# ES-Utils for Flutter

### A Flutter package for few UI components like confirmDialog, inputDialog, Buttons etc 

 
[![](https://img.shields.io/pub/v/es_utils.svg)](https://pub.dartlang.org/packages/es_utils)
[![Flutter](https://github.com/ajumalp/flutter_es_utils/actions/workflows/flutter-ci.yml/badge.svg?branch=main)](https://github.com/ajumalp/flutter_es_utils/actions/workflows/flutter.yml)


## Development tools required 
[![](https://img.shields.io/badge/Visual%20Studio%20Code-1.63-blue)](https://code.visualstudio.com/)

## Visual Studio Code Extensions used 
[![](https://img.shields.io/badge/Dart-2.12.0-blue)](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
[![](https://img.shields.io/badge/Flutter-2.8.0-blue)](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## Languages used 
![](https://img.shields.io/badge/Flutter-Dart-00979D)    

## Flutter Package Dependencies    
[![](https://img.shields.io/badge/URL_Launcher-v6.0.17-orange)](https://pub.dev/packages/url_launcher/versions/6.0.17) 


## Screenshots
<img src="https://raw.githubusercontent.com/ajumalp/flutter_es_utils/main/other/images/screenshots/scr-confirm.jpg" height="300">&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/ajumalp/flutter_es_utils/main/other/images/screenshots/scr-input.jpg" height="300">&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/ajumalp/flutter_es_utils/main/other/images/screenshots/scr-list.jpg" height="300">&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/ajumalp/flutter_es_utils/main/other/images/screenshots/scr-main.jpg" height="300">&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/ajumalp/flutter_es_utils/main/other/images/screenshots/scr-progress.jpg" height="300">
      
## Confirm Dialog 
```dart 
ESButton(
    'Show Confirm Dialog',
    onPressed: () => ESMessage.showConfirmDialog(
        context: context,
        title: 'Confirm Dialog',
        message: 'Are you sure?',
        buttonLeft: 'OK',
        buttonRight: 'Cancel',
    ),
)
```

## List Dialog 
```dart 
final List<bool> varList = [false, false, true, true, false];
ESButton(
    'List Dialog',
    onPressed: () => ESMessage.showListDialog(
        context: context,
        suffixText: 'Rows',
        selectedValue: 20,
        title: 'Row Count',
        multiSelectValues: varList,
        options: const [10, 20, 30, 50, 100],
    ),
)
```
## Input Dialog 
```dart
ESButton(
    'Show Input Dialog',
    onPressed: () => ESMessage.showInputDialog(
        context: context,
        title: 'Title',
        defaultValue: 'Default Value',
        hitText: 'Enter Value',
        onSubmit: (TextEditingController controller) => ESMessage.showInfoMessage(
        context,
        message: controller.text,
        ),
    ),
)
```
