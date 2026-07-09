part of '../../new_invoice_imports.dart';

/// UI-free printer state. Image capture happens in the widget layer; the bloc
/// only deals in paired devices, connection, and the print request.
class PrinterState extends Equatable {
  final Status devicesStatus;
  final List<BluetoothInfo> devices;
  final String? connectedMac;
  final Status printStatus;
  final String? errorMessage;

  const PrinterState({
    this.devicesStatus = Status.initial,
    this.devices = const [],
    this.connectedMac,
    this.printStatus = Status.initial,
    this.errorMessage,
  });

  PrinterState copyWith({
    Status? devicesStatus,
    List<BluetoothInfo>? devices,
    String? connectedMac,
    Status? printStatus,
    String? errorMessage,
  }) {
    return PrinterState(
      devicesStatus: devicesStatus ?? this.devicesStatus,
      devices: devices ?? this.devices,
      connectedMac: connectedMac ?? this.connectedMac,
      printStatus: printStatus ?? this.printStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [devicesStatus, devices, connectedMac, printStatus, errorMessage];
}

class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  final PrinterDataSource _dataSource;

  PrinterBloc({required PrinterDataSource dataSource})
      : _dataSource = dataSource,
        super(const PrinterState()) {
    on<LoadPairedDevices>(_onLoadDevices);
    on<ConnectPrinter>(_onConnect);
    on<PrintReceipt>(_onPrint);
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
    final result = await _dataSource.connect(event.mac);
    result.fold(
      (f) => emit(state.copyWith(
          printStatus: Status.failure, errorMessage: f.message)),
      (_) => emit(state.copyWith(connectedMac: event.mac, errorMessage: null)),
    );
  }

  Future<void> _onPrint(
    PrintReceipt event,
    Emitter<PrinterState> emit,
  ) async {
    emit(state.copyWith(printStatus: Status.loading, errorMessage: null));

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
      emit(state.copyWith(connectedMac: event.mac));
    }

    final result = await _dataSource.writeBytes(event.bytes);
    result.fold(
      (f) => emit(state.copyWith(
          printStatus: Status.failure, errorMessage: f.message)),
      (_) => emit(state.copyWith(printStatus: Status.success)),
    );
  }
}
