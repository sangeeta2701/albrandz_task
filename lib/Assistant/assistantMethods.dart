import 'package:albrandz_task/Assistant/requestAssistant.dart';
import 'package:albrandz_task/Models/directionDetails.dart';
import 'package:albrandz_task/mapConfig.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = '';
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key= $mapKey";

    var response = await RequestAssistant.getRequest(url);
    if (response != "Failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }

  // static Future<DirectionDetails> obtainDirectionDetails(
  //     LatLng initialPosition, LatLng finalPosition) async {
  //   String directionUrl =
  //       "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude}, ${initialPosition.longitude}&key=$mapKey";

  //   var res = await RequestAssistant.getRequest(directionUrl);
  //   if (res == "Failed") {
  //     return null;
  //   }
  //   DirectionDetails directionDetails = DirectionDetails(distanceValue: direrec, durationValue: durationValue, distanceText: distanceText, durationText: durationText, encodedPoints: encodedPoints)

  //   directionDetails.encodedPoints =  res['routes'][0]["overview_polyline"]['points'];
  //   directionDetails.distanceText =  res["routes"][0]["legs"]['distance']["text"];
  //   directionDetails.distanceValue =  res["routes"][0]["legs"]['distance']["value"];
  //   directionDetails.durationText =  res["routes"][0]["legs"]['duration']["text"];
  //   directionDetails.durationValue =  res["routes"][0]["legs"]['duration']["value"];
  //   return directionDetails;

  // }
}
