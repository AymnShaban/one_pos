part of '../../new_invoice_imports.dart';


abstract class PrinterEvent extends Equatable {
  const PrinterEvent();

  @override
  List<Object?> get props => [];
}

/// Load the list of already-paired Bluetooth devices.
class LoadPairedDevices extends PrinterEvent {
  const LoadPairedDevices();
}

/// Connect to a printer by MAC address.
class ConnectPrinter extends PrinterEvent {
  final String mac;

  const ConnectPrinter(this.mac);

  @override
  List<Object?> get props => [mac];
}

/// Send already-rendered ESC/POS [bytes] to [mac] (connecting first if needed).
class PrintReceipt extends PrinterEvent {
  final String mac;
  final List<int> bytes;

  const PrintReceipt({required this.mac, required this.bytes});

  @override
  List<Object?> get props => [mac, bytes];
}

// ✅ أحداث جديدة للطابعة المدمجة

/// Connect to the built-in printer.
class ConnectBuiltInPrinter extends PrinterEvent {
  const ConnectBuiltInPrinter();
}

/// Check if built-in printer is available.
class CheckBuiltInPrinter extends PrinterEvent {
  const CheckBuiltInPrinter();
}