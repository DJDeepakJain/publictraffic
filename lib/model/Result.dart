class Result {
  String? currentAddress;
  String? registrationDate;
  String? colour;
  String? registeredPlace;
  String? fuelType;
  String? manufacturerModel;
  String? ownerName;
  String? manufacturer;
  String? vehicleCategory;
  String? permanentAddress;
  String? registrationNumber;

  Result(
      {this.currentAddress,
        this.registrationDate,
        this.colour,
        this.registeredPlace,
        this.fuelType,
        this.manufacturerModel,
        this.ownerName,
        this.manufacturer,
        this.vehicleCategory,
        this.permanentAddress,
        this.registrationNumber});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
    currentAddress : json['current_address'],
    registrationDate : json['registration_date'],
    colour :json['colour'],
    registeredPlace : json['registered_place'],
    fuelType : json['fuel_type'],
    manufacturerModel : json['manufacturer_model'],
    ownerName : json['owner_name'],
    manufacturer : json['manufacturer'],
    vehicleCategory : json['vehicle_category'],
    permanentAddress : json['permanent_address'],
    registrationNumber : json['registration_number'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['current_address'] = this.currentAddress;
  //   data['registration_date'] = this.registrationDate;
  //   data['colour'] = this.colour;
  //   data['registered_place'] = this.registeredPlace;
  //   data['fuel_type'] = this.fuelType;
  //   data['manufacturer_model'] = this.manufacturerModel;
  //   data['owner_name'] = this.ownerName;
  //   data['manufacturer'] = this.manufacturer;
  //   data['vehicle_category'] = this.vehicleCategory;
  //   data['permanent_address'] = this.permanentAddress;
  //   data['registration_number'] = this.registrationNumber;
  //   return data;
  // }
}