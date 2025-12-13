class CategoryExpense{
  int id;
  String name;


  CategoryExpense({required this.id,required this.name});

    factory CategoryExpense.fromJson(Map<String, dynamic>objetjson){
    return CategoryExpense(
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