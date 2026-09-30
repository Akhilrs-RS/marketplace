import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_models/shared_models.dart';
import 'select_listing_category_screen.dart';
import 'listing_preview_screen.dart';

class CreateListingScreen extends StatefulWidget {
  final ListingCategoryItem categoryItem;

  const CreateListingScreen({
    super.key,
    required this.categoryItem,
  });

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedSubcategory;
  String _selectedCondition = 'Like New';

  // Controllers
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController(text: 'Kochi, Kerala');
  final _descriptionController = TextEditingController();

  // Media
  late List<String> _photos;

  // Flags
  bool _isNegotiable = true;
  bool _maskPhone = true;

  // Category Specific Specs
  // Vehicle Specs
  String _vehicleBrand = 'Hyundai';
  String _vehicleYear = '2023';
  String _vehicleFuel = 'Petrol';
  String _vehicleTransmission = 'Automatic';
  final _vehicleKmController = TextEditingController(text: '24,000');
  String _vehicleOwners = '1st Owner';

  // Property Specs
  String _propertyType = 'For Sale';
  String _propertyBedrooms = '3 BHK';
  final _propertyAreaController = TextEditingController(text: '1,450');
  String _propertyFurnished = 'Semi-Furnished';

  // Electronics Specs
  String _electronicsBrand = 'Apple';
  String _electronicsStorage = '256GB';
  String _electronicsWarranty = 'Brand Warranty Active';

  @override
  void initState() {
    super.initState();
    _selectedSubcategory = widget.categoryItem.subcategories.isNotEmpty
        ? widget.categoryItem.subcategories.first
        : widget.categoryItem.title;
    _photos = [widget.categoryItem.imagePath];

    // Helpful default hints based on category
    if (widget.categoryItem.title == 'Vehicles') {
      _titleController.text = '2023 Hyundai Creta SX(O) 1.5 Turbo';
      _priceController.text = '1480000';
      _descriptionController.text =
          'Single owner, serviced exclusively at authorized center. Mint condition with panoramic sunroof, ventilated seats, and zero accidental record.';
    } else if (widget.categoryItem.title == 'Property') {
      _titleController.text = 'Luxury 3BHK Apartment in Kakkanad';
      _priceController.text = '7800000';
      _descriptionController.text =
          'Spacious modern apartment with clubhouse amenities, covered parking, and 24/7 security. Prime location near Infopark.';
    } else if (widget.categoryItem.title == 'Electronics') {
      _titleController.text = 'Apple MacBook Pro M3 14-inch 512GB';
      _priceController.text = '145000';
      _descriptionController.text =
          'Space Gray, cycle count under 25, complete with original box, 70W power brick and MagSafe 3 cable.';
    } else if (widget.categoryItem.title == 'Mobiles & Tablets') {
      _titleController.text = 'iPhone 15 Pro Max 256GB Natural Titanium';
      _priceController.text = '98000';
      _descriptionController.text =
          'Battery health 99%, flawless condition with tempered glass applied since day one. Includes original box and bill.';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _vehicleKmController.dispose();
    _propertyAreaController.dispose();
    super.dispose();
  }

  void _addPhotoDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Photos',
                style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.camera_alt_rounded, color: Color(0xFF2563EB)),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    if (_photos.length < 6) {
                      _photos.add('assets/images/h.png');
                    }
                  });
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF5F3FF),
                  child: Icon(Icons.photo_library_rounded, color: Color(0xFF7C3AED)),
                ),
                title: const Text('Choose from Gallery Presets'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    if (_photos.length < 6) {
                      _photos.add(widget.categoryItem.imagePath);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPreviewPressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double priceVal = double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0.0;
    final formattedPrice = '₹ ${_formatIndianCurrency(priceVal.toInt())}';

    final Map<String, dynamic> specs = {};
    if (widget.categoryItem.title == 'Vehicles') {
      specs['Brand'] = _vehicleBrand;
      specs['Year'] = _vehicleYear;
      specs['Fuel'] = _vehicleFuel;
      specs['Transmission'] = _vehicleTransmission;
      specs['KM Driven'] = '${_vehicleKmController.text} km';
      specs['Owners'] = _vehicleOwners;
    } else if (widget.categoryItem.title == 'Property') {
      specs['Type'] = _propertyType;
      specs['Bedrooms'] = _propertyBedrooms;
      specs['Carpet Area'] = '${_propertyAreaController.text} sq.ft';
      specs['Furnishing'] = _propertyFurnished;
    } else if (widget.categoryItem.title == 'Electronics' || widget.categoryItem.title == 'Mobiles & Tablets') {
      specs['Brand'] = _electronicsBrand;
      specs['Storage'] = _electronicsStorage;
      specs['Warranty'] = _electronicsWarranty;
    }
    specs['Condition'] = _selectedCondition;
    specs['Subcategory'] = _selectedSubcategory;

    final newListing = MarketListing(
      id: 'lst_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      price: priceVal,
      formattedPrice: formattedPrice,
      location: _locationController.text.trim().isEmpty ? 'Kochi' : _locationController.text.trim(),
      category: widget.categoryItem.title,
      subcategory: _selectedSubcategory,
      imagePath: _photos.isNotEmpty ? _photos.first : widget.categoryItem.imagePath,
      description: _descriptionController.text.trim(),
      sellerId: 'user_alex',
      sellerName: 'Alex Morgan',
      status: 'Active',
      createdAt: DateTime.now(),
      specifications: specs,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListingPreviewScreen(
          listing: newListing,
          categoryItem: widget.categoryItem,
          additionalPhotos: _photos,
        ),
      ),
    ).then((result) {
      if (result == true && mounted) {
        Navigator.pop(context, true);
      }
    });
  }

  String _formatIndianCurrency(int amount) {
    final str = amount.toString();
    if (str.length <= 3) return str;
    final lastThree = str.substring(str.length - 3);
    final otherNumbers = str.substring(0, str.length - 3);
    final formattedOther = otherNumbers.replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+$)'),
      (Match m) => '${m[1]},',
    );
    return '$formattedOther,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          key: const Key('create_listing_back_button'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Add ${widget.categoryItem.title} Listing',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Step 2 of 4 • Item Details',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Draft saved successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Save Draft',
              style: GoogleFonts.inter(
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Photos Section
              _buildSectionHeader('Item Photos', 'Upload up to 6 high resolution photos'),
              const SizedBox(height: 12),
              _buildPhotosRow(),
              const SizedBox(height: 20),

              // 2. Basic Info Section
              _buildSectionHeader('Basic Details', 'Title, category tags, and item condition'),
              const SizedBox(height: 12),
              _buildCardContainer(
                children: [
                  // Title Input
                  Text(
                    'Listing Title *',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: const Key('listing_title_input'),
                    controller: _titleController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a title for your listing' : null,
                    decoration: InputDecoration(
                      hintText: 'e.g. 2023 Hyundai Creta SX(O) 1.5 Turbo',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subcategory
                  Text(
                    'Subcategory *',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.categoryItem.subcategories.map((sub) {
                      final isSelected = _selectedSubcategory == sub;
                      return ChoiceChip(
                        label: Text(sub),
                        selected: isSelected,
                        selectedColor: const Color(0xFFEEF2FF),
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF475569),
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedSubcategory = sub);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Condition
                  Text(
                    'Condition *',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Brand New', 'Like New', 'Gently Used', 'Fair'].map((cond) {
                      final isSelected = _selectedCondition == cond;
                      return ChoiceChip(
                        label: Text(cond),
                        selected: isSelected,
                        selectedColor: const Color(0xFFECFDF5),
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF059669) : const Color(0xFF475569),
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCondition = cond);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Category Specific Dynamic Specs
              if (widget.categoryItem.title == 'Vehicles') ...[
                _buildSectionHeader('Vehicle Specifications', 'Detailed vehicle parameters'),
                const SizedBox(height: 12),
                _buildVehicleSpecsCard(),
                const SizedBox(height: 20),
              ] else if (widget.categoryItem.title == 'Property') ...[
                _buildSectionHeader('Property Specifications', 'Detailed property configurations'),
                const SizedBox(height: 12),
                _buildPropertySpecsCard(),
                const SizedBox(height: 20),
              ] else if (widget.categoryItem.title == 'Electronics' || widget.categoryItem.title == 'Mobiles & Tablets') ...[
                _buildSectionHeader('Device Specifications', 'Hardware and warranty specifics'),
                const SizedBox(height: 12),
                _buildElectronicsSpecsCard(),
                const SizedBox(height: 20),
              ],

              // 4. Pricing & Location
              _buildSectionHeader('Pricing & Location', 'Set your desired asking price and neighborhood'),
              const SizedBox(height: 12),
              _buildCardContainer(
                children: [
                  Text(
                    'Price (₹) *',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: const Key('listing_price_input'),
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter asking price' : null,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Text(
                          '₹',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF6366F1)),
                        ),
                      ),
                      hintText: '14,80,000',
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Price is Negotiable',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                    ),
                    subtitle: Text(
                      'Allow buyers to send reasonable counter-offers',
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                    ),
                    value: _isNegotiable,
                    activeTrackColor: const Color(0xFF6366F1),
                    onChanged: (val) => setState(() => _isNegotiable = val),
                  ),
                  const Divider(height: 20, color: Color(0xFFE2E8F0)),
                  Text(
                    'Location / City *',
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: const Key('listing_location_input'),
                    controller: _locationController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter item location' : null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 18),
                      hintText: 'e.g. Kakkanad, Kochi',
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. Description
              _buildSectionHeader('Description', 'Provide honest details about condition & history'),
              const SizedBox(height: 12),
              _buildCardContainer(
                children: [
                  TextFormField(
                    key: const Key('listing_description_input'),
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Mention reason for selling, maintenance records, included accessories, or warranty info...',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8), height: 1.4),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 6. Privacy & Safety
              _buildCardContainer(
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Safe Seller Protection',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
                    ),
                    subtitle: Text(
                      'Mask phone number and allow verified buyer messages only',
                      style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF64748B)),
                    ),
                    value: _maskPhone,
                    activeTrackColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _maskPhone = val),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('preview_listing_button'),
                    onPressed: _onPreviewPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Preview Listing',
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _photos.length + 1,
            separatorBuilder: (ctx, i) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == _photos.length) {
                return InkWell(
                  onTap: _addPhotoDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC7D2FE), style: BorderStyle.solid),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo_outlined, color: Color(0xFF6366F1), size: 24),
                        const SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final photoPath = _photos[index];
              final isCover = index == 0;

              return Stack(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      photoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  if (isCover)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Cover',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                  if (_photos.length > 1)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _photos.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '💡 Pro tip: Clear photos taken in daylight sell 2.5x quicker.',
          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildVehicleSpecsCard() {
    return _buildCardContainer(
      children: [
        // Brand & Year
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Brand / Make', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleBrand,
                    items: ['Hyundai', 'Tata', 'Toyota', 'Honda', 'Maruti', 'Mahindra', 'BMW']
                        .map((b) => DropdownMenuItem(value: b, child: Text(b, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleBrand = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model Year', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleYear,
                    items: ['2024', '2023', '2022', '2021', '2020', '2019', '2018']
                        .map((y) => DropdownMenuItem(value: y, child: Text(y, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleYear = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Fuel & Transmission
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fuel Type', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleFuel,
                    items: ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG']
                        .map((f) => DropdownMenuItem(value: f, child: Text(f, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleFuel = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transmission', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleTransmission,
                    items: ['Automatic', 'Manual']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleTransmission = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // KM Driven & Owners
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KM Driven', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _vehicleKmController,
                    decoration: _inputDecoration(suffixText: 'km'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ownership', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _vehicleOwners,
                    items: ['1st Owner', '2nd Owner', '3rd Owner', '4+ Owners']
                        .map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleOwners = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertySpecsCard() {
    return _buildCardContainer(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Listing Type', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _propertyType,
                    items: ['For Sale', 'For Rent / Lease']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _propertyType = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bedrooms', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _propertyBedrooms,
                    items: ['1 BHK', '2 BHK', '3 BHK', '4+ BHK']
                        .map((b) => DropdownMenuItem(value: b, child: Text(b, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _propertyBedrooms = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Carpet Area', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _propertyAreaController,
                    decoration: _inputDecoration(suffixText: 'sq.ft'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Furnishing', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _propertyFurnished,
                    items: ['Fully Furnished', 'Semi-Furnished', 'Unfurnished']
                        .map((f) => DropdownMenuItem(value: f, child: Text(f, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _propertyFurnished = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElectronicsSpecsCard() {
    return _buildCardContainer(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Brand', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _electronicsBrand,
                    items: ['Apple', 'Samsung', 'Sony', 'Dell', 'HP', 'Lenovo']
                        .map((b) => DropdownMenuItem(value: b, child: Text(b, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _electronicsBrand = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Storage / Capacity', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _electronicsStorage,
                    items: ['128GB', '256GB', '512GB', '1TB']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.inter(fontSize: 13))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _electronicsStorage = val);
                    },
                    decoration: _inputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Warranty Status', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _electronicsWarranty,
              items: ['Brand Warranty Active', 'Seller Warranty (3 Months)', 'No Warranty / Expired']
                  .map((w) => DropdownMenuItem(value: w, child: Text(w, style: GoogleFonts.inter(fontSize: 13))))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _electronicsWarranty = val);
              },
              decoration: _inputDecoration(),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? suffixText}) {
    return InputDecoration(
      suffixText: suffixText,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
