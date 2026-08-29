import 'package:easy_localization/easy_localization.dart';


import '../../../../../../core/helper/helper.dart';
import '../../../../../../core/widgets/filter_widgets.dart';
import '../../data/models/price_type_model.dart';
import '../../data/price_types.dart';

class PriceTypesSectionWidget extends StatelessWidget {
  final PriceTypeModel salePrice;
  final PriceTypeModel costPrice;
  final Function(PriceTypeModel) onSalePriceChanged;
  final Function(PriceTypeModel) onCostPriceChanged;
  final bool isLoading;

  const PriceTypesSectionWidget({super.key,
    required this.salePrice,
    required this.costPrice,
    required this.onSalePriceChanged,
    required this.onCostPriceChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(title: "price_types".tr()),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: FilterDropdownField<PriceTypeModel>(
                label: "sale_price".tr(),
                value: salePrice,
                items: priceTypes,
                itemText: (e) => e.name,
                onChanged: (value) {
                  if (value == null || isLoading) return;
                  onSalePriceChanged(value);
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: FilterDropdownField<PriceTypeModel>(
                label: "cost_price".tr(),
                value: costPrice,
                items: priceTypes,
                itemText: (e) => e.name,
                onChanged: (value) {
                  if (value == null || isLoading) return;
                  onCostPriceChanged(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

