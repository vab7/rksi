import 'package:flutter/cupertino.dart';
import 'package:rksi_schedule/screen_main/model/schedule_model.dart';

class ScheduleProvider extends InheritedNotifier<ScheduleModel> {
  const ScheduleProvider({
    Key? key,
    required ScheduleModel model,
    required Widget child,
  }) : super(key: key, notifier: model, child: child);

  static ScheduleModel? get(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ScheduleProvider>()
        ?.widget;
    return widget is ScheduleProvider ? widget.notifier : null;
  }

  static ScheduleModel? depend(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScheduleProvider>()?.notifier;
}
