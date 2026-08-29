
import 'invoice_profit.dart';

/// بيانات نموذجية لتقرير "أرباح الفواتير" — استبدلها باستدعاء API حقيقي.
/// ملاحظة: فاتورتا #7855 و#132 خاسرتان (profit < 0) وتُعرضان بحد أحمر فاتح
/// تلقائياً في الواجهة (انظر InvoiceProfit.isLoss).
final List<InvoiceProfit> sampleInvoiceProfits = [
  InvoiceProfit(
    number: "7855", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 17.250, cost: 18.870, profit: -1.620, discount: 0.000, additions: 0.500,
    netValue: 17.750, netProfit: -1.120, pctSale: -6.491, pctCost: -5.934, pct: 9.390,
  ),
  InvoiceProfit(
    number: "7856", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 6.400, cost: 3.020, profit: 3.380, discount: 0.000, additions: 0.000,
    netValue: 6.400, netProfit: 3.380, pctSale: 52.817, pctCost: 111.940, pct: 52.817,
  ),
  InvoiceProfit(
    number: "7857", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 9.500, cost: 2.536, profit: 6.964, discount: 0.000, additions: 0.000,
    netValue: 9.500, netProfit: 6.964, pctSale: 73.304, pctCost: 274.583, pct: 73.304,
  ),
  InvoiceProfit(
    number: "7859", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 8.800, cost: 5.696, profit: 3.104, discount: 0.000, additions: 0.950,
    netValue: 9.750, netProfit: 4.054, pctSale: 46.071, pctCost: 71.181, pct: 35.276,
  ),
  InvoiceProfit(
    number: "7860", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 3.750, cost: 1.474, profit: 2.276, discount: 0.000, additions: 0.500,
    netValue: 4.250, netProfit: 2.776, pctSale: 74.021, pctCost: 188.287, pct: 60.687,
  ),
  InvoiceProfit(
    number: "7861", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 6.300, cost: 3.947, profit: 2.353, discount: 0.000, additions: 0.000,
    netValue: 6.300, netProfit: 2.353, pctSale: 37.342, pctCost: 59.596, pct: 37.342,
  ),
  InvoiceProfit(
    number: "7862", client: "طلبات بالحساب", date: "2026/07/28",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 5.850, cost: 2.595, profit: 3.255, discount: 0.000, additions: 0.500,
    netValue: 6.350, netProfit: 3.755, pctSale: 64.192, pctCost: 144.724, pct: 55.645,
  ),
  InvoiceProfit(
    number: "7863", client: "طلبات بالحساب", date: "2026/07/29",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 4.300, cost: 2.615, profit: 1.685, discount: 0.000, additions: 0.500,
    netValue: 4.800, netProfit: 2.185, pctSale: 50.820, pctCost: 83.574, pct: 39.192,
  ),
  InvoiceProfit(
    number: "7864", client: "طلبات بالحساب", date: "2026/07/29",
    description: "مبيعات فرع كاكاو لندن - الشويخ",
    total: 15.050, cost: 6.943, profit: 8.107, discount: 0.000, additions: 0.000,
    netValue: 15.050, netProfit: 8.107, pctSale: 53.866, pctCost: 116.758, pct: 53.866,
  ),
  InvoiceProfit(
    number: "132", client: "صندوق مخزن المرتجعات", date: "2026/07/28",
    description: "م. تصفيات",
    total: 14.155, cost: 38.719, profit: -24.564, discount: 0.000, additions: 0.000,
    netValue: 14.155, netProfit: -24.564, pctSale: -173.536, pctCost: -63.442, pct: 173.536,
  ),
];

/// إجماليات الفترة (من شريط الأرقام أعلى شاشة النتائج) — 253 سجل بالكامل
/// في نسخة الويب، هذا الملف يحتوي فقط أول 10 كنموذج للواجهة.
const double invoiceProfitTotalAmount = 3895.743;
const double invoiceProfitTotalCost = 2258.532;
const double invoiceProfitTotalProfit = 1637.211;
const double invoiceProfitTotalNetProfit = 1454.889;
const int invoiceProfitRecordCount = 253;
