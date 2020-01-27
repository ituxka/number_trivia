import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

void main() async {
  await di.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
