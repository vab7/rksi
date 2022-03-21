import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rksi_schedule/resourses/app_colors.dart';
import 'package:rksi_schedule/ui/screen_schedule.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rksi_schedule/data/group/group.dart';
import 'package:rksi_schedule/data/schedule/schedule.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  initHive();

  runApp(const App());
}

void initHive() async {
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(ScheduleAdapter());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'РКСИ',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: primary,
        ),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const ScheduleScreen(),
    );
  }
}
