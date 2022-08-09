class OpenRouteServiceConstants {
  static const apiKey = "5b3ce3597851110001cf6248468b7465bf3342c680cb429d891e5f0a";
  static const baseUrl = "https://api.openrouteservice.org";
  static const apiVer2 = "/v2";
  static const actions = {
    "autocomplete": "/geocode/autocomplete",
    "geocodeReverse": "/geocode/reverse",
    "directions": "/directions",
  };
  static const vehicles = {
    "driving-car": "/driving-car",
  };
  static const outputTypes = {
    "json": "/json",
    "geojson": "/geojson",
  };
}