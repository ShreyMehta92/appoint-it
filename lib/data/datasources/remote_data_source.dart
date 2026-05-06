import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteDataSource {
  final FirebaseFirestore firestore;

  RemoteDataSource(this.firestore);

  // Syncs payload to firestore collection
  Future<void> syncDocument({
    required String collection,
    required String documentId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final docRef = firestore.collection(collection).doc(documentId);
    
    if (operation == 'delete') {
      await docRef.delete();
    } else {
      await docRef.set(payload, SetOptions(merge: true));
    }
  }
}
