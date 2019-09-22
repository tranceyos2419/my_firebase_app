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
    await _api.addDocument(character.toJson());
    return;
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
