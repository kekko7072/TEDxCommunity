import 'imports.dart';

class DatabaseWarehouse {
  final String licenseId;
  DatabaseWarehouse(this.licenseId);

  late CollectionReference<Map<String, dynamic>> warehouseCollection =
      DatabaseLicense(licenseId).licenseDoc.collection('warehouse');

  ///BAG
  Future createBag(
    Bag bag,
  ) async {
    return await warehouseCollection.doc(bag.id).set({
      'name': bag.name,
      'products': bag.products,
      'units': bag.units,
    });
  }

  Future deleteBag(
    String id,
  ) async {
    return await warehouseCollection.doc(id).delete();
  }

  Future addRemoveBag({
    required String id,
    required bool isAdd,
  }) async {
    return await warehouseCollection.doc(id).update({
      'units': FieldValue.increment(isAdd ? 1 : -1),
    });
  }

  static Bag bagFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Bag(
      id: snapshot.id,
      name: snapshot.data()!['name'] ?? '',
      products: snapshot.data()?['products'] != null
          ? (snapshot.data()?['products'] as List)
              .map((item) => item as String)
              .toList()
          : [],
      units: snapshot.data()!['units'] ?? 0,
    );
  }

  static List<Bag> bagListFromSnapshot(
          QuerySnapshot<Map<String, dynamic>> snapshot) =>
      snapshot.docs.map((snapshot) => bagFromSnapshot(snapshot)).toList();

  Stream<List<Bag>> get allBags {
    return warehouseCollection.snapshots().map(bagListFromSnapshot);
  }
}
