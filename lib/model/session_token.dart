// model/session_token.dart

import 'package:hive/hive.dart';

part 'session_token.g.dart';

@HiveType(typeId: 10)
class SessionToken {
  @HiveField(0)
  late String token;

  SessionToken({required this.token});
}
