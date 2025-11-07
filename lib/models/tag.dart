class Tag{
  final int id;
  final String type;
  final String libelle;


  Tag({required this.id, required this.libelle, required this.type});

  factory Tag.fromJson(Map<String, dynamic> objetjson){
    return Tag(
      id: objetjson['id'],
      libelle: objetjson['libelle'],
      type: objetjson['type']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'libelle' : libelle,
      'type' : type
    };
  }

}