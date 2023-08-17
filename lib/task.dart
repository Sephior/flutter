class Task{
  int id;
  String work;
  bool isComplete;

  Task({required this.id, required this.work, required this.isComplete});

  // key에 value로 key 값을 넣는 등 딕셔너리 같은 형태 - Json
  Map<String, dynamic> toJson() =>
  {'id':id, 'work':work, 'isComplete': isComplete};

  factory Task.fromJson(Map<String, dynamic> json){
    return Task(id : json['id'], work : json['work'], isComplete : json['isComplete']);
  }
}