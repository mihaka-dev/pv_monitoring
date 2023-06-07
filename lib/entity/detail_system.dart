class DetailSystem {
  Data? data;

  DetailSystem({this.data});

  DetailSystem.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Address? address;
  String? commissionDate;
  Coordinates? coordinates;
  String? name;
  Timezone? timezone;

  Data(
      {this.address,
      this.commissionDate,
      this.coordinates,
      this.name,
      this.timezone});

  Data.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    commissionDate = json['commissionDate'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    name = json['name'];
    timezone =
        json['timezone'] != null ? Timezone.fromJson(json['timezone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['commissionDate'] = commissionDate;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    data['name'] = name;
    if (timezone != null) {
      data['timezone'] = timezone!.toJson();
    }
    return data;
  }
}

class Address {
  String? city;
  String? country;
  String? postalCode;
  String? street;

  Address({this.city, this.country, this.postalCode, this.street});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    country = json['country'];
    postalCode = json['postalCode'];
    street = json['street'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['country'] = country;
    data['postalCode'] = postalCode;
    data['street'] = street;
    return data;
  }
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Timezone {
  String? name;
  String? utcOffset;

  Timezone({this.name, this.utcOffset});

  Timezone.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    utcOffset = json['utcOffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['utcOffset'] = utcOffset;
    return data;
  }
}
