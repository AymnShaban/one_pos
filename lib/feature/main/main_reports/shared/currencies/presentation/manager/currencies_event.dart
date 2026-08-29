import '../../../shared_imports.dart';
abstract class CurrenciesEvent extends Equatable {
  const CurrenciesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrencies extends CurrenciesEvent {}

class SelectCurrency extends CurrenciesEvent {
  final int currencyId;
  final double? exchangeRate; // ✅ سعر الصرف

  const SelectCurrency({
    required this.currencyId,
    this.exchangeRate,
  });

  @override
  List<Object?> get props => [currencyId, exchangeRate];
}