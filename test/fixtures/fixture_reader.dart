import 'dart:io';

String fixture(fileName) => File(
        '/Users/rubabazim/projects/flutterProjects/flutter-clean-architecture/test/fixtures/$fileName')
    .readAsStringSync();
