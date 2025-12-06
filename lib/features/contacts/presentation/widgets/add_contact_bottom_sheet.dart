import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wimo/core/utils/formatters.dart';
import 'package:wimo/core/utils/validators.dart';
import 'package:wimo/core/widgets/overlay_message.dart';
import 'package:wimo/features/contacts/presentation/cubit/contacts_cubit.dart';

/// Add contact bottom sheet widget
class AddContactBottomSheet extends StatefulWidget {
  const AddContactBottomSheet({super.key});

  @override
  State<AddContactBottomSheet> createState() => _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends State<AddContactBottomSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.w,
        right: 24.w,
        top: 24.h,
      ),
      child: BlocConsumer<ContactsCubit, ContactsState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          final isLoading = state is ContactsAddingContact;
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHandleBar(),
                SizedBox(height: 24.h),
                _buildHeader(context),
                SizedBox(height: 28.h),
                _buildNameField(isLoading),
                SizedBox(height: 18.h),
                _buildPhoneField(isLoading),
                SizedBox(height: 24.h),
                _buildInfoBox(),
                SizedBox(height: 28.h),
                _buildSaveButton(context, isLoading),
                SizedBox(height: 36.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ContactsState state) {
    if (state is ContactsLoaded) {
      Navigator.pop(context);
      OverlayMessage.show(
        context: context,
        message: 'Contact added successfully!',
        isError: false,
      );
    } else if (state is ContactNotFound) {
      OverlayMessage.show(
        context: context,
        message: state.message,
        isError: true,
      );
    } else if (state is ContactsError) {
      OverlayMessage.show(
        context: context,
        message: state.errorMessage,
        isError: true,
      );
    }
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        width: 48.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(3.r),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(Icons.person_add, color: Colors.white, size: 28.w),
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Text(
            'Add New Contact',
            style: TextStyle(
              fontSize: 24.h,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, size: 28.w),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildNameField(bool isLoading) {
    return TextFormField(
      controller: _nameController,
      enabled: !isLoading,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: 16.h),
      decoration: _inputDecoration(
        label: 'Name',
        hint: 'Enter contact name',
        icon: Icons.person_outline,
      ),
      validator: Validators.validateName,
    );
  }

  Widget _buildPhoneField(bool isLoading) {
    return TextFormField(
      controller: _phoneController,
      enabled: !isLoading,
      keyboardType: TextInputType.phone,
      inputFormatters: [Formatters.phoneFormatter],
      style: TextStyle(fontSize: 16.h),
      decoration: _inputDecoration(
        label: 'Phone Number',
        hint: '+1234567890',
        icon: Icons.phone_outlined,
      ),
      validator: Validators.validatePhone,
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 22.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF667EEA).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.info_outline, color: Colors.white, size: 18.w),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'Only contacts using this app can be added',
              style: TextStyle(
                fontSize: 13.h,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF667EEA),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.4),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _handleSave(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 22.h,
                width: 22.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Add Contact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.h,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      context.read<ContactsCubit>().addContact(name: name, phone: phone);
    }
  }
}
