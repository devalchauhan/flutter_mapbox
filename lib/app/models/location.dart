class Location {
  Geometry? geometry;
  String? type;
  Properties? properties;

  Location({this.geometry, this.type, this.properties});

  Location.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Properties {
  String? description;
  String? markerSymbol;
  String? title;
  String? url;
  List<String>? lines;
  String? address;

  Properties(
      {this.description,
      this.markerSymbol,
      this.title,
      this.url,
      this.lines,
      this.address});

  Properties.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    markerSymbol = json['marker-symbol'];
    title = json['title'];
    url = json['url'];
    lines = json['lines'].cast<String>();
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = description;
    data['marker-symbol'] = markerSymbol;
    data['title'] = title;
    data['url'] = url;
    data['lines'] = lines;
    data['address'] = address;
    return data;
  }
}
