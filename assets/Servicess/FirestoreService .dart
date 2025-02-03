import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sitedata.dart';

class FirestoreService {
  final CollectionReference _sitesCollection =
      FirebaseFirestore.instance.collection('sites');

  Future<void> addSite(SiteModel site) async {
    await _sitesCollection.doc(site.id).set(site.toMap());
  }

  Future<List<SiteModel>> getSites() async {
    QuerySnapshot snapshot = await _sitesCollection.get();
    return snapshot.docs.map((doc) {
      return SiteModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateSite(SiteModel site) async {
    await _sitesCollection.doc(site.id).update(site.toMap());
  }

  Future<void> deleteSite(String id) async {
    await _sitesCollection.doc(id).delete();
  }
}
