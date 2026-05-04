import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../../../core/helper/helper.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/services/service_locator/services_imports.dart';
import '../../bloc/activation_bloc/activation_bloc.dart';
import '../../bloc/activation_bloc/activation_event.dart';
import '../../bloc/log_in_bloc/log_in_bloc.dart';
import '../../models/activation_model.dart';
import 'login_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  @override
  void initState() {
    super.initState();
    // Get device info on startup
    context.read<ActivationBloc>().initDevice(context);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ActivationBloc>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<ActivationBloc, BaseState<ActivationModel>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // Config retrieved — go to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => getIt<LoginBloc>(),
                  child: const LoginScreen(),
                ),
              ),
            );
          }
          if (state.status == Status.failure) {
            showCustomSnackBar(
              context,
              state.errorMessage?.tr() ?? 'common.error'.tr(),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),

                // Logo
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.apps_rounded,
                    color: AppColors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  'The One POS',
                  style: AppTextTheme.titleSmallBold
                      .copyWith(color: AppColors.black),
                ),
                Text(
                  'home.pos_subtitle'.tr(),
                  style: AppTextTheme.body2.copyWith(color: AppColors.grey),
                ),
                SizedBox(height: 48.h),

                // Title
                Text(
                  'auth.enter_activation_code'.tr(),
                  style:
                  AppTextTheme.heading2.copyWith(color: AppColors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'auth.activation_hint'.tr(),
                  style: AppTextTheme.body2.copyWith(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // 4 key fields
                Row(
                  children: [
                    _KeyField(
                      controller: bloc.key1Controller,
                      focusNode:  bloc.focusNode1,
                      hint:       'KEY 1',
                      inputFormatters: [_ActivationPasteFormatter()],
                      onChanged: (v) {
                        if (v.contains('-')) {
                          bloc.pasteFullCode(v);
                        } else {
                          bloc.moveToNextField(
                              v, bloc.focusNode1, bloc.focusNode2);
                        }
                      },
                    ),
                    _Divider(),
                    _KeyField(
                      controller: bloc.key2Controller,
                      focusNode:  bloc.focusNode2,
                      hint:       'KEY 2',
                      onChanged: (v) => bloc.moveToNextField(
                          v, bloc.focusNode2, bloc.focusNode3),
                    ),
                    _Divider(),
                    _KeyField(
                      controller: bloc.key3Controller,
                      focusNode:  bloc.focusNode3,
                      hint:       'KEY 3',
                      onChanged: (v) => bloc.moveToNextField(
                          v, bloc.focusNode3, bloc.focusNode4),
                    ),
                    _Divider(),
                    _KeyField(
                      controller: bloc.key4Controller,
                      focusNode:  bloc.focusNode4,
                      hint:       'KEY 4',
                      onChanged:  (_) {},
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // Confirm button
                BlocBuilder<ActivationBloc, BaseState<ActivationModel>>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return CircularProgressIndicator(
                        color: AppColors.mainAppColor,
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ActivationBloc>().add(
                            CheckActivationCode(
                              key1: bloc.key1Controller.text.trim(),
                              key2: bloc.key2Controller.text.trim(),
                              key3: bloc.key3Controller.text.trim(),
                              key4: bloc.key4Controller.text.trim(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainAppColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'common.confirm'.tr(),
                          style: AppTextTheme.body2Bold
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // Cancel / exit
                TextButton(
                  onPressed: () => _showExitDialog(context),
                  child: Text(
                    'common.cancel'.tr(),
                    style:
                    AppTextTheme.body2.copyWith(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'auth.exit_confirmation'.tr(),
          style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('common.cancel'.tr(),
                      style: AppTextTheme.caption
                          .copyWith(color: AppColors.grey)),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    elevation: 0,
                  ),
                  child: Text('common.confirm'.tr(),
                      style: AppTextTheme.caption
                          .copyWith(color: AppColors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeyField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const _KeyField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller:    controller,
        focusNode:     focusNode,
        textAlign:     TextAlign.center,
        maxLength:     inputFormatters == null ? 4 : null,
        inputFormatters: inputFormatters,
        onChanged:     onChanged,
        style: AppTextTheme.body2Bold.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          counterText: '',
          hintText:    hint,
          hintStyle:
          AppTextTheme.caption.copyWith(color: AppColors.grey),
          filled:      true,
          fillColor:   AppColors.whiteColor,
          isDense:     true,
          contentPadding: EdgeInsets.symmetric(
              vertical: 14.h, horizontal: 8.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide:
            BorderSide(color: AppColors.mainAppColor, width: 2),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Text(
        '-',
        style: AppTextTheme.heading2.copyWith(color: AppColors.grey),
      ),
    );
  }
}

// Lets a full dashed activation code (e.g. "7283-9D98-F38D-43SA")
// pass through onChanged so the bloc can distribute it across all 4 fields,
// while still capping plain typing at 4 characters.
class _ActivationPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final t = newValue.text;
    if (t.contains('-')) return newValue;
    if (t.length > 4) {
      return TextEditingValue(
        text: t.substring(0, 4),
        selection: const TextSelection.collapsed(offset: 4),
      );
    }
    return newValue;
  }
}