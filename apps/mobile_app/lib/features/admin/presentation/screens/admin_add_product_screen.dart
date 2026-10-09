import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_models/shared_models.dart';
import '../../../../core/services/api_service.dart';
import '../../../products/cubit/products_cubit.dart';

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
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _locationController = TextEditingController(text: 'Bengaluru');
  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  String _selectedCategory = 'Electronics & Gadgets';
  final List<String> _categories = [
    'Electronics & Gadgets',
    'Mobiles & Accessories',
    'Audio & Headphones',
    'Wearables & Smart Watches',
    'Computers & Laptops',
    'Home Appliances',
    'Vehicles',
    'Fashion',
  ];

  final List<String> _sampleImages = [
    'assets/images/h.png',
    'assets/images/h1.png',
    'assets/images/h2.png',
    'assets/images/h3.png',
    'assets/images/h4.png',
    'assets/images/h5.png',
    'assets/images/h6.png',
  ];
  late String _selectedImagePath;

  final List<SpecItem> _specifications = [
    SpecItem(label: 'Battery Life', value: '30 Hours'),
    SpecItem(label: 'Connectivity', value: 'Bluetooth 5.3'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedImagePath = _sampleImages.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _subCategoryController.dispose();
    _brandController.dispose();
    _locationController.dispose();
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

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    final apiService = context.read<ApiService>();

    final rawPrice = _priceController.text.replaceAll(',', '').replaceAll('₹', '').trim();
    final priceVal = double.tryParse(rawPrice) ?? 999.0;

    final specMap = <String, dynamic>{};
    for (final s in _specifications) {
      if (s.label.trim().isNotEmpty && s.value.trim().isNotEmpty) {
        specMap[s.label.trim()] = s.value.trim();
      }
    }
    if (_brandController.text.trim().isNotEmpty) {
      specMap['Brand'] = _brandController.text.trim();
    }

    final newListing = MarketListing(
      id: 'list_${DateTime.now().millisecondsSinceEpoch}',
      title: _nameController.text.trim(),
      price: priceVal,
      formattedPrice: '₹ ${priceVal.toInt()}',
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : 'Bengaluru',
      category: _selectedCategory,
      subcategory: _subCategoryController.text.trim(),
      imagePath: _selectedImagePath,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : _shortDescController.text.trim(),
      sellerId: 'ven_zara_p',
      sellerName: 'Zara Philip',
      status: 'active',
      isFeatured: true,
      createdAt: DateTime.now(),
      specifications: specMap,
    );

    final created = await apiService.createListing(newListing);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (created != null) {
      // Refresh buyer-facing cubit so buyer view sees the live update
      try {
        context.read<ProductsCubit>().loadInitialData();
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "${newListing.title}" created & saved to MySQL database!'),
          backgroundColor: const Color(0xFF16A34A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onBack();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save product to database. Please try again.'),
          backgroundColor: Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
              'Sharma Electronics • MySQL Live',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF16A34A),
                fontWeight: FontWeight.w500,
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
                _buildFieldLabel('Product Name *'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'e.g. Sony WH-1000XM5 Wireless Headphones',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ── 2. Price & Location (2-Column Row) ──
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Price (₹) *'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _priceController,
                            hintText: 'e.g. 19999',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Enter price';
                              }
                              final num = double.tryParse(val.replaceAll(',', '').replaceAll('₹', '').trim());
                              if (num == null || num <= 0) {
                                return 'Valid price required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Location'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            controller: _locationController,
                            hintText: 'e.g. Bengaluru',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── 3. Category Dropdown ──
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

                // ── 4. Subcategory & Brand (2-Column Row) ──
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
                            hintText: 'e.g. Over-Ear Headphones',
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
                            hintText: 'e.g. Sony',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── 5. Product Image Selection ──
                _buildFieldLabel('Select Product Image'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 68,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sampleImages.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (ctx, idx) {
                      final img = _sampleImages[idx];
                      final isSelected = _selectedImagePath == img;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedImagePath = img),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
                              width: isSelected ? 2.5 : 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.inventory_2_outlined, color: Color(0xFF64748B)),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF7C3AED),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // ── 6. Short Description ──
                _buildFieldLabel('Short Description'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _shortDescController,
                  hintText: 'One line that appears on the product card',
                ),

                const SizedBox(height: 18),

                // ── 7. Full Description ──
                _buildFieldLabel('Description'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: "Describe the product, its features and what's included",
                  maxLines: 4,
                ),

                const SizedBox(height: 22),

                // ── 8. Specifications Section ──
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

                // ── 9. Continue CTA Button ──
                GestureDetector(
                  onTap: _isSubmitting ? null : _submitForm,
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
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(
                            'Save to Catalog & Database',
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
