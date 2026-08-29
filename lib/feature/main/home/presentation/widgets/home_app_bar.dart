import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_pos/core/constant/app_assets.dart';

import '../../../sales/sales_imports.dart';

class HomeAppBar extends StatelessWidget {
  final bool isOnline;
  final VoidCallback? onSearchTap;
  final VoidCallback? onScanTap;
  final bool showBasket;
  const HomeAppBar({
    super.key,
    this.showBasket = false,
    required this.isOnline,
    this.onSearchTap,
    this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,

      toolbarHeight: 70.h,
      backgroundColor: const Color(0xff3B5BDB),
      expandedHeight: 70.h,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildGridIcon(),
                SizedBox(width: 12.w),
                _buildTitle(),

                SizedBox(width:10.w),
                (showBasket)?
                BasketIconButton():Spacer(),
                if (onSearchTap != null) _buildActionIcon(Icons.search, onSearchTap!),
                if (onScanTap != null) ...[
                  SizedBox(width: 4.w),
                  _buildActionIcon(Icons.qr_code_scanner, onScanTap!),

                ],

                _buildConnectivityIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectivityIndicator() {
    return Row(
      children: [
        Text(
          isOnline ? 'home.connected'.tr() : 'home.disconnected'.tr(),
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
        SizedBox(width: 6.w),

        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onTap,
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
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
          'home.pos_subtitle'.tr(),
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildGridIcon() {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AppAssets.appLogo),
          fit: BoxFit.contain,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }


}
