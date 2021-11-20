import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreBaseFunction{

  final FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;

  Future<DocumentSnapshot> insertData({required String collectionName,required Map<String, dynamic> json}) async {

    final response = await fireStoreInstance.collection(collectionName).add(json);

    DocumentSnapshot insertedData = await fireStoreInstance.collection(collectionName).doc(response.id).get();

    print(response.toString());
    return insertedData;
  }


  Future<DocumentSnapshot?> updateData({required String collectionName,required Map<String, dynamic> json,required String feildName,required String value}) async {

    String? docId;
    DocumentSnapshot? updatedData;
    await fireStoreInstance
        .collection(collectionName)
        .where(feildName, isEqualTo : value)
        .get().then((value){
      value.docs.forEach((element) async {
        docId = element.id;
        await fireStoreInstance
            .collection(collectionName)
            .doc(element.id)
            .update(json);
        });
      });
    if(docId!=null)
    {
      updatedData  = await fireStoreInstance.collection(collectionName).doc(docId).get();
    }


    return updatedData;
  }

  Future<void> deleteData({required String collectionName,required String feildName,required String value})
  async {
    await fireStoreInstance
        .collection(collectionName)
        .where(feildName, isEqualTo : value)
        .get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection(collectionName).doc(element.id).delete().then((value){
        });
      });
    });
  }

  void addListener({required String collectionName,void onData(dynamic event)?})
  async {
    fireStoreInstance
        .collection("Blogs")
        .snapshots()
        .listen((result) {
          onData!(result);
    });
  }

  Future<DocumentSnapshot> insertDataWithDocId({required String collectionName,required String docId,required Map<String, dynamic> json}) async {

    final response = await fireStoreInstance.collection(collectionName).doc(docId).set(json);

    DocumentSnapshot insertedData = await fireStoreInstance.collection(collectionName).doc(docId).get();
    // print(response.toString());
    return insertedData;
  }

  Future<void> deleteDateWithDocId({required String collectionName,required String docId}) async {
    await fireStoreInstance.collection(collectionName).doc(docId).delete();
  }

  Future<DocumentSnapshot> fetchDocumentWithDocId({required String collectionName,required String docId}) async {

    DocumentSnapshot insertedData = await fireStoreInstance.collection(collectionName).doc(docId).get();
    // print(response.toString());
    return insertedData;
  }

  Future<List<Map<String,dynamic>>> fetchAllDocument({required String collectionName,String orderByFeild = "",bool desc = false})
  async {
    List<Map<String,dynamic>> listOfData = [];
    if(orderByFeild!="")
    {
      await fireStoreInstance.collection(collectionName).orderBy(orderByFeild,descending: desc).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          listOfData.add(result.data());
        });
      });
    }else{
      await fireStoreInstance.collection(collectionName).get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          listOfData.add(result.data());
        });
      });
    }

    return listOfData;
  }

  Future<List<Map<String,dynamic>>> getWhere({required String collectionName,required Map<String, dynamic> where})
  async {
    List<Map<String,dynamic>> listOfData = [];
    final query = fireStoreInstance
        .collection(collectionName);

    where.forEach((key, value) {
      if(value["condition"] == "isEqualTo")
      {
        print("WHERE APPLIED ${value["condition"]} ${value["value"]}");
        query.where(key, isEqualTo: value["value"]);
      }
      if(value["condition"] == "isGreaterThan")
      {
        query.where(key, isGreaterThan: value);
      }
      if(value["condition"] == "isGreaterThanOrEqualTo")
      {
        query.where(key, isGreaterThanOrEqualTo: value);
      }
      if(value["condition"] == "isLessThan")
      {
        query.where(key, isLessThan: value);
      }
      if(value["condition"] == "isLessThanOrEqualTo")
      {
        query.where(key, isLessThanOrEqualTo: value);
      }
    });

    await query.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listOfData.add(result.data());
      });
    });
    return listOfData;
  }




}