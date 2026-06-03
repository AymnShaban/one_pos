import 'package:hive/hive.dart';

import '../../feature/barren/domain/entities/invoice_product.dart';

part 'barren_invoice_model.g.dart';

/// The persisted snapshot of an in-progress stock-taking session: when it
/// was last saved + the list of scanned lines. There is only ever one
/// snapshot stored at a time (keyed by `current_invoice` in the Hive box).
@HiveType(typeId: 1)
class BarrenInvoiceModel {
  @HiveField(0)
  final DateTime savedAt;
  @HiveField(1)
  final List<InvoiceProduct> products;

  BarrenInvoiceModel({
    required this.savedAt,
    required this.products,
  });
}
