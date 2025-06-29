// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/api_config.dart';

// class FatSecretApiService {
//   Future<String?> getAccessToken() async {
//     final response = await http.post(
//       Uri.parse(fatSecretTokenUrl),
//       headers: {
//         'Authorization':
//             'Basic ' +
//             base64Encode(
//               utf8.encode('$fatSecretClientId:$fatSecretClientSecret'),
//             ),
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {'grant_type': 'client_credentials', 'scope': 'basic'},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['access_token'];
//     } else {
//       print('Gagal mendapatkan access token: ${response.statusCode}');
//       print(response.body);
//       return null;
//     }
//   }

//   Future<dynamic> searchFood(String foodQuery, String accessToken) async {
//     final response = await http.post(
//       Uri.parse(fatSecretApiBaseUrl),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {
//         'method': 'foods.search',
//         'search_expression': foodQuery,
//         'format': 'json',
//       },
//     );
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       print('Gagal mencari makanan: ${response.statusCode}');
//       print(response.body);
//       return null;
//     }
//   }
// }
