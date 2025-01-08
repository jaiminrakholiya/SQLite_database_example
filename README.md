Notes App 📝

A Flutter application for managing notes.

Utilizes SQLite for local data storage.

Features:

Create: ✍️ Create new notes with titles and descriptions.
Read: 📖 View a list of all saved notes.
Update: ✏️ Edit existing notes.
Delete: 🗑️ Delete notes with confirmation.
Clean UI: ✨ Modern and user-friendly Material Design.
Loading States: ⏳ Handles loading states and displays errors.
Empty State: 📭 Provides a user-friendly message when no notes exist.
Responsive Bottom Sheet: 📱 For adding/editing notes.
Dependencies:

flutter: 📱 The core Flutter SDK.
sqflite: 💾 For SQLite database interaction.
path_provider: 📁 For accessing local storage paths.
path: 📂 For path manipulation.
Installation:

Add Dependencies: ➕ Add to pubspec.yaml:
YAML

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0 
  path_provider: ^2.1.1
  path: ^1.8.3

environment:
  sdk: ">=2.19.0 <4.0.0"
Get Dependencies: 🔄 Run flutter pub get.
Import Packages: 📥 Import in your Dart files:
Dart

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
Note: This README provides a basic overview. For detailed information, refer to the project's source code and documentation.
