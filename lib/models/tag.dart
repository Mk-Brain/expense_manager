class Tag{
  final int id;
  final String type;


  Tag({required this.id, required this.type});

  factory Tag.fromJson(Map<String, dynamic> objetjson){
    return Tag(
      id: objetjson['id'],
      type: objetjson['type']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'type' : type
    };
  }

}