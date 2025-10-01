import 'package:equatable/equatable.dart';

//kelas dasar untuk semua login event
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

//event yang dipicu pas tombol login diteken
class LoginButtonPressed extends AuthEvent {
  final String username;
  final String password;

  const LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class cekAutoLogin extends AuthEvent{}

class LogoutButtonPressed extends AuthEvent {}

class RefreshTokenRequested extends AuthEvent {}