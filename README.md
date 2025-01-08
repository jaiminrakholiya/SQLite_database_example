Notes App 📝
A Flutter notes application with SQLite database for local storage. Features a clean UI with create, read, update, and delete functionality for notes.
Dependencies
Add these to your pubspec.yaml:
yamlCopydependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0  # For SQLite database
  path_provider: ^2.1.1  # For getting local storage path
  path: ^1.8.3  # For path manipulation

environment:
  sdk: ">=2.19.0 <4.0.0"
Installation

Add the dependencies to your pubspec.yaml file
Run flutter pub get in your terminal
Import the required packages in your Dart files:

dartCopyimport 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
Features

📝 Create new notes with title and description
📖 View list of all saved notes
✏️ Update existing notes with edit functionality
🗑️ Delete notes with confirmation dialog
🎨 Clean and modern Material Design UI
⚡ Loading states and error handling
📱 Empty state handling
💫 Responsive bottom sheet for adding/editing notes
