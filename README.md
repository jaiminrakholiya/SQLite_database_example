Notes App 📝

This is a Flutter notes application that utilizes an SQLite database for local storage.

Features:

#Create: Create new notes with titles and descriptions.
#Read: View a list of all saved notes.
#Update: Edit existing notes.
#Delete: Delete notes with a confirmation dialog.
#CleanUI: Features a modern and user-friendly Material Design UI.
#LoadingStates: Handles loading states and displays appropriate error messages.
#EmptyStateHandling: Provides a user-friendly message when there are no notes.
#ResponsiveBottomSheet: Utilizes a responsive bottom sheet for adding and editing notes.
Dependencies:

#flutter: The core Flutter SDK.
#sqflite: For interacting with the SQLite database.
#path_provider: For obtaining the path to local storage.
#path: For path manipulation.
Installation:

#AddDependencies: Add the following lines to your pubspec.yaml file:
YAML

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0 
  path_provider: ^2.1.1
  path: ^1.8.3

environment:
  sdk: ">=2.19.0 <4.0.0"
#GetDependencies: Run flutter pub get in your terminal.

#ImportPackages: Import the required packages in your Dart files:

Dart

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
Note: This README provides a basic overview. For more detailed information, please refer to the project's source code and documentation.
