class Task {
  String content;
  DateTime timeStamp;
  bool isCompleted;

  Task({
    required this.content,
    required this.timeStamp,
    required this.isCompleted,
  });

  Map toMap(){
    return {
      'content': content,
      'timeStamp': timeStamp,
      'isCompleted': isCompleted,
    };
  }

  // factory <constructor>.<func name> is a special constructor that can be used to return an object of the class
  factory Task.fromMap(Map task){
    return Task(
      content: task['content'],
      timeStamp: task['timeStamp'],
      isCompleted: task['isCompleted'],
    );


  }

}