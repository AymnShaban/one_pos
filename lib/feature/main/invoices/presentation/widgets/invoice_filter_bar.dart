part of '../../invoices_imports.dart';

class InvoiceFilterBar extends StatefulWidget {
  const InvoiceFilterBar({super.key});

  @override
  State<InvoiceFilterBar> createState() => _InvoiceFilterBarState();
}

class _InvoiceFilterBarState extends State<InvoiceFilterBar> {
  InvoiceStatus _selected = InvoiceStatus.all;

  static const _filters = [
    InvoiceStatus.all,
    InvoiceStatus.completed,
    InvoiceStatus.pending,
    InvoiceStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
        child: SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final status = _filters[index];
              final isSelected = _selected == status;
              return GestureDetector(
                onTap: () {
                  setState(() => _selected = status);
                  context
                      .read<InvoicesBloc>()
                      .add(FilterInvoicesByStatus(status));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff3B5BDB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    status.arLabel,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xff1A1A1A),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
        SizedBox(width: 8.w),
        // Filter icon button
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            Icons.filter_alt_outlined,
            color: const Color(0xff8A8F99),
            size: 20.sp,
          ),
        ),


        // Chips — scrollable RTL

      ],
    );
  }
}