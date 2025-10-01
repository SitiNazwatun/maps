import 'package:equatable/equatable.dart';
import '../../model/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//state awal saat aplikasi pertama kali dibuka
class AuthInitial extends AuthState {}

//state saat proses login sedang berlangsung (tampilkan loading)
class AuthLoading extends AuthState {}

//state saat login berhasil
class AuthSuccess extends AuthState {
  final UserModel user; //simpan data yang dibutuhkan dari API
  // final String password;

  const AuthSuccess({required this.user,});

  @override
  List<Object> get props => [user];
}

//state pas login gagal
class AuthGagal extends AuthState{
  final String error;

  const AuthGagal({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthLoggedOut extends AuthState {}