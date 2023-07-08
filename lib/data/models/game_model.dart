class GameModel {
  late int id;
  late String name, description, image;

  GameModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }
}

List<GameModel> games = [
  GameModel(
    id: 1,
    name: 'Piano game',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2FPiano%20game%20.jpg?alt=media&token=456115ac-9aee-43c4-93dc-47eb830c5f8e',
  ),
  GameModel(
    id: 2,
    name: 'Puzzle game',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2FPuzzle%20game.jpg?alt=media&token=f8826a69-1708-4995-9bb3-726caf7f3b44',
  ),
  GameModel(
    id: 3,
    name: 'Memory game (2D)',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2FMemory%20game%202D.jpg?alt=media&token=95bbb2bb-3ca6-442f-81e1-d5b01d969506',
  ),
  GameModel(
    id: 4,
    name: 'Drag & Drop Game ',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2Fdrag-drop.jpg?alt=media&token=421a61f0-a5ef-453c-8ee1-0123b430c9a0',
  ),
  GameModel(
    id: 5,
    name: 'Little Intelligence',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2FLittle%20Intelligente.jpg?alt=media&token=8f2551df-d22e-4239-a814-11f6d58d22b2',
  ),
  GameModel(
    id: 6,
    name: 'Hack & Slash (3D)',
    description: 'this game gives you a hand like a soldier hand.',
    image:
        'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2FHack-amp%20Slash%203D.jpg?alt=media&token=3f4df7fc-1f85-4070-a8a0-fdcccb1fced0',
  ),
];
