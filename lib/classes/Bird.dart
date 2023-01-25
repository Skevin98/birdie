class Bird{
  int id = 0;
  var status;
  var order;
  var name;
  var family;
  var lengthMax;
  var sciName;
  List<dynamic>? images;

  Bird(this.id, this.status,this.order, this.name, this.family, this.lengthMax,this.sciName, [this.images]);


  factory Bird.fromJson(Map<String, dynamic> json){
    return Bird(json['id'],json['status'],json['order'],json['name'],
        json['family'],json['lengthMax'], json['sciName'],json['images']);
  }
}