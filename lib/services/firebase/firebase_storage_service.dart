import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lugat/model/concrete/sentence_model.dart';
import 'package:lugat/services/base/i_sentence_storage_base_service.dart';

/// Created by Yunus Emre Yıldırım
/// on 4.10.2022

class FirebaseStorageService extends ISentenceStorageBaseService {
  late FirebaseFirestore fireStore;

  FirebaseStorageService() {
    fireStore = FirebaseFirestore.instance;
  }

  @override
  Future<List<SentenceModel>?> getAll() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fireStore.collection('Sentence').get();

      List<SentenceModel> sentenceList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> item in querySnapshot.docs) {
        SentenceModel sentenceModel = SentenceModel.fromJson(item.data());
        sentenceList.add(sentenceModel);
      }
      return sentenceList;
    } catch (e) {
      debugPrint('Firebase den veri alma işlemi sırasında hata oluştu');
      return null;
    }
  }
}
