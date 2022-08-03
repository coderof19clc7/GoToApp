import 'dart:convert';

/// geocoding : {"version":"0.2","attribution":"https://openrouteservice.org/terms-of-service/#attribution-geocode","query":{"text":"AEOn mall, Ho Chi Minh city","parser":"pelias","parsed_text":{"subject":"AEOn mall","street":"AEOn mall","locality":"Ho Chi Minh city","admin":"Ho Chi Minh city"},"size":10,"layers":["venue","street","country","macroregion","region","county","localadmin","locality","borough","neighbourhood","continent","empire","dependency","macrocounty","macrohood","microhood","disputed","postalcode","ocean","marinearea"],"private":false,"lang":{"name":"English","iso6391":"en","iso6393":"eng","via":"default","defaulted":true},"querySize":20},"warnings":["performance optimization: excluding 'address' layer"],"engine":{"name":"Pelias","author":"Mapzen","version":"1.0"},"timestamp":1659522048005}
/// type : "FeatureCollection"
/// features : [{"type":"Feature","geometry":{"type":"Point","coordinates":[106.617934,10.802055]},"properties":{"id":"way/299682396","gid":"openstreetmap:venue:way/299682396","layer":"venue","source":"openstreetmap","source_id":"way/299682396","name":"Aeon Mall Tân Phú","housenumber":"30","street":"Bờ Bao Tân Thắng","accuracy":"point","country":"Vietnam","country_gid":"whosonfirst:country:85632763","country_a":"VNM","region":"Ho Chi Minh","region_gid":"whosonfirst:region:85680809","region_a":"HC","county":"Quan 8","county_gid":"whosonfirst:county:1108782041","locality":"Ho Chi Minh City","locality_gid":"whosonfirst:locality:421176809","continent":"Asia","continent_gid":"whosonfirst:continent:102191569","label":"Aeon Mall Tân Phú, Ho Chi Minh City, HC, Vietnam","addendum":{"osm":{"wheelchair":"yes","operator":"Aeon","opening_hours":"Mo-Fr 08:00-22:00 and Sa-Su 07:00-22:00","opening_hours:covid19":"same"}}},"bbox":[106.6154148,10.8005257,106.6188588,10.8029428]},{"type":"Feature","geometry":{"type":"Point","coordinates":[106.611973,10.742958]},"properties":{"id":"way/504157823","gid":"openstreetmap:venue:way/504157823","layer":"venue","source":"openstreetmap","source_id":"way/504157823","name":"Aeon Mall Bình Tân","accuracy":"point","country":"Vietnam","country_gid":"whosonfirst:country:85632763","country_a":"VNM","region":"Ho Chi Minh","region_gid":"whosonfirst:region:85680809","region_a":"HC","county":"Quan 8","county_gid":"whosonfirst:county:1108782041","locality":"Ho Chi Minh City","locality_gid":"whosonfirst:locality:421176809","continent":"Asia","continent_gid":"whosonfirst:continent:102191569","label":"Aeon Mall Bình Tân, Ho Chi Minh City, HC, Vietnam"},"bbox":[106.610557,10.7416794,106.6130108,10.7434603]},{"type":"Feature","geometry":{"type":"Point","coordinates":[106.618541,10.800856]},"properties":{"id":"node/4582793333","gid":"openstreetmap:venue:node/4582793333","layer":"venue","source":"openstreetmap","source_id":"node/4582793333","name":"Trạm Xe Bus AEON Mall","accuracy":"point","country":"Vietnam","country_gid":"whosonfirst:country:85632763","country_a":"VNM","region":"Ho Chi Minh","region_gid":"whosonfirst:region:85680809","region_a":"HC","county":"Quan 8","county_gid":"whosonfirst:county:1108782041","locality":"Ho Chi Minh City","locality_gid":"whosonfirst:locality:421176809","continent":"Asia","continent_gid":"whosonfirst:continent:102191569","label":"Trạm Xe Bus AEON Mall, Ho Chi Minh City, HC, Vietnam"}}]
/// bbox : [106.610557,10.7416794,106.6188588,10.8029428]
AutocompleteOutput autocompleteOutputFromJson(String str) =>
    AutocompleteOutput.fromJson(json.decode(str));
String autocompleteOutputToJson(AutocompleteOutput data) =>
    json.encode(data.toJson());
class AutocompleteOutput {
  AutocompleteOutput({
    this.geocoding,
    this.type,
    this.features,
    this.bbox,
  });

  AutocompleteOutput.fromJson(dynamic json) {
    geocoding = json['geocoding'] != null
        ? Geocoding.fromJson(json['geocoding'])
        : null;
    type = json['type'];
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(Features.fromJson(v));
      });
    }
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
  }

  Geocoding? geocoding;
  String? type;
  List<Features>? features;
  List<num>? bbox;

  AutocompleteOutput copyWith({
    Geocoding? geocoding,
    String? type,
    List<Features>? features,
    List<num>? bbox,
  }) =>
      AutocompleteOutput(
        geocoding: geocoding ?? this.geocoding,
        type: type ?? this.type,
        features: features ?? this.features,
        bbox: bbox ?? this.bbox,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (geocoding != null) {
      map['geocoding'] = geocoding?.toJson();
    }
    map['type'] = type;
    if (features != null) {
      map['features'] = features?.map((v) => v.toJson()).toList();
    }
    map['bbox'] = bbox;
    return map;
  }
}

/// type : "Feature"
/// geometry : {"type":"Point","coordinates":[106.617934,10.802055]}
/// properties : {"id":"way/299682396","gid":"openstreetmap:venue:way/299682396","layer":"venue","source":"openstreetmap","source_id":"way/299682396","name":"Aeon Mall Tân Phú","housenumber":"30","street":"Bờ Bao Tân Thắng","accuracy":"point","country":"Vietnam","country_gid":"whosonfirst:country:85632763","country_a":"VNM","region":"Ho Chi Minh","region_gid":"whosonfirst:region:85680809","region_a":"HC","county":"Quan 8","county_gid":"whosonfirst:county:1108782041","locality":"Ho Chi Minh City","locality_gid":"whosonfirst:locality:421176809","continent":"Asia","continent_gid":"whosonfirst:continent:102191569","label":"Aeon Mall Tân Phú, Ho Chi Minh City, HC, Vietnam","addendum":{"osm":{"wheelchair":"yes","operator":"Aeon","opening_hours":"Mo-Fr 08:00-22:00 and Sa-Su 07:00-22:00","opening_hours:covid19":"same"}}}
/// bbox : [106.6154148,10.8005257,106.6188588,10.8029428]
Features featuresFromJson(String str) => Features.fromJson(json.decode(str));
String featuresToJson(Features data) => json.encode(data.toJson());
class Features {
  Features({
    this.type,
    this.geometry,
    this.properties,
    this.bbox,
  });

  Features.fromJson(dynamic json) {
    type = json['type'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    bbox = json['bbox'] != null ? json['bbox'].cast<num>() : [];
  }

  String? type;
  Geometry? geometry;
  Properties? properties;
  List<num>? bbox;

  Features copyWith({
    String? type,
    Geometry? geometry,
    Properties? properties,
    List<num>? bbox,
  }) =>
      Features(
        type: type ?? this.type,
        geometry: geometry ?? this.geometry,
        properties: properties ?? this.properties,
        bbox: bbox ?? this.bbox,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    if (properties != null) {
      map['properties'] = properties?.toJson();
    }
    map['bbox'] = bbox;
    return map;
  }
}

/// id : "way/299682396"
/// gid : "openstreetmap:venue:way/299682396"
/// layer : "venue"
/// source : "openstreetmap"
/// source_id : "way/299682396"
/// name : "Aeon Mall Tân Phú"
/// housenumber : "30"
/// street : "Bờ Bao Tân Thắng"
/// accuracy : "point"
/// country : "Vietnam"
/// country_gid : "whosonfirst:country:85632763"
/// country_a : "VNM"
/// region : "Ho Chi Minh"
/// region_gid : "whosonfirst:region:85680809"
/// region_a : "HC"
/// county : "Quan 8"
/// county_gid : "whosonfirst:county:1108782041"
/// locality : "Ho Chi Minh City"
/// locality_gid : "whosonfirst:locality:421176809"
/// continent : "Asia"
/// continent_gid : "whosonfirst:continent:102191569"
/// label : "Aeon Mall Tân Phú, Ho Chi Minh City, HC, Vietnam"
/// addendum : {"osm":{"wheelchair":"yes","operator":"Aeon","opening_hours":"Mo-Fr 08:00-22:00 and Sa-Su 07:00-22:00","opening_hours:covid19":"same"}}

Properties propertiesFromJson(String str) => Properties.fromJson(json.decode(str));
String propertiesToJson(Properties data) => json.encode(data.toJson());
class Properties {
  Properties({
    this.id,
    this.gid,
    this.layer,
    this.source,
    this.sourceId,
    this.name,
    this.housenumber,
    this.street,
    this.accuracy,
    this.country,
    this.countryGid,
    this.countryA,
    this.region,
    this.regionGid,
    this.regionA,
    this.county,
    this.countyGid,
    this.locality,
    this.localityGid,
    this.continent,
    this.continentGid,
    this.label,
    this.addendum,
  });

  Properties.fromJson(dynamic json) {
    id = json['id'];
    gid = json['gid'];
    layer = json['layer'];
    source = json['source'];
    sourceId = json['source_id'];
    name = json['name'];
    housenumber = json['housenumber'];
    street = json['street'];
    accuracy = json['accuracy'];
    country = json['country'];
    countryGid = json['country_gid'];
    countryA = json['country_a'];
    region = json['region'];
    regionGid = json['region_gid'];
    regionA = json['region_a'];
    county = json['county'];
    countyGid = json['county_gid'];
    locality = json['locality'];
    localityGid = json['locality_gid'];
    continent = json['continent'];
    continentGid = json['continent_gid'];
    label = json['label'];
    addendum =
        json['addendum'] != null ? Addendum.fromJson(json['addendum']) : null;
  }

  String? id;
  String? gid;
  String? layer;
  String? source;
  String? sourceId;
  String? name;
  String? housenumber;
  String? street;
  String? accuracy;
  String? country;
  String? countryGid;
  String? countryA;
  String? region;
  String? regionGid;
  String? regionA;
  String? county;
  String? countyGid;
  String? locality;
  String? localityGid;
  String? continent;
  String? continentGid;
  String? label;
  Addendum? addendum;

  Properties copyWith({
    String? id,
    String? gid,
    String? layer,
    String? source,
    String? sourceId,
    String? name,
    String? housenumber,
    String? street,
    String? accuracy,
    String? country,
    String? countryGid,
    String? countryA,
    String? region,
    String? regionGid,
    String? regionA,
    String? county,
    String? countyGid,
    String? locality,
    String? localityGid,
    String? continent,
    String? continentGid,
    String? label,
    Addendum? addendum,
  }) =>
      Properties(
        id: id ?? this.id,
        gid: gid ?? this.gid,
        layer: layer ?? this.layer,
        source: source ?? this.source,
        sourceId: sourceId ?? this.sourceId,
        name: name ?? this.name,
        housenumber: housenumber ?? this.housenumber,
        street: street ?? this.street,
        accuracy: accuracy ?? this.accuracy,
        country: country ?? this.country,
        countryGid: countryGid ?? this.countryGid,
        countryA: countryA ?? this.countryA,
        region: region ?? this.region,
        regionGid: regionGid ?? this.regionGid,
        regionA: regionA ?? this.regionA,
        county: county ?? this.county,
        countyGid: countyGid ?? this.countyGid,
        locality: locality ?? this.locality,
        localityGid: localityGid ?? this.localityGid,
        continent: continent ?? this.continent,
        continentGid: continentGid ?? this.continentGid,
        label: label ?? this.label,
        addendum: addendum ?? this.addendum,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['gid'] = gid;
    map['layer'] = layer;
    map['source'] = source;
    map['source_id'] = sourceId;
    map['name'] = name;
    map['housenumber'] = housenumber;
    map['street'] = street;
    map['accuracy'] = accuracy;
    map['country'] = country;
    map['country_gid'] = countryGid;
    map['country_a'] = countryA;
    map['region'] = region;
    map['region_gid'] = regionGid;
    map['region_a'] = regionA;
    map['county'] = county;
    map['county_gid'] = countyGid;
    map['locality'] = locality;
    map['locality_gid'] = localityGid;
    map['continent'] = continent;
    map['continent_gid'] = continentGid;
    map['label'] = label;
    if (addendum != null) {
      map['addendum'] = addendum?.toJson();
    }
    return map;
  }
}

/// osm : {"wheelchair":"yes","operator":"Aeon","opening_hours":"Mo-Fr 08:00-22:00 and Sa-Su 07:00-22:00","opening_hours:covid19":"same"}
Addendum addendumFromJson(String str) => Addendum.fromJson(json.decode(str));
String addendumToJson(Addendum data) => json.encode(data.toJson());
class Addendum {
  Addendum({
    this.osm,
  });

  Addendum.fromJson(dynamic json) {
    osm = json['osm'] != null ? Osm.fromJson(json['osm']) : null;
  }

  Osm? osm;

  Addendum copyWith({
    Osm? osm,
  }) =>
      Addendum(
        osm: osm ?? this.osm,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (osm != null) {
      map['osm'] = osm?.toJson();
    }
    return map;
  }
}

/// wheelchair : "yes"
/// operator : "Aeon"
/// opening_hours : "Mo-Fr 08:00-22:00 and Sa-Su 07:00-22:00"
/// opening_hours:covid19 : "same"
Osm osmFromJson(String str) => Osm.fromJson(json.decode(str));
String osmToJson(Osm data) => json.encode(data.toJson());
class Osm {
  Osm({
    this.wheelchair,
    this.operator,
    this.openingHours,
    this.openingHourscovid19,
  });

  Osm.fromJson(dynamic json) {
    wheelchair = json['wheelchair'];
    operator = json['operator'];
    openingHours = json['opening_hours'];
    openingHourscovid19 = json['opening_hours:covid19'];
  }

  String? wheelchair;
  String? operator;
  String? openingHours;
  String? openingHourscovid19;

  Osm copyWith({
    String? wheelchair,
    String? operator,
    String? openingHours,
    String? openingHourscovid19,
  }) =>
      Osm(
        wheelchair: wheelchair ?? this.wheelchair,
        operator: operator ?? this.operator,
        openingHours: openingHours ?? this.openingHours,
        openingHourscovid19: openingHourscovid19 ?? this.openingHourscovid19,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wheelchair'] = wheelchair;
    map['operator'] = operator;
    map['opening_hours'] = openingHours;
    map['opening_hours:covid19'] = openingHourscovid19;
    return map;
  }
}

/// type : "Point"
/// coordinates : [106.617934,10.802055]
Geometry geometryFromJson(String str) => Geometry.fromJson(json.decode(str));
String geometryToJson(Geometry data) => json.encode(data.toJson());
class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  Geometry.fromJson(dynamic json) {
    type = json['type'];
    coordinates =
        json['coordinates'] != null ? json['coordinates'].cast<num>() : [];
  }

  String? type;
  List<num>? coordinates;

  Geometry copyWith({
    String? type,
    List<num>? coordinates,
  }) =>
      Geometry(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['coordinates'] = coordinates;
    return map;
  }
}

/// version : "0.2"
/// attribution : "https://openrouteservice.org/terms-of-service/#attribution-geocode"
/// query : {"text":"AEOn mall, Ho Chi Minh city","parser":"pelias","parsed_text":{"subject":"AEOn mall","street":"AEOn mall","locality":"Ho Chi Minh city","admin":"Ho Chi Minh city"},"size":10,"layers":["venue","street","country","macroregion","region","county","localadmin","locality","borough","neighbourhood","continent","empire","dependency","macrocounty","macrohood","microhood","disputed","postalcode","ocean","marinearea"],"private":false,"lang":{"name":"English","iso6391":"en","iso6393":"eng","via":"default","defaulted":true},"querySize":20}
/// warnings : ["performance optimization: excluding 'address' layer"]
/// engine : {"name":"Pelias","author":"Mapzen","version":"1.0"}
/// timestamp : 1659522048005
Geocoding geocodingFromJson(String str) => Geocoding.fromJson(json.decode(str));
String geocodingToJson(Geocoding data) => json.encode(data.toJson());
class Geocoding {
  Geocoding({
    this.version,
    this.attribution,
    this.query,
    this.warnings,
    this.engine,
    this.timestamp,
  });

  Geocoding.fromJson(dynamic json) {
    version = json['version'];
    attribution = json['attribution'];
    query = json['query'] != null ? Query.fromJson(json['query']) : null;
    warnings = json['warnings'] != null ? json['warnings'].cast<String>() : [];
    engine = json['engine'] != null ? Engine.fromJson(json['engine']) : null;
    timestamp = json['timestamp'];
  }

  String? version;
  String? attribution;
  Query? query;
  List<String>? warnings;
  Engine? engine;
  num? timestamp;

  Geocoding copyWith({
    String? version,
    String? attribution,
    Query? query,
    List<String>? warnings,
    Engine? engine,
    num? timestamp,
  }) =>
      Geocoding(
        version: version ?? this.version,
        attribution: attribution ?? this.attribution,
        query: query ?? this.query,
        warnings: warnings ?? this.warnings,
        engine: engine ?? this.engine,
        timestamp: timestamp ?? this.timestamp,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['attribution'] = attribution;
    if (query != null) {
      map['query'] = query?.toJson();
    }
    map['warnings'] = warnings;
    if (engine != null) {
      map['engine'] = engine?.toJson();
    }
    map['timestamp'] = timestamp;
    return map;
  }
}

/// name : "Pelias"
/// author : "Mapzen"
/// version : "1.0"
Engine engineFromJson(String str) => Engine.fromJson(json.decode(str));
String engineToJson(Engine data) => json.encode(data.toJson());
class Engine {
  Engine({
    this.name,
    this.author,
    this.version,
  });

  Engine.fromJson(dynamic json) {
    name = json['name'];
    author = json['author'];
    version = json['version'];
  }

  String? name;
  String? author;
  String? version;

  Engine copyWith({
    String? name,
    String? author,
    String? version,
  }) =>
      Engine(
        name: name ?? this.name,
        author: author ?? this.author,
        version: version ?? this.version,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['author'] = author;
    map['version'] = version;
    return map;
  }
}

/// text : "AEOn mall, Ho Chi Minh city"
/// parser : "pelias"
/// parsed_text : {"subject":"AEOn mall","street":"AEOn mall","locality":"Ho Chi Minh city","admin":"Ho Chi Minh city"}
/// size : 10
/// layers : ["venue","street","country","macroregion","region","county","localadmin","locality","borough","neighbourhood","continent","empire","dependency","macrocounty","macrohood","microhood","disputed","postalcode","ocean","marinearea"]
/// private : false
/// lang : {"name":"English","iso6391":"en","iso6393":"eng","via":"default","defaulted":true}
/// querySize : 20
Query queryFromJson(String str) => Query.fromJson(json.decode(str));
String queryToJson(Query data) => json.encode(data.toJson());
class Query {
  Query({
    this.text,
    this.parser,
    this.parsedText,
    this.size,
    this.layers,
    this.private,
    this.lang,
    this.querySize,
  });

  Query.fromJson(dynamic json) {
    text = json['text'];
    parser = json['parser'];
    parsedText = json['parsed_text'] != null
        ? ParsedText.fromJson(json['parsed_text'])
        : null;
    size = json['size'];
    layers = json['layers'] != null ? json['layers'].cast<String>() : [];
    private = json['private'];
    lang = json['lang'] != null ? Lang.fromJson(json['lang']) : null;
    querySize = json['querySize'];
  }

  String? text;
  String? parser;
  ParsedText? parsedText;
  num? size;
  List<String>? layers;
  bool? private;
  Lang? lang;
  num? querySize;

  Query copyWith({
    String? text,
    String? parser,
    ParsedText? parsedText,
    num? size,
    List<String>? layers,
    bool? private,
    Lang? lang,
    num? querySize,
  }) =>
      Query(
        text: text ?? this.text,
        parser: parser ?? this.parser,
        parsedText: parsedText ?? this.parsedText,
        size: size ?? this.size,
        layers: layers ?? this.layers,
        private: private ?? this.private,
        lang: lang ?? this.lang,
        querySize: querySize ?? this.querySize,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    map['parser'] = parser;
    if (parsedText != null) {
      map['parsed_text'] = parsedText?.toJson();
    }
    map['size'] = size;
    map['layers'] = layers;
    map['private'] = private;
    if (lang != null) {
      map['lang'] = lang?.toJson();
    }
    map['querySize'] = querySize;
    return map;
  }
}

/// name : "English"
/// iso6391 : "en"
/// iso6393 : "eng"
/// via : "default"
/// defaulted : true
Lang langFromJson(String str) => Lang.fromJson(json.decode(str));
String langToJson(Lang data) => json.encode(data.toJson());
class Lang {
  Lang({
    this.name,
    this.iso6391,
    this.iso6393,
    this.via,
    this.defaulted,
  });

  Lang.fromJson(dynamic json) {
    name = json['name'];
    iso6391 = json['iso6391'];
    iso6393 = json['iso6393'];
    via = json['via'];
    defaulted = json['defaulted'];
  }

  String? name;
  String? iso6391;
  String? iso6393;
  String? via;
  bool? defaulted;

  Lang copyWith({
    String? name,
    String? iso6391,
    String? iso6393,
    String? via,
    bool? defaulted,
  }) =>
      Lang(
        name: name ?? this.name,
        iso6391: iso6391 ?? this.iso6391,
        iso6393: iso6393 ?? this.iso6393,
        via: via ?? this.via,
        defaulted: defaulted ?? this.defaulted,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['iso6391'] = iso6391;
    map['iso6393'] = iso6393;
    map['via'] = via;
    map['defaulted'] = defaulted;
    return map;
  }
}

/// subject : "AEOn mall"
/// street : "AEOn mall"
/// locality : "Ho Chi Minh city"
/// admin : "Ho Chi Minh city"
ParsedText parsedTextFromJson(String str) =>
    ParsedText.fromJson(json.decode(str));
String parsedTextToJson(ParsedText data) => json.encode(data.toJson());
class ParsedText {
  ParsedText({
    this.subject,
    this.street,
    this.locality,
    this.admin,
  });

  ParsedText.fromJson(dynamic json) {
    subject = json['subject'];
    street = json['street'];
    locality = json['locality'];
    admin = json['admin'];
  }

  String? subject;
  String? street;
  String? locality;
  String? admin;

  ParsedText copyWith({
    String? subject,
    String? street,
    String? locality,
    String? admin,
  }) =>
      ParsedText(
        subject: subject ?? this.subject,
        street: street ?? this.street,
        locality: locality ?? this.locality,
        admin: admin ?? this.admin,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subject'] = subject;
    map['street'] = street;
    map['locality'] = locality;
    map['admin'] = admin;
    return map;
  }
}
