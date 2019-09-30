import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:my_firebase_app/api/cloudFIreStore.dart';
import 'package:my_firebase_app/api/fireStorage.dart';
import 'package:my_firebase_app/model/character.dart';

class Characters with ChangeNotifier {
  CloudFireStore _store = CloudFireStore('characters');

  List<Character> _items;

  List<Character> get items {
    return [..._items];
  }

  Future<List<Character>> fetchCharacters() async {
    var result = await _store.getDataCollection();
    _items = result.documents.map((doc) => Character.fromSnapshot(doc));
    return items;
  }

  Stream<QuerySnapshot> fetchCharactersAsStream() {
    return _store.stramDataCollection();
  }

  Future<Character> fetchCharacterById(String id) async {
    var doc = await _store.getDocumentById(id);
    return Character.fromSnapshot(doc);
  }

  Future deleteCharacter(Character character) async {
    await _store.removeDocumentById(character.reference.documentID);
    // await character.reference.delete();

    return;
  }

  Future updateChracter(Character character) async {
    await _store.updateDocument(
        character.toJson(), character.reference.documentID);
    // await character.reference.updateData(character.toJson());
    return;
  }

  Future incrementRating(Character character) async {
    // await _store.upddateDocumentAsTransaction(character);
    return;
  }

  Future addCharacter(Character character) async {
    StorageUploadTask _uploadTask;
    File file = await getImageFromNetwork(character.img);
    DocumentReference ref = await _store.addDocument(character.toJson());

    final String filePath = 'characters/${ref.documentID}.png';

    FireStorage _storage = FireStorage(filePath);

    _uploadTask = _storage.putFile(file);
    try {
      StorageTaskSnapshot taskSnapshot = await _uploadTask.onComplete;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      character = Character(
          name: character.name,
          img: downloadUrl,
          rating: character.rating,
          reference: character.reference);
      await _store.updateDocument(character.toJson(), ref.documentID);
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
    await _store.upddateDocumentAsTransaction(null, character);
    return;
  }
}
