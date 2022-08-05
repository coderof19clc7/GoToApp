import 'dart:convert';

/// type : "FeatureCollection"
/// features : [{"bbox":[106.68221,10.762162,106.683001,10.764258],"type":"Feature","properties":{"segments":[{"distance":291.4,"duration":36.5,"steps":[{"distance":19.8,"duration":2.4,"type":11,"instruction":"Head south on Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[0,1]},{"distance":261.5,"duration":30.5,"type":6,"instruction":"Continue straight onto Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[1,12]},{"distance":10.2,"duration":3.7,"type":1,"instruction":"Turn right","name":"-","way_points":[12,13]},{"distance":0.0,"duration":0.0,"type":10,"instruction":"Arrive at your destination, on the right","name":"-","way_points":[13,13]}]}],"summary":{"distance":291.4,"duration":36.5},"way_points":[0,13]},"geometry":{"coordinates":[[106.682728,10.762327],[106.682795,10.762162],[106.682862,10.762187],[106.683001,10.762242],[106.682987,10.762277],[106.682764,10.762837],[106.682734,10.762912],[106.68256,10.76335],[106.682532,10.763419],[106.682491,10.763523],[106.68227,10.764075],[106.682251,10.764125],[106.68221,10.764228],[106.682298,10.764258]],"type":"LineString"}}]
/// bbox : [106.68221,10.762162,106.683001,10.764258]
/// metadata : {"attribution":"openrouteservice.org | OpenStreetMap contributors","service":"routing","timestamp":1659690684155,"query":{"coordinates":[[106.68272978846373,10.762327974338394],[106.68255606225208,10.764208492614566]],"profile":"driving-car","format":"geojson"},"engine":{"version":"6.7.0","build_date":"2022-02-18T19:37:41Z","graph_date":"2022-07-17T14:21:00Z"}}
DirectionOutput directionOutputFromJson(String str) =>
    DirectionOutput.fromJson(json.decode(str));
String directionOutputToJson(DirectionOutput data) =>
    json.encode(data.toJson());
class DirectionOutput {
  DirectionOutput({
    this.type,
    this.features,
    this.bbox,
    this.metadata,
  });

  DirectionOutput.fromJson(dynamic json) {
    type = json['type'];
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  String? type;
  List<Features>? features;
  List<num>? bbox;
  Metadata? metadata;

  DirectionOutput copyWith({
    String? type,
    List<Features>? features,
    List<num>? bbox,
    Metadata? metadata,
  }) =>
      DirectionOutput(
        type: type ?? this.type,
        features: features ?? this.features,
        bbox: bbox ?? this.bbox,
        metadata: metadata ?? this.metadata,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    map['bbox'] = bbox;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    return map;
  }
}

/// attribution : "openrouteservice.org | OpenStreetMap contributors"
/// service : "routing"
/// timestamp : 1659690684155
/// query : {"coordinates":[[106.68272978846373,10.762327974338394],[106.68255606225208,10.764208492614566]],"profile":"driving-car","format":"geojson"}
/// engine : {"version":"6.7.0","build_date":"2022-02-18T19:37:41Z","graph_date":"2022-07-17T14:21:00Z"}
Metadata metadataFromJson(String str) => Metadata.fromJson(json.decode(str));
String metadataToJson(Metadata data) => json.encode(data.toJson());
class Metadata {
  Metadata({
    this.attribution,
    this.service,
    this.timestamp,
    this.query,
    this.engine,
  });

  Metadata.fromJson(dynamic json) {
    attribution = json['attribution'];
    service = json['service'];
    timestamp = json['timestamp'];
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
    engine = json['engine'] != null ? Engine.fromJson(json['engine']) : null;
  }

  String? attribution;
  String? service;
  num? timestamp;
  Query? query;
  Engine? engine;

  Metadata copyWith({
    String? attribution,
    String? service,
    num? timestamp,
    Query? query,
    Engine? engine,
  }) =>
      Metadata(
        attribution: attribution ?? this.attribution,
        service: service ?? this.service,
        timestamp: timestamp ?? this.timestamp,
        query: query ?? this.query,
        engine: engine ?? this.engine,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attribution'] = attribution;
    map['service'] = service;
    map['timestamp'] = timestamp;
    if (query != null) {
      map['query'] = query?.toJson();
    }
    if (engine != null) {
      map['engine'] = engine?.toJson();
    }
    return map;
  }
}

/// version : "6.7.0"
/// build_date : "2022-02-18T19:37:41Z"
/// graph_date : "2022-07-17T14:21:00Z"
Engine engineFromJson(String str) => Engine.fromJson(json.decode(str));
String engineToJson(Engine data) => json.encode(data.toJson());
class Engine {
  Engine({
    this.version,
    this.buildDate,
    this.graphDate,
  });

  Engine.fromJson(dynamic json) {
    version = json['version'];
    buildDate = json['build_date'];
    graphDate = json['graph_date'];
  }

  String? version;
  String? buildDate;
  String? graphDate;

  Engine copyWith({
    String? version,
    String? buildDate,
    String? graphDate,
  }) =>
      Engine(
        version: version ?? this.version,
        buildDate: buildDate ?? this.buildDate,
        graphDate: graphDate ?? this.graphDate,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['build_date'] = buildDate;
    map['graph_date'] = graphDate;
    return map;
  }
}

/// coordinates : [[106.68272978846373,10.762327974338394],[106.68255606225208,10.764208492614566]]
/// profile : "driving-car"
/// format : "geojson"
Query queryFromJson(String str) => Query.fromJson(json.decode(str));
String queryToJson(Query data) => json.encode(data.toJson());
class Query {
  Query({
    this.coordinates,
    this.profile,
    this.format,
  });

  Query.fromJson(dynamic json) {
    coordinates = (json['coordinates'] != null
        ? List<dynamic>.from(json['coordinates']).map((item) => List<num>.from(item)).toList()
        : []).cast<List<num>>();
    profile = json['profile'];
    format = json['format'];
  }

  List<List<num>>? coordinates;
  String? profile;
  String? format;

  Query copyWith({
    List<List<num>>? coordinates,
    String? profile,
    String? format,
  }) =>
      Query(
        coordinates: coordinates ?? this.coordinates,
        profile: profile ?? this.profile,
        format: format ?? this.format,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coordinates'] = coordinates;
    map['profile'] = profile;
    map['format'] = format;
    return map;
  }
}

/// bbox : [106.68221,10.762162,106.683001,10.764258]
/// type : "Feature"
/// properties : {"segments":[{"distance":291.4,"duration":36.5,"steps":[{"distance":19.8,"duration":2.4,"type":11,"instruction":"Head south on Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[0,1]},{"distance":261.5,"duration":30.5,"type":6,"instruction":"Continue straight onto Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[1,12]},{"distance":10.2,"duration":3.7,"type":1,"instruction":"Turn right","name":"-","way_points":[12,13]},{"distance":0.0,"duration":0.0,"type":10,"instruction":"Arrive at your destination, on the right","name":"-","way_points":[13,13]}]}],"summary":{"distance":291.4,"duration":36.5},"way_points":[0,13]}
/// geometry : {"coordinates":[[106.682728,10.762327],[106.682795,10.762162],[106.682862,10.762187],[106.683001,10.762242],[106.682987,10.762277],[106.682764,10.762837],[106.682734,10.762912],[106.68256,10.76335],[106.682532,10.763419],[106.682491,10.763523],[106.68227,10.764075],[106.682251,10.764125],[106.68221,10.764228],[106.682298,10.764258]],"type":"LineString"}
Features featuresFromJson(String str) => Features.fromJson(json.decode(str));
String featuresToJson(Features data) => json.encode(data.toJson());
class Features {
  Features({
    this.bbox,
    this.type,
    this.properties,
    this.geometry,
  });

  Features.fromJson(dynamic json) {
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  List<num>? bbox;
  String? type;
  Properties? properties;
  Geometry? geometry;

  Features copyWith({
    List<num>? bbox,
    String? type,
    Properties? properties,
    Geometry? geometry,
  }) =>
      Features(
        bbox: bbox ?? this.bbox,
        type: type ?? this.type,
        properties: properties ?? this.properties,
        geometry: geometry ?? this.geometry,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bbox'] = bbox;
    map['type'] = type;
    if (properties != null) {
      map['properties'] = properties?.toJson();
    }
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    return map;
  }
}

/// coordinates : [[106.682728,10.762327],[106.682795,10.762162],[106.682862,10.762187],[106.683001,10.762242],[106.682987,10.762277],[106.682764,10.762837],[106.682734,10.762912],[106.68256,10.76335],[106.682532,10.763419],[106.682491,10.763523],[106.68227,10.764075],[106.682251,10.764125],[106.68221,10.764228],[106.682298,10.764258]]
/// type : "LineString"
Geometry geometryFromJson(String str) => Geometry.fromJson(json.decode(str));
String geometryToJson(Geometry data) => json.encode(data.toJson());
class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  Geometry.fromJson(dynamic json) {
    coordinates = (json['coordinates'] != null
        ? List<dynamic>.from(json['coordinates']).map((item) => List<num>.from(item)).toList()
        : []).cast<List<num>>();
    type = json['type'];
  }

  List<List<num>>? coordinates;
  String? type;

  Geometry copyWith({
    List<List<num>>? coordinates,
    String? type,
  }) =>
      Geometry(
        coordinates: coordinates ?? this.coordinates,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coordinates'] = coordinates;
    map['type'] = type;
    return map;
  }
}

/// segments : [{"distance":291.4,"duration":36.5,"steps":[{"distance":19.8,"duration":2.4,"type":11,"instruction":"Head south on Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[0,1]},{"distance":261.5,"duration":30.5,"type":6,"instruction":"Continue straight onto Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[1,12]},{"distance":10.2,"duration":3.7,"type":1,"instruction":"Turn right","name":"-","way_points":[12,13]},{"distance":0.0,"duration":0.0,"type":10,"instruction":"Arrive at your destination, on the right","name":"-","way_points":[13,13]}]}]
/// summary : {"distance":291.4,"duration":36.5}
/// way_points : [0,13]
Properties propertiesFromJson(String str) =>
    Properties.fromJson(json.decode(str));
String propertiesToJson(Properties data) => json.encode(data.toJson());
class Properties {
  Properties({
    this.segments,
    this.summary,
    this.wayPoints,
  });

  Properties.fromJson(dynamic json) {
    if (json['segments'] != null) {
      segments = [];
      json['segments'].forEach((v) {
        segments?.add(Segments.fromJson(v));
      });
    }
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    wayPoints =
        json['way_points'] != null ? json['way_points'].cast<num>() : [];
  }

  List<Segments>? segments;
  Summary? summary;
  List<num>? wayPoints;

  Properties copyWith({
    List<Segments>? segments,
    Summary? summary,
    List<num>? wayPoints,
  }) =>
      Properties(
        segments: segments ?? this.segments,
        summary: summary ?? this.summary,
        wayPoints: wayPoints ?? this.wayPoints,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (segments != null) {
      map['segments'] = segments?.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    map['way_points'] = wayPoints;
    return map;
  }
}

/// distance : 291.4
/// duration : 36.5
Summary summaryFromJson(String str) => Summary.fromJson(json.decode(str));
String summaryToJson(Summary data) => json.encode(data.toJson());
class Summary {
  Summary({
    this.distance,
    this.duration,
  });

  Summary.fromJson(dynamic json) {
    distance = json['distance'];
    duration = json['duration'];
  }

  num? distance;
  num? duration;

  Summary copyWith({
    num? distance,
    num? duration,
  }) =>
      Summary(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distance'] = distance;
    map['duration'] = duration;
    return map;
  }
}

/// distance : 291.4
/// duration : 36.5
/// steps : [{"distance":19.8,"duration":2.4,"type":11,"instruction":"Head south on Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[0,1]},{"distance":261.5,"duration":30.5,"type":6,"instruction":"Continue straight onto Đường Nguyễn Văn Cừ","name":"Đường Nguyễn Văn Cừ","way_points":[1,12]},{"distance":10.2,"duration":3.7,"type":1,"instruction":"Turn right","name":"-","way_points":[12,13]},{"distance":0.0,"duration":0.0,"type":10,"instruction":"Arrive at your destination, on the right","name":"-","way_points":[13,13]}]
Segments segmentsFromJson(String str) => Segments.fromJson(json.decode(str));
String segmentsToJson(Segments data) => json.encode(data.toJson());
class Segments {
  Segments({
    this.distance,
    this.duration,
    this.steps,
  });

  Segments.fromJson(dynamic json) {
    distance = json['distance'];
    duration = json['duration'];
    if (json['steps'] != null) {
      steps = [];
      json['steps'].forEach((v) {
        steps?.add(Steps.fromJson(v));
      });
    }
  }

  num? distance;
  num? duration;
  List<Steps>? steps;

  Segments copyWith({
    num? distance,
    num? duration,
    List<Steps>? steps,
  }) =>
      Segments(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        steps: steps ?? this.steps,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distance'] = distance;
    map['duration'] = duration;
    if (steps != null) {
      map['steps'] = steps?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// distance : 19.8
/// duration : 2.4
/// type : 11
/// instruction : "Head south on Đường Nguyễn Văn Cừ"
/// name : "Đường Nguyễn Văn Cừ"
/// way_points : [0,1]
Steps stepsFromJson(String str) => Steps.fromJson(json.decode(str));
String stepsToJson(Steps data) => json.encode(data.toJson());
class Steps {
  Steps({
    this.distance,
    this.duration,
    this.type,
    this.instruction,
    this.name,
    this.wayPoints,
  });

  Steps.fromJson(dynamic json) {
    distance = json['distance'];
    duration = json['duration'];
    type = json['type'];
    instruction = json['instruction'];
    name = json['name'];
    wayPoints =
        json['way_points'] != null ? json['way_points'].cast<num>() : [];
  }

  num? distance;
  num? duration;
  num? type;
  String? instruction;
  String? name;
  List<num>? wayPoints;

  Steps copyWith({
    num? distance,
    num? duration,
    num? type,
    String? instruction,
    String? name,
    List<num>? wayPoints,
  }) =>
      Steps(
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        type: type ?? this.type,
        instruction: instruction ?? this.instruction,
        name: name ?? this.name,
        wayPoints: wayPoints ?? this.wayPoints,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distance'] = distance;
    map['duration'] = duration;
    map['type'] = type;
    map['instruction'] = instruction;
    map['name'] = name;
    map['way_points'] = wayPoints;
    return map;
  }
}
