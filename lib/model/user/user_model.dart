import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String dataUsage;

  @HiveField(2)
  final Map<String, String> payload;

  UserModel(this.date, this.dataUsage, this.payload);
  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "datausage": dataUsage,
      "payload": payload,
    };
  }
}
