import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rksi_schedule/resourses/app_colors.dart';
import 'package:rksi_schedule/screen_main/screen_main.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'РКСИ',
      home: const ScheduleMain(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: AppColors.primary),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
    );
  }
}
