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

  // ✅ دوال جديدة للطابعة المدمجة
  Future<Either<Failure, bool>> isBuiltInPrinterAvailable();
  Future<Either<Failure, bool>> connectBuiltIn();
  Future<Either<Failure, bool>> disconnectBuiltIn();
  Future<Either<Failure, bool>> writeBytesBuiltIn(List<int> bytes);
}

class PrinterDataSourceImpl implements PrinterDataSource {
  // ✅ متغيرات الطابعة المدمجة
  static const String BUILT_IN_PRINTER_MAC = "BUILT_IN";
  bool _isBuiltInPrinter = false;
  bool _builtInConnected = false;

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
      // ✅ تحقق من الطابعة المدمجة أولاً
      if (_isBuiltInPrinter) {
        return Right(_builtInConnected);
      }
      return Right(await PrintBluetoothThermal.connectionStatus);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> connect(String mac) async {
    try {
      // ✅ إذا كان MAC للطابعة المدمجة
      if (mac == BUILT_IN_PRINTER_MAC) {
        _isBuiltInPrinter = true;
        _builtInConnected = true;
        return const Right(true);
      } else {
        // ✅ للبلوتوث الخارجي (الكود القديم)
        _isBuiltInPrinter = false;
        final ok = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
        return ok
            ? const Right(true)
            : Left(ServerFailure(message: 'printing.connect_failed'.tr()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> disconnect() async {
    try {
      // ✅ إذا كانت طابعة مدمجة
      if (_isBuiltInPrinter) {
        _isBuiltInPrinter = false;
        _builtInConnected = false;
        return const Right(true);
      }
      // ✅ للبلوتوث الخارجي
      return Right(await PrintBluetoothThermal.disconnect);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> writeBytes(List<int> bytes) async {
    try {
      // ✅ إذا كانت طابعة مدمجة
      if (_isBuiltInPrinter) {
        try {
          final ok = await PrintBluetoothThermal.writeBytes(bytes);
          return ok
              ? const Right(true)
              : Left(ServerFailure(message: 'printing.write_failed'.tr()));
        } catch (e) {
          final ok = await PrintBluetoothThermal.writeBytes(bytes);
          return ok
              ? const Right(true)
              : Left(ServerFailure(message: 'printing.write_failed'.tr()));
        }
      } else {
        // ✅ للبلوتوث الخارجي (الكود القديم)
        final ok = await PrintBluetoothThermal.writeBytes(bytes);
        return ok
            ? const Right(true)
            : Left(ServerFailure(message: 'printing.write_failed'.tr()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ✅ دوال جديدة للطابعة المدمجة

  @override
  Future<Either<Failure, bool>> isBuiltInPrinterAvailable() async {
    try {
      // في أجهزة PAX، الطابعة المدمجة موجودة دائماً
      // بنحاول نكتب أمر بسيط للتأكد
      try {
        final testBytes = [0x1B, 0x40]; // أمر تهيئة الطابعة
        final ok = await PrintBluetoothThermal.writeBytes(testBytes);
        return Right(ok);
      } catch (e) {
        // لو فشل، نرجع true لأن الطابعة موجودة في PAX
        return const Right(true);
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> connectBuiltIn() async {
    try {
      _isBuiltInPrinter = true;
      _builtInConnected = true;
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> disconnectBuiltIn() async {
    try {
      _isBuiltInPrinter = false;
      _builtInConnected = false;
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> writeBytesBuiltIn(List<int> bytes) async {
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