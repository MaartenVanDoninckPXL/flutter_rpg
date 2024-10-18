import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/character.dart';

class FirestoreServices {
  static final ref = FirebaseFirestore.instance
      .collection('characters')
      .withConverter(
          fromFirestore: Character.fromFirestore,
          toFirestore: (Character c, _) => c.ToFirestore());

  static Future<void> addCharacter(Character character) async {
    await ref.doc(character.id).set(character);
  }

  static Future<QuerySnapshot<Character>> getCharacters() async {
    return ref.get();
  }

  static Future<void> updateCharacter(Character character) async {
    await ref.doc(character.id).update({
      'stats': character.statsAsMap,
      'points': character.points,
      'skills': character.skills.map((s) => s.id).toList(),
      'isFavorite': character.isFavorite,
    });
  }

  static Future<void> deleteCharacter(Character character) async {
    await ref.doc(character.id).delete();
  }
}
