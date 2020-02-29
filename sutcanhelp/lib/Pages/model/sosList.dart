class SosList {
  //Field
  String title;
  String phonenumber;
  //Method
  SosList(this.title, this.phonenumber);

//setค่าให้ ตัวแปร
  SosList.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      try {
        title = map['Title'];
        phonenumber = map['phonenumber'];
      } catch (e) {
        print(e);
      }
    }
  }
}
