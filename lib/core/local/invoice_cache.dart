part of "hive_service_impl.dart";

abstract interface class InvoiceCache {
  Future<void> cacheInvoice(BarrenInvoiceModel invoice);
  BarrenInvoiceModel? getInvoice();
  Future<void> clearInvoice();
}
