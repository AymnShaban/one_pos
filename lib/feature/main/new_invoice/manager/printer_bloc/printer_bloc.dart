part of '../../new_invoice_imports.dart';

/// UI-free printer state. Image capture happens in the widget layer; the bloc
/// only deals in paired devices, connection, and the print request.
class PrinterState extends Equatable {
  final Status devicesStatus;
  final List<BluetoothInfo> devices;
  final String? connectedMac;
  final Status printStatus;
  final String? errorMessage;
  // ✅ أضف متغيرات الطابعة المدمجة
  final bool isBuiltInPrinter;
  final bool isBuiltInConnected;

  const PrinterState({
    this.devicesStatus = Status.initial,
    this.devices = const [],
    this.connectedMac,
    this.printStatus = Status.initial,
    this.errorMessage,
    this.isBuiltInPrinter = false,
    this.isBuiltInConnected = false,
  });

  PrinterState copyWith({
    Status? devicesStatus,
    List<BluetoothInfo>? devices,
    String? connectedMac,
    Status? printStatus,
    String? errorMessage,
    bool? isBuiltInPrinter,
    bool? isBuiltInConnected,
  }) {
    return PrinterState(
      devicesStatus: devicesStatus ?? this.devicesStatus,
      devices: devices ?? this.devices,
      connectedMac: connectedMac ?? this.connectedMac,
      printStatus: printStatus ?? this.printStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isBuiltInPrinter: isBuiltInPrinter ?? this.isBuiltInPrinter,
      isBuiltInConnected: isBuiltInConnected ?? this.isBuiltInConnected,
    );
  }

  @override
  List<Object?> get props => [
    devicesStatus,
    devices,
    connectedMac,
    printStatus,
    errorMessage,
    isBuiltInPrinter,
    isBuiltInConnected,
  ];
}

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  final PrinterDataSource _dataSource;

  PrinterBloc({required PrinterDataSource dataSource})
      : _dataSource = dataSource,
        super(const PrinterState()) {
    on<LoadPairedDevices>(_onLoadDevices);
    on<ConnectPrinter>(_onConnect);
    on<PrintReceipt>(_onPrint);
    // ✅ أضف الحدث الجديد
    on<ConnectBuiltInPrinter>(_onConnectBuiltIn);
    on<CheckBuiltInPrinter>(_onCheckBuiltIn);
  }

  Future<void> _onLoadDevices(
      LoadPairedDevices event,
      Emitter<PrinterState> emit,
      ) async {
    emit(state.copyWith(devicesStatus: Status.loading, errorMessage: null));
    final result = await _dataSource.pairedDevices();
    result.fold(
          (f) => emit(state.copyWith(
          devicesStatus: Status.failure, errorMessage: f.message)),
          (devices) =>
          emit(state.copyWith(devicesStatus: Status.success, devices: devices)),
    );
  }

  Future<void> _onConnect(
      ConnectPrinter event,
      Emitter<PrinterState> emit,
      ) async {
    emit(state.copyWith(printStatus: Status.loading, errorMessage: null));
    final result = await _dataSource.connect(event.mac);
    result.fold(
          (f) => emit(state.copyWith(
          printStatus: Status.failure, errorMessage: f.message)),
          (_) => emit(state.copyWith(
          connectedMac: event.mac,
          isBuiltInPrinter: false,
          isBuiltInConnected: false,
          errorMessage: null,
          printStatus: Status.success)),
    );
  }

  // ✅ دالة الاتصال بالطابعة المدمجة
  Future<void> _onConnectBuiltIn(
      ConnectBuiltInPrinter event,
      Emitter<PrinterState> emit,
      ) async {
    emit(state.copyWith(printStatus: Status.loading, errorMessage: null));
    final result = await _dataSource.connectBuiltIn();
    result.fold(
          (f) => emit(state.copyWith(
          printStatus: Status.failure, errorMessage: f.message)),
          (_) => emit(state.copyWith(
          connectedMac: PrinterDataSourceImpl.BUILT_IN_PRINTER_MAC,
          isBuiltInPrinter: true,
          isBuiltInConnected: true,
          errorMessage: null,
          printStatus: Status.success)),
    );
  }

  // ✅ دالة التحقق من وجود طابعة مدمجة
  Future<void> _onCheckBuiltIn(
      CheckBuiltInPrinter event,
      Emitter<PrinterState> emit,
      ) async {
    emit(state.copyWith(devicesStatus: Status.loading, errorMessage: null));
    final result = await _dataSource.isBuiltInPrinterAvailable();
    result.fold(
          (f) => emit(state.copyWith(
          devicesStatus: Status.failure, errorMessage: f.message)),
          (available) => emit(state.copyWith(
        devicesStatus: Status.success,
        isBuiltInPrinter: available,
        isBuiltInConnected: available,
        connectedMac: available ? PrinterDataSourceImpl.BUILT_IN_PRINTER_MAC : null,
      )),
    );
  }

  Future<void> _onPrint(
      PrintReceipt event,
      Emitter<PrinterState> emit,
      ) async {
    emit(state.copyWith(printStatus: Status.loading, errorMessage: null));

    // ✅ تحقق إذا كانت طابعة مدمجة
    final isBuiltIn = event.mac == PrinterDataSourceImpl.BUILT_IN_PRINTER_MAC;

    // Connect only if not already connected to the requested printer.
    final connected = await _dataSource.isConnected();
    final alreadyOn = connected.fold((_) => false, (v) => v);

    if (!alreadyOn || state.connectedMac != event.mac) {
      final conn = await _dataSource.connect(event.mac);
      final failed = conn.fold((f) => f, (_) => null);
      if (failed != null) {
        emit(state.copyWith(
            printStatus: Status.failure, errorMessage: failed.message));
        return;
      }
      emit(state.copyWith(
        connectedMac: event.mac,
        isBuiltInPrinter: isBuiltIn,
        isBuiltInConnected: isBuiltIn,
      ));
    }

    final result = await _dataSource.writeBytes(event.bytes);
    result.fold(
          (f) => emit(state.copyWith(
          printStatus: Status.failure, errorMessage: f.message)),
          (_) => emit(state.copyWith(printStatus: Status.success)),
    );
  }
}
