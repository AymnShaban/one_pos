part of '../../reports_imports.dart';
class StockTakingButton extends StatelessWidget {
  const StockTakingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<InvoiceCubit>(
                create: (_) => getIt<InvoiceCubit>(),
                child: const BarrenStockTakingScreen(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.inventory_2_rounded, color: Colors.white),
        label: Text(
          'stock_taking_button'.tr(),
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff40C057),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}