import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_firestore_location_provider.dart';

final locationListProvider = Provider.autoDispose.family((ref, userId) async {
  final locationList =
      await ref.watch(firebaseFirestoreLocationProvider(userId).last);
  return locationList;
});
