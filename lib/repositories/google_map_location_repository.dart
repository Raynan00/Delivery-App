
import 'package:active_ecommerce_seller_app/app_config.dart';
import 'package:active_ecommerce_seller_app/data_model/google_location_details_response.dart';
import 'package:active_ecommerce_seller_app/data_model/location_autocomplete_response.dart';
import 'package:http/http.dart' as http;

class GoogleMapLocationRepository{
 var GoogleMapAPIKey = "";

 Future<GoogleLocationAutoCompleteResponse> getAutoCompleteAddress(String text)async{
    Uri url = Uri.parse("https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$text&key=${GoogleMapAPIKey}");
    var response = await http.get(url);
    return googleLocationAutoCompleteResponseFromJson(response.body);
  }

 Future<GoogleLocationDetailsResponse> getAddressDetails(String placeId)async{
    Uri url = Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${GoogleMapAPIKey}");
    var response = await http.get(url);
    return googleLocationDetailsResponseFromJson(response.body);
  }


}