class Category{
  int id;
  String name;


  Category({required this.id,required this.name});

    factory Category.fromJson(Map<String, dynamic>objetjson){
    return Category(
        id: objetjson['id'],
        name: objetjson['name'],

    );
  }

  Map<String, dynamic>toJson(){
    return {
      'id' : id,
      'name' : name,

    };
  }
}