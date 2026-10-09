import 'package:flutter/material.dart';

import 'screens/intervention_list_screen.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FieldOpsApp());
}

class FieldOpsApp extends StatelessWidget {
  const FieldOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldOps Compagnon',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: InterventionListScreen(authService: AuthService()),
    );
  }
}
