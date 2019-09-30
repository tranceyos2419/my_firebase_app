import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:my_firebase_app/api/cloudFIreStore.dart';
import 'package:my_firebase_app/model/character.dart';

class Characters with ChangeNotifier {
  CloudFireStore _api = CloudFireStore('characters');
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://my-firebase-app-c159a.appspot.com/');
  final String filePath = 'images/${DateTime.now()}.png';
  StorageUploadTask _uploadTask;

  List<Character> _items;

  List<Character> get items {
    return [..._items];
  }

  Future<List<Character>> fetchCharacters() async {
    var result = await _api.getDataCollection();
    _items = result.documents.map((doc) => Character.fromSnapshot(doc));
    return items;
  }

  Stream<QuerySnapshot> fetchCharactersAsStream() {
    return _api.stramDataCollection();
  }

  Future<Character> fetchCharacterById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Character.fromSnapshot(doc);
  }

  Future deleteCharacter(Character character) async {
    await _api.removeDocumentById(character.reference.documentID);
    // await character.reference.delete();

    return;
  }

  Future updateChracter(Character character) async {
    await _api.updateDocument(
        character.toJson(), character.reference.documentID);
    // await character.reference.updateData(character.toJson());
    return;
  }

  Future incrementRating(Character character) async {
    // await _api.upddateDocumentAsTransaction(character);
    return;
  }

  Future addCharacter(Character character) async {
    StorageUploadTask _uploadTask;
    File file = await getImageFromNetwork(character.img);
    DocumentReference ref = await _api.addDocument(character.toJson());

    final String filePath = 'characters/${ref.documentID}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(file);
    try {
      StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      character = Character(
          name: character.name,
          img: downloadUrl,
          rating: character.rating,
          reference: character.reference);
      await _api.updateDocument(character.toJson(), ref.documentID);
    } catch (e) {
      throw e;
    }
    return;
  }

  Future<File> getImageFromNetwork(String url) async {
    File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

  Future updateCharacterAsTransaction(Character character) async {
    //! callback doesn't work
    // _callback(Transaction transaction) async {
    //   final freshSNapshot = await transaction.get(character.reference);
    //   final fresh = Character.fromSnapshot(freshSNapshot);
    //   final json = fresh.toJson();
    //   await transaction.update(character.reference, json);
    // }
    await _api.upddateDocumentAsTransaction(null, character);
    return;
  }
}
