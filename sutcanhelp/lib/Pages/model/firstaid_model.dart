class FirstAid1 {
  //Field
  String title;
  List<String> number = List();
  String image;
  //Method
  FirstAid1(this.title, this.number, this.image);

//setค่าให้ ตัวแปร
  FirstAid1.fromMap(Map<String, dynamic> map) {
    title = map['Title'];
    // print(map.length);
    for (int i = 1; i <= map.length - 2; i++) {
      print(i);
      number.add(map['$i']);
    }
    image = map['Image'];
  }
}
