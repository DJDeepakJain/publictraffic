class Info {
  String vehicleNo;
  DateTime? date;
  String violation;
  String photos;



  Info({required this.vehicleNo,
    required this.violation,
    required this.photos, this.date});

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    vehicleNo: json["VehicleNo"],
    violation: json["Violation"],
    photos: json["Photos"],
    // date: DateTime.parse(json["Date"]), // Convert JSON string to DateTime.
  );

}