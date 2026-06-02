// Migrated main.dart from root project

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// (content copied from original lib/main.dart)

void main() => runApp(const FixNGoApp());

class FixNGoApp extends StatelessWidget {
  const FixNGoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Fix-N-Go',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: const Scaffold(body: Center(child: Text('Migrated customer app'))),
      );
