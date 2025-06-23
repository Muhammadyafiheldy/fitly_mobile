// import 'dart:convert';
// import 'package:fitly_v1/models/notification_model.dart';
// import 'package:http/http.dart' as http;
// import '../config/api_config.dart';
// import '../model/Notification_model.dart';

// class ProductService {
//   static Future<List<NotificationModel>> fetchNotifications() async {
//     final response = await http.get(Uri.parse(ApiConfig.NotificationApi));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List Notifications = data['Notifications'];
//       return Notifications.map((e) => NotificationModel.fromJson(e)).toList();
//     } else {
//       throw Exception('Gagal memuat produk');
//     }
//   }
// }
