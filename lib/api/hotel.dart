import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/accommondation.dart';

class HotelService {
  Future<List<Hotel>> fetchHotels() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/hotels'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Hotel> hotels = data.map((json) => Hotel.fromJson(json)).toList();
      return hotels;
    } else {
      throw Exception('Failed to load hotels');
    }
  }
}
