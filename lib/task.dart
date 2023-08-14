class Task{
  int id;
  String work;
  bool isComplete;

  Task({required this.id, required this.work, required this.isComplete});

  // id에 value로 id 값을 넣는 등 딕셔너리 같은 형태 - Json
  Map<String, dynamic> toJson() =>
  {'id':id, 'work':work, 'isComplete': isComplete};
}
