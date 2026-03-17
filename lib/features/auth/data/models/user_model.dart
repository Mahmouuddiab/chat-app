import 'package:chat_app/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromFirebase(user) {
    return UserModel(
      id: user.uid,
      email: user.email,
    );
  }
}