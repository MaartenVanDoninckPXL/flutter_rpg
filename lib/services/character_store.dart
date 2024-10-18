import 'package:flutter/material.dart';
import 'package:flutter_rpg/models/character.dart';
import 'package:flutter_rpg/services/firestore_services.dart';

class CharacterStore extends ChangeNotifier {
  final List<Character> _characters = [];

  get characters => _characters;

  void addCharacter(Character character) {
    FirestoreServices.addCharacter(character);

    _characters.add(character);
    notifyListeners();
  }

  void fetchCharacters() async {
    if (_characters.isNotEmpty) return;
    final characters = await FirestoreServices.getCharacters();

    for (final character in characters.docs) {
      _characters.add(character.data());
    }

    notifyListeners();
  }

  void updateCharacter(Character character) async {
    await FirestoreServices.updateCharacter(character);

    final index = _characters.indexWhere((c) => c.id == character.id);
    _characters[index] = character;

    notifyListeners();
  }

  void deleteCharacter(Character character) async {
    await FirestoreServices.deleteCharacter(character);

    _characters.remove(character);
    notifyListeners();
  }
}
