import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keopi/app.dart';
import 'package:keopi/core/services/sample_data_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // İlk çalıştırmada Firestore'a örnek veriyi yaz
  final needs = await SampleDataService.needsSeed();
  if (needs) await SampleDataService.seedAll();

  runApp(const KeopiApp());
}
