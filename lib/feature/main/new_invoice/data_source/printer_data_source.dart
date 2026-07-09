part of '../new_invoice_imports.dart';

/// Thin wrapper over `print_bluetooth_thermal` returning [Either] to match the
/// project's data-source style. Bluetooth Classic / SPP only (Android).
abstract interface class PrinterDataSource {
  Future<Either<Failure, List<BluetoothInfo>>> pairedDevices();
  Future<Either<Failure, bool>> isBluetoothEnabled();
  Future<Either<Failure, bool>> isConnected();
  Future<Either<Failure, bool>> connect(String mac);
  Future<Either<Failure, bool>> disconnect();
  Future<Either<Failure, bool>> writeBytes(List<int> bytes);
}

class PrinterDataSourceImpl implements PrinterDataSource {
  @override
  Future<Either<Failure, List<BluetoothInfo>>> pairedDevices() async {
    try {
      final devices = await PrintBluetoothThermal.pairedBluetooths;
      return Right(devices);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBluetoothEnabled() async {
    try {
      return Right(await PrintBluetoothThermal.bluetoothEnabled);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isConnected() async {
    try {
      return Right(await PrintBluetoothThermal.connectionStatus);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> connect(String mac) async {
    try {
      final ok = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
      return ok
          ? const Right(true)
          : Left(ServerFailure(message: 'printing.connect_failed'.tr()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> disconnect() async {
    try {
      return Right(await PrintBluetoothThermal.disconnect);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> writeBytes(List<int> bytes) async {
    try {
      final ok = await PrintBluetoothThermal.writeBytes(bytes);
      return ok
          ? const Right(true)
          : Left(ServerFailure(message: 'printing.write_failed'.tr()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
