import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_firebase_app/api/cloudFIreStore.dart';
import 'package:my_firebase_app/model/character.dart';

class Characters with ChangeNotifier {
  CloudFireStore _api = CloudFireStore('character');

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

  Future removeCharacterById(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateChracter(Character character, String id) async {
    await _api.updateDocument(character.toJson(), id);
    return;
  }

  Future incrementRating(Character character) async {
    await _api.upddateDocumentAsTransaction(character);
    return;
  }

  Future addCharacter(Character character) async {
    await _api.addDocument(character.toJson());
    return;
  }
}
