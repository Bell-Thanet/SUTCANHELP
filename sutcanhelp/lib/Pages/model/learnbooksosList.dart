class LearnBookSOS {
  //Field
  String location;
  String subject;
  String date;
  String time;
  //Method
  LearnBookSOS(this.location, this.subject, this.date, this.time);

//setค่าให้ ตัวแปร
  LearnBookSOS.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      try {
        location = map['Location'];
        subject = map['Subject'];
        date = map['Date'];
        time = map['Time'];
      } catch (e) {
        print(e);
      }
    }
  }
}
