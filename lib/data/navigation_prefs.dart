import 'package:shared_preferences/shared_preferences.dart';

const _kLastMainTabIndex = 'last_main_tab_index';

/// Bottom tab: 0 Plan, 1 Track, 2 Review.
Future<int> loadLastMainTabIndex() async {
  final p = await SharedPreferences.getInstance();
  final i = p.getInt(_kLastMainTabIndex);
  if (i == null) return 0;
  return i.clamp(0, 2);
}

Future<void> saveLastMainTabIndex(int index) async {
  final p = await SharedPreferences.getInstance();
  await p.setInt(_kLastMainTabIndex, index.clamp(0, 2));
}
