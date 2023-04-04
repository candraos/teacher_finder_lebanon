class Topic{
  int? id;
  String? name;

  Topic(this.id, this.name);

  Topic.fromJson(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
  }
}