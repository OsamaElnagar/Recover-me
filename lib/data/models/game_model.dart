class GameModel {
  late int id;
  late String name,
      description,
      image;

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
    name: 'ArmyHandy',
    description: 'this game gives you a hand like a soldier hand.',
    image: 'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/Games%2Fanimehand.jpg?alt=media&token=0548450e-d4fc-4893-a00c-a97a530212e7',
  ),
];
