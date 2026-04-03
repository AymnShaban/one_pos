part of '../../sales_imports.dart';

class SalesAppBar extends StatelessWidget {
  final bool isOnline;

  const SalesAppBar({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xff3B5BDB),
      expandedHeight: 70.h,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isOnline ? 'connected'.tr() : 'disconnected'.tr(),
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'The One POS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'pos_subtitle'.tr(),
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.apps_rounded, color: Colors.white, size: 22.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}