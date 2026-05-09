import 'package:equatable/equatable.dart';

abstract class ActivationEvent extends Equatable {
  const ActivationEvent();

  @override
  List<Object?> get props => [];
}

class CheckActivationCode extends ActivationEvent {
  final String key1;
  final String key2;
  final String key3;
  final String key4;

  const CheckActivationCode({
    required this.key1,
    required this.key2,
    required this.key3,
    required this.key4,
  });

  @override
  List<Object?> get props => [key1, key2, key3, key4];
}

class CheckDeviceActivation extends ActivationEvent {
  const CheckDeviceActivation();
}

class DeactivateDevice extends ActivationEvent {
  const DeactivateDevice();
}

