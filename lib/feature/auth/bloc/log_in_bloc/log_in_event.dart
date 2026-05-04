import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String phone;
  final String password;

  const LoginSubmitted({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}