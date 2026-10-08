import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecItem {
  String label;
  String value;
  SpecItem({required this.label, required this.value});
}

class AdminAddProductScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AdminAddProductScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedCategory = 'Electronics & Gadgets';
  final List<String> _categories = [
    'Electronics & Gadgets',
    'Mobiles & Accessories',
    'Audio & Headphones',
    'Wearables & Smart Watches',
    'Computers & Laptops',
    'Home Appliances',
  ];

  final List<SpecItem> _specifications = [
    SpecItem(label: 'Battery Life', value: '30 Hours'),
    SpecItem(label: 'Connectivity', value: 'Bluetooth 5.3'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _subCategoryController.dispose();
    _brandController.dispose();
    _shortDescController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addSpecification() {
    setState(() {
      _specifications.add(SpecItem(label: '', value: ''));
    });
  }

  void _removeSpecification(int index) {
    setState(() {
      _specifications.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "${_nameController.text.isEmpty ? "Wireless Noise Cancelling Headphones" : _nameController.text}" added to catalog!'),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: widget.onBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Product',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Sharma Electronics',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          // 3D E-Commerce Catalog Illustration Badge
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_shopping_cart_rounded,
                color: Color(0xFF7C3AED),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Product Name ──
                _buildFieldLabel('Product Name'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'e.g. Wireless Noise Cancelling Headphones',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ── 2. Category Dropdown ──
                _buildFieldLabel('Category'),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                      items: _categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(
                            cat,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ── 3. Subcategory & Brand (2-Column Row) ──
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Subcategory'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _subCategoryController,
                            hintText: 'e.g. Headphones',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Brand'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _brandController,
                            hintText: 'e.g. SoundMax',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── 4. Short Description ──
                _buildFieldLabel('Short Description'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _shortDescController,
                  hintText: 'One line that appears on the product card',
                ),

                const SizedBox(height: 18),

                // ── 5. Full Description ──
                _buildFieldLabel('Description'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: "Describe the product, its features and what's included",
                  maxLines: 4,
                ),

                const SizedBox(height: 22),

                // ── 6. Specifications Section ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Specifications',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Technical details',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Dynamic spec list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _specifications.length,
                  itemBuilder: (ctx, idx) {
                    final spec = _specifications[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              initialValue: spec.label,
                              onChanged: (val) => spec.label = val,
                              decoration: _inputDecoration(hint: 'Label (e.g. Color)'),
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              initialValue: spec.value,
                              onChanged: (val) => spec.value = val,
                              decoration: _inputDecoration(hint: 'Value (e.g. Matte Black)'),
                              style: GoogleFonts.inter(fontSize: 13),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFEF4444), size: 20),
                            onPressed: () => _removeSpecification(idx),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 6),

                // + Add specification button
                GestureDetector(
                  onTap: _addSpecification,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFC084FC),
                        style: BorderStyle.solid,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded, color: Color(0xFF7C3AED), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '+ Add specification',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── 7. Continue CTA Button ──
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 13.5, color: const Color(0xFF0F172A)),
      decoration: _inputDecoration(hint: hintText),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 13,
        color: const Color(0xFF94A3B8),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
      ),
    );
  }
}
