import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String hintText;
  final int? maxLine;
  final bool isDropDown;
  final List<String>? dropdownItems;
  final String? selectedValue;
  final Function(String?)? onDropdownChanged;
  final bool isPhoneNumber;

  final FormFieldValidator<String>? validator; // New validator field

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.hintText = '',
    this.maxLine = 1,
    this.isDropDown = false,
    this.dropdownItems,
    this.selectedValue,
    this.onDropdownChanged,
    this.isPhoneNumber = false,
    this.validator, // Initialize the validator
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.isPhoneNumber) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: widget.isPhoneNumber
          ? _buildPhoneNumberField()
          : (widget.isDropDown ? _buildDropdown() : _buildTextField()),
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      // Changed from TextField to TextFormField
      maxLines: widget.maxLine,
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator, // Apply the validator
      decoration: _getInputDecoration(),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: widget.selectedValue,
      items: widget.dropdownItems?.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: widget.onDropdownChanged,
      decoration: _getInputDecoration(),
      validator: widget.validator, // Apply the validator for dropdowns
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      // Changed from TextField to TextFormField
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      validator: widget.validator, // Apply the validator
      decoration: _getInputDecoration().copyWith(
        prefixIcon: _buildCountryCodeButton(),
      ),
    );
  }

  Widget _buildCountryCodeButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      labelText: widget.labelText,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      hintText: widget.hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black, width: 1.0),
      ),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.isPhoneNumber ? null : widget.prefixIcon,
    );
  }
}
