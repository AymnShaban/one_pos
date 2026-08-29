
part of '../../sales_imports.dart';



class BasketIconButton extends StatelessWidget {
  const BasketIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BaseState<ItemModel>>(
      buildWhen: (previous, current) =>
      previous.items.length != current.items.length,
      builder: (context, state) {
        final count = state.items.length;
        if (count == 0) {
          return const SizedBox.shrink();
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14.r),
                onTap: () {
                  final setupBloc = context.read<InvoiceSetupBloc>();
                  final branchBloc = context.read<BranchBloc>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: getIt<BasketBloc>()),
                          BlocProvider.value(value: setupBloc),
                          BlocProvider.value(value: branchBloc),
                          BlocProvider.value(value: getIt<NewInvoiceBloc>()),
                        ],
                        child: const BasketScreen(),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.shopping_basket_rounded,      color: AppColors.whiteColor,

                    size: 22.sp,
                  ),
                ),
              ),
            ),

            if (count > 0)
              Positioned(
                right: -4.w,
                top: -4.h,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: count > 9 ? 5.w : 0,
                  ),
                  width: count > 9 ? null : 20.w,
                  height: 20.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: count > 9
                        ? BoxShape.rectangle
                        : BoxShape.circle,
                    borderRadius: count > 9
                        ? BorderRadius.circular(20.r)
                        : null,
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: AppTextTheme.labelSmall.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}