import 'package:flutter_test/flutter_test.dart';
import 'package:one_pos/feature/main/new_invoice/new_invoice_imports.dart';

void main() {
  // Since models are 'part of' new_invoice_imports.dart, we need to import that.
  // But unit tests usually need the specific file or the main import.

  test('CreateInvoiceRequest toJson should match user requirements', () {
    const request = CreateInvoiceRequest(
      invoicePatternId: 2,
      invoiceDate: "2026/04/23",
      companyBranchId: 1,
      remainder: 0,
      currencyId: 1,
      currencyRate: 1,
      customerId: 60,
      totalValue: 90,
      totalAddition: 0,
      totalDiscount: 0,
      finalValue: 90,
      payingType: 0,
      prePaid: 90,
      createdBy: "مدير",
      items: [], // Simplified for test
      payWays: [], // Simplified for test
    );

    final json = request.toJson();

    expect(json['InvoiceID'], 2);
    expect(json['InvoiceDate'], "2026/04/23");
    expect(json['CompanyBranchID'], 1);
    expect(json['PayingType'], 0);
    expect(json['CurrencyID'], 1);
    expect(json['Rate'], 1);
    expect(json['CustomerID'], 60);
    expect(json['Createdby'], "مدير");
    expect(json['TotalValue'], 90);
    expect(json['TotalAddition'], 0);
    expect(json['TotalDiscount'], 0);
    expect(json['FinalValue'], 90);
    expect(json['Remainder'], 0);
    expect(json['PrePaid'], 90);
  });
}
