import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/helper.dart';

// ==================== CLIENT SECTION ====================

class ClientSection extends StatelessWidget {
  final int? selectedClientId;
  final String? selectedClientName;
  final Function(int, String) onClientSelected;
  final VoidCallback onShowPicker;

  const ClientSection({
    super.key,
    required this.selectedClientId,
    required this.selectedClientName,
    required this.onClientSelected,
    required this.onShowPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_client'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: onShowPicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedClientId != null
                      ? AppColors.blue
                      : AppColors.line,
                  width: selectedClientId != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8.r),
                color: selectedClientId != null
                    ? AppColors.blueBg
                    : AppColors.whiteColor,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: selectedClientId != null
                        ? AppColors.blue
                        : AppColors.textMuted,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      selectedClientName ?? 'choose_client'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: selectedClientId != null
                            ? AppColors.textDark
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textMuted,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DATE RANGE SECTION ====================

class DateRangeSection extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function(DateTime) onFromDateChanged;
  final Function(DateTime) onToDateChanged;
  final String? label;

  const DateRangeSection({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  label: 'from'.tr(),
                  date: fromDate,
                  onChanged: onFromDateChanged,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDatePicker(
                  label: 'to'.tr(),
                  date: toDate,
                  onChanged: onToDateChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required Function(DateTime) onChanged,
    context
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: () async {
            final picked = await AppDatePicker.show(
              context: context,
              initialDate: date,
            );

            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.blue,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== CLIENT INFO CARD ====================

class ClientInfoCard extends StatelessWidget {
  final int clientId;
  final String clientName;

  const ClientInfoCard({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blue, AppColors.brandLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            color: AppColors.whiteColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'client'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.whiteColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  clientName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'ID: $clientId',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CLIENT PICKER DIALOG ====================

class ClientPickerDialog extends StatefulWidget {
  final List<Client> clients;
  final int? selectedClientId;
  final Function(int, String) onClientSelected;

  const ClientPickerDialog({
    super.key,
    required this.clients,
    required this.selectedClientId,
    required this.onClientSelected,
  });

  @override
  State<ClientPickerDialog> createState() => _ClientPickerDialogState();
}

class _ClientPickerDialogState extends State<ClientPickerDialog> {
  String searchQuery = '';

  List<Client> get filteredClients {
    if (searchQuery.isEmpty) return widget.clients;
    return widget.clients.where((client) =>
    client.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        client.code.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'select_client'.tr(),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400.h,
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16.h),
            Expanded(
              child: filteredClients.isEmpty
                  ? _buildEmptyState()
                  : _buildClientList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'cancel'.tr(),
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'search_clients'.tr(),
          hintStyle: TextStyle(color: AppColors.textMuted),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textMuted,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 48.sp,
            color: AppColors.textMuted,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_clients_found'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList() {
    return ListView.builder(
      itemCount: filteredClients.length,
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        final isSelected = widget.selectedClientId == client.id;

        return ListTile(
          selected: isSelected,
          selectedTileColor: AppColors.blueBg,
          leading: CircleAvatar(
            backgroundColor: isSelected ? AppColors.blue : AppColors.backgroundColor,
            child: Text(
              client.name[0].toUpperCase(),
              style: TextStyle(
                color: isSelected ? AppColors.whiteColor : AppColors.textMuted,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            client.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.blue : AppColors.textDark,
            ),
          ),
          subtitle: Text(
            'Code: ${client.code}',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
          ),
          trailing: isSelected
              ? Icon(
            Icons.check_circle,
            color: AppColors.blue,
            size: 20.sp,
          )
              : null,
          onTap: () {
            widget.onClientSelected(client.id, client.name);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

// ==================== MODELS ====================

class Client {
  final int id;
  final String name;
  final String code;

  Client({
    required this.id,
    required this.name,
    required this.code,
  });
}

class ClientStatementData {
  final double openingBalance;
  final double totalDebit;
  final double totalCredit;
  final double netBalance;
  final double closingBalance;
  final List<ClientTransaction> transactions;

  ClientStatementData({
    required this.openingBalance,
    required this.totalDebit,
    required this.totalCredit,
    required this.netBalance,
    required this.closingBalance,
    required this.transactions,
  });
}

class ClientTransaction {
  final String documentNo;
  final DateTime date;
  final double debit;
  final double credit;
  final double balance;
  final String? description;

  ClientTransaction({
    required this.documentNo,
    required this.date,
    required this.debit,
    required this.credit,
    required this.balance,
    this.description,
  });
}