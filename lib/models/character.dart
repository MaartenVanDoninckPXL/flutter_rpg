import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rpg/models/skill.dart';
import 'package:flutter_rpg/models/stats.dart';
import 'package:flutter_rpg/models/vocation.dart';

class Character with Stats {
  Character({
    required this.name,
    required this.slogan,
    required this.vocation,
    required this.id,
  });

  final Set<Skill> skills = {};
  final Vocation vocation;
  final String name;
  final String slogan;
  final String id;
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
  }

  void updateSkill(Skill skill) {
    skills.clear();
    skills.add(skill);
  }

  // Character to Firestore
  Map<String, dynamic> ToFirestore() {
    return {
      'name': name,
      'slogan': slogan,
      'isFavorite': _isFavorite,
      'vocation': vocation.toString(),
      'skills': skills.map((skill) => skill.id).toList(),
      'stats': statsAsMap,
      'points': points,
    };
  }

  // Firestore to Character
  factory Character.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    Character character = new Character(
      name: data['name'],
      slogan: data['slogan'],
      id: snapshot.id,
      vocation: Vocation.values.firstWhere(
        (vocation) => vocation.toString() == data['vocation'],
      ),
    );

    for (String id in data['skills']) {
      Skill skill = allSkills.firstWhere((skill) => skill.id == id);
      character.updateSkill(skill);
    }

    if (data['isFavorite'] == true) {
      character.toggleFavorite();
    }

    character.setStats(points: data['points'], stats: data['stats']);

    return character;
  }
}

List<Character> characters = [
  Character(
    id: '1',
    name: 'Klara',
    vocation: Vocation.wizard,
    slogan: 'Kapumf!',
  ),
  Character(
    id: '2',
    name: 'Jonny',
    vocation: Vocation.junkie,
    slogan: 'Light me up...',
  ),
  Character(
    id: '3',
    name: 'Crimson',
    vocation: Vocation.raider,
    slogan: 'Fire in the hole!',
  ),
  Character(
    id: '4',
    name: 'Shaun',
    vocation: Vocation.ninja,
    slogan: 'Alright then gang.',
  ),
];
