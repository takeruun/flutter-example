import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:example/model/location.dart';

final firebaseFirestoreLocationProvider =
    StreamProvider.autoDispose.family<List<Location>, String>((ref, userId) {
  final stream = FirebaseFirestore.instance
      .collection('location')
      .orderBy('created_at', descending: true)
      .where('user_uid', isEqualTo: userId)
      .limit(1)
      .snapshots();
  return stream.map((snapshot) =>
      snapshot.docs.map((doc) => Location.fromJson(doc.data())).toList());
});
