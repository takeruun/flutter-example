import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:example/local/app_shared_preferences.dart';

final prefsProvider =
    Provider<AppSharedPrefences>((ref) => AppSharedPrefences());
