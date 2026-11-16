import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Whether the checklist is enabled.
  bool enabled = true;

  /// Whether the lines can be toggled when the checklist is disabled.
  bool toggleable = false;

  /// Whether the lines can be reordered when the checklist is disabled.
  bool reorderable = false;

  final lines = List.generate(
    5,
    (index) => (text: 'Line ${index + 1}', toggled: false),
  );

  void onChanged(List<ChecklistLine> lines) {
    log(lines.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('en'),
      localizationsDelegates: [
        ...ChecklistLocalizations.localizationsDelegates,
      ],
      supportedLocales: [
        ...ChecklistLocalizations.supportedLocales,
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_checklist example'),
        ),
        body: Column(
          children: [
            SwitchListTile(
              title: const Text('Enabled'),
              value: enabled,
              onChanged: (value) => setState(() => enabled = value),
            ),
            SwitchListTile(
              title: const Text('Toggleable when disabled'),
              value: toggleable,
              onChanged: enabled
                  ? null
                  : (value) => setState(() => toggleable = value),
            ),
            SwitchListTile(
              title: const Text('Reorderable when disabled'),
              value: reorderable,
              onChanged: enabled
                  ? null
                  : (value) => setState(() => reorderable = value),
            ),
            const Divider(),
            Expanded(
              child: Checklist(
                lines: lines,
                enabled: enabled,
                toggleable: toggleable,
                reorderable: reorderable,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
