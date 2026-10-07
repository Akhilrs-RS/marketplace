/**
 * Multi-Category Taxonomy, Schemas and Presets for Galletrix Marketplace
 * Supports all 9 classifications with tailored subcategories, attribute schemas,
 * and high-resolution photo presets.
 */

export const AD_CATEGORIES = [
  {
    id: 'Vehicles',
    name: 'Vehicles',
    icon: 'Car',
    description: 'Cars, motorcycles, scooters, commercial trucks & parts',
    subcategories: [
      'Cars',
      'Motorcycles',
      'Scooters',
      'Commercial Vehicles',
      'Auto Accessories & Parts'
    ],
    defaultImage: '/images/h1.png',
    presetImages: [
      { id: 'v1', label: 'SUV Defender Style', path: '/images/h1.png' },
      { id: 'v2', label: 'Hyundai Creta', path: '/images/creta_main.png' },
      { id: 'v3', label: 'Hyundai Tucson', path: '/images/tucson_main.png' },
      { id: 'v4', label: 'Maruti Brezza', path: '/images/car_brezza.png' },
      { id: 'v5', label: 'Maruti Swift', path: '/images/car_swift.png' },
      { id: 'v6', label: 'Royal Enfield Hunter', path: '/images/bike_hunter.png' },
      { id: 'v7', label: 'Honda CB350', path: '/images/bike_cb350.png' },
      { id: 'v8', label: 'Yamaha R15', path: '/images/bike_r15.png' },
      { id: 'v9', label: 'Honda Activa', path: '/images/scooter_activa.png' },
      { id: 'v10', label: 'Bolero Camper', path: '/images/truck_bolero.png' },
      { id: 'v11', label: 'Tata Ace', path: '/images/truck_tata_ace.png' }
    ],
    fields: [
      {
        id: 'brand',
        label: 'Brand / Make',
        type: 'select',
        required: true,
        options: ['Hyundai', 'Maruti Suzuki', 'Tata Motors', 'Toyota', 'Honda', 'Mahindra', 'Kia', 'BMW', 'Mercedes-Benz', 'Royal Enfield', 'Yamaha', 'Other Brand']
      },
      {
        id: 'model',
        label: 'Model & Variant',
        type: 'text',
        placeholder: 'e.g. Creta SX(O) / Swift ZXi+ / Classic 350',
        required: true
      },
      {
        id: 'year',
        label: 'Registration Year',
        type: 'select',
        required: true,
        options: ['2026', '2025', '2024', '2023', '2022', '2021', '2020', '2019', '2018', '2017', '2016', '2015', 'Earlier']
      },
      {
        id: 'fuel_type',
        label: 'Fuel Type',
        type: 'select',
        required: true,
        options: ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG']
      },
      {
        id: 'transmission',
        label: 'Transmission',
        type: 'select',
        required: true,
        options: ['Automatic', 'Manual', 'AMT / DCT']
      },
      {
        id: 'km_driven',
        label: 'Kilometers Driven (KM)',
        type: 'text',
        placeholder: 'e.g. 18,500 km',
        required: true
      },
      {
        id: 'ownership',
        label: 'Number of Owners',
        type: 'select',
        options: ['1st Owner', '2nd Owner', '3rd Owner', '4th+ Owner']
      },
      {
        id: 'insurance',
        label: 'Insurance Validity',
        type: 'select',
        options: ['Valid Comprehensive', 'Third-Party Only', 'Expired / None']
      }
    ]
  },
  {
    id: 'Property',
    name: 'Property',
    icon: 'Building2',
    description: 'Apartments, houses, villas, plots, commercial & rentals',
    subcategories: [
      'Apartments for Sale',
      'Houses & Villas for Sale',
      'Plots & Land for Sale',
      'Commercial Property for Sale',
      'Apartments for Rent',
      'Houses for Rent',
      'PG & Flatmates',
      'Commercial Property for Rent'
    ],
    defaultImage: '/images/h2.png',
    presetImages: [
      { id: 'p1', label: 'Modern Luxury Apartment', path: '/images/h2.png' }
    ],
    fields: [
      {
        id: 'bedrooms',
        label: 'Configuration (BHK)',
        type: 'select',
        required: true,
        options: ['1 RK', '1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK / Penthouse']
      },
      {
        id: 'property_type',
        label: 'Property Type',
        type: 'select',
        required: true,
        options: ['Multistorey Apartment', 'Independent House / Villa', 'Residential Plot', 'Commercial Office', 'Studio Apartment']
      },
      {
        id: 'super_area',
        label: 'Super Built-up Area',
        type: 'text',
        placeholder: 'e.g. 1,650 sq.ft (or 8.5 cents)',
        required: true
      },
      {
        id: 'furnishing',
        label: 'Furnishing Status',
        type: 'select',
        options: ['Fully Furnished', 'Semi-Furnished', 'Unfurnished']
      },
      {
        id: 'bathrooms',
        label: 'Bathrooms',
        type: 'select',
        options: ['1 Bathroom', '2 Bathrooms', '3 Bathrooms', '4+ Bathrooms']
      },
      {
        id: 'car_parking',
        label: 'Parking Space',
        type: 'select',
        options: ['1 Covered Parking', '2 Covered Parkings', 'Open Parking', 'No Parking']
      },
      {
        id: 'facing',
        label: 'Facing Direction',
        type: 'select',
        options: ['East Facing', 'North Facing', 'West Facing', 'South Facing', 'North-East Facing']
      },
      {
        id: 'maintenance',
        label: 'Monthly Maintenance (₹)',
        type: 'text',
        placeholder: 'e.g. ₹ 2,500 / month'
      }
    ]
  },
  {
    id: 'Mobiles',
    name: 'Mobiles & Tablets',
    icon: 'Smartphone',
    description: 'Smartphones, Apple iPads, tablets, smartwatches & tech accessories',
    subcategories: [
      'Mobile Phones',
      'Tablets & iPads',
      'Smart Watches',
      'Accessories & Audio'
    ],
    defaultImage: '/images/h3.png',
    presetImages: [
      { id: 'm1', label: 'Apple iPhone Titanium', path: '/images/h3.png' }
    ],
    fields: [
      {
        id: 'brand',
        label: 'Brand',
        type: 'select',
        required: true,
        options: ['Apple', 'Samsung', 'Google Pixel', 'OnePlus', 'Xiaomi', 'Vivo', 'Oppo', 'Realme', 'Nothing', 'Other Brand']
      },
      {
        id: 'model',
        label: 'Model Name',
        type: 'text',
        placeholder: 'e.g. iPhone 15 Pro Max / Galaxy S24 Ultra',
        required: true
      },
      {
        id: 'storage',
        label: 'Internal Storage',
        type: 'select',
        required: true,
        options: ['64 GB', '128 GB', '256 GB', '512 GB', '1 TB']
      },
      {
        id: 'ram',
        label: 'RAM Size',
        type: 'select',
        options: ['4 GB', '6 GB', '8 GB', '12 GB', '16 GB']
      },
      {
        id: 'condition',
        label: 'Physical Condition',
        type: 'select',
        required: true,
        options: ['Brand New • Sealed Box', 'Like New • Flawless', 'Gently Used • Excellent', 'Fair • Normal Wear']
      },
      {
        id: 'battery_health',
        label: 'Battery Health %',
        type: 'text',
        placeholder: 'e.g. 96% or 100%'
      },
      {
        id: 'inclusions',
        label: 'Included Accessories',
        type: 'select',
        options: ['Original Box & Bill & Cable', 'Device & Original Charger', 'Device Only']
      }
    ]
  },
  {
    id: 'Electronics',
    name: 'Electronics & Appliances',
    icon: 'Laptop',
    description: 'Laptops, MacBooks, 4K TVs, home audio, cameras & appliances',
    subcategories: [
      'Laptops & MacBooks',
      'Desktop Computers & Monitors',
      'TVs, Audio & Home Theatre',
      'Cameras & Photography',
      'Home & Kitchen Appliances',
      'Gaming Consoles & Accessories'
    ],
    defaultImage: '/images/h4.png',
    presetImages: [
      { id: 'e1', label: 'MacBook Pro Setup', path: '/images/h4.png' }
    ],
    fields: [
      {
        id: 'device_type',
        label: 'Device Category',
        type: 'select',
        required: true,
        options: ['MacBook / Laptop', 'Desktop / Workstation', 'OLED / 4K Smart TV', 'DSLR / Mirrorless Camera', 'Home Audio & Soundbar', 'Gaming Console']
      },
      {
        id: 'brand',
        label: 'Brand',
        type: 'select',
        required: true,
        options: ['Apple', 'Dell', 'HP', 'Lenovo', 'ASUS', 'Sony', 'Samsung', 'LG', 'Canon', 'Bose', 'Other Brand']
      },
      {
        id: 'processor',
        label: 'Processor / Specifications',
        type: 'text',
        placeholder: 'e.g. Apple M3 Chip / Intel Core i7 13th Gen',
        required: true
      },
      {
        id: 'storage_ram',
        label: 'RAM & Storage',
        type: 'text',
        placeholder: 'e.g. 16GB Unified RAM, 512GB SSD'
      },
      {
        id: 'warranty',
        label: 'Warranty Status',
        type: 'select',
        options: ['Under Active AppleCare / Brand Warranty', '6 Months Seller Warranty', 'Expired / Testing Warranty Only']
      },
      {
        id: 'condition',
        label: 'Condition',
        type: 'select',
        options: ['Brand New Sealed', 'Like New • Minimal Use', 'Used • Good Working Order']
      }
    ]
  },
  {
    id: 'Furniture',
    name: 'Furniture & Living',
    icon: 'Sofa',
    description: 'Sofas, solid wood dining sets, designer beds, study desks & decor',
    subcategories: [
      'Sofas & Recliners',
      'Beds & Mattresses',
      'Dining Tables & Chairs',
      'Office Chairs & Study Tables',
      'Wardrobes & Storage Cabinets',
      'Home Decor & Lights'
    ],
    defaultImage: '/images/h5.png',
    presetImages: [
      { id: 'f1', label: 'Modern Living Sofa & Decor', path: '/images/h5.png' }
    ],
    fields: [
      {
        id: 'furniture_type',
        label: 'Furniture Type',
        type: 'select',
        required: true,
        options: ['Living Room Sofa / Recliner', 'Solid Teak Wood Dining Set', 'King/Queen Bed with Storage', 'Ergonomic Work Desk / Chair', '3-Door / 4-Door Wardrobe']
      },
      {
        id: 'material',
        label: 'Primary Material',
        type: 'select',
        required: true,
        options: ['Solid Teak Wood', 'Rosewood / Sheesham', 'Engineered Wood / MDF', 'High-Density Foam & Fabric', 'Metal & Glass', 'Genuine Leather']
      },
      {
        id: 'seating',
        label: 'Seating / Dimensions',
        type: 'text',
        placeholder: 'e.g. 5-Seater (3+1+1) or 6-Seater Table',
        required: true
      },
      {
        id: 'condition',
        label: 'Condition',
        type: 'select',
        options: ['Brand New Handcrafted', 'Gently Used • Well Maintained', 'Restored Vintage']
      }
    ]
  },
  {
    id: 'Groceries',
    name: 'Groceries & Produce',
    icon: 'ShoppingBasket',
    description: 'Farm-fresh organic vegetables, seasonal fruits, spices & farm products',
    subcategories: [
      'Farm Fresh Produce',
      'Organic Vegetables',
      'Exotic & Seasonal Fruits',
      'Spices & Traditional Staples',
      'Dairy & Natural Farm Essentials'
    ],
    defaultImage: '/images/h8.png',
    presetImages: [
      { id: 'g1', label: 'Farm Fresh Organic Basket', path: '/images/h8.png' }
    ],
    fields: [
      {
        id: 'produce_type',
        label: 'Produce / Grocery Type',
        type: 'select',
        required: true,
        options: ['Daily Harvest Vegetable Combo', 'Certified Organic Produce', 'Natural Orchard Fruits', 'Kerala Spices & Organic Pepper', 'Farm Fresh Dairy']
      },
      {
        id: 'pricing_unit',
        label: 'Pricing Unit / Pack Size',
        type: 'select',
        required: true,
        options: ['Per Kg (₹ / kg)', 'Per Family Box (5-7 kg combo)', 'Per Crate (15 kg)', 'Per Bundle / Pack', 'Per Litre']
      },
      {
        id: 'source',
        label: 'Farming Practice / Source',
        type: 'select',
        options: ['100% Pesticide-Free Natural Farming', 'Certified Organic Farm', 'Hydroponic Greenhouse', 'Direct From Local Farmers']
      },
      {
        id: 'delivery_mode',
        label: 'Delivery & Freshness',
        type: 'select',
        options: ['Same-Day Morning Harvest Delivery', 'Next-Day Delivery', 'Farm Pickup Available']
      }
    ]
  },
  {
    id: 'Services',
    name: 'Services & Experts',
    icon: 'Wrench',
    description: 'Home deep cleaning, electricians, plumbers, repair & verified pros',
    subcategories: [
      'Home Deep Cleaning & Sanitization',
      'Electricians & Plumbers',
      'AC & Appliance Repair',
      'Packers & Movers',
      'Carpentry & Painting',
      'Home Drivers & Rentals',
      'Education & Professional Services'
    ],
    defaultImage: '/images/h7.png',
    presetImages: [
      { id: 's1', label: 'Verified Service Specialist', path: '/images/h7.png' }
    ],
    fields: [
      {
        id: 'service_domain',
        label: 'Service Specialization',
        type: 'select',
        required: true,
        options: ['Full Villa / Flat Deep Cleaning', 'Bathroom & Kitchen Sanitization', 'Certified Electrician & Wiring', 'Plumbing & Water Motor Repair', 'Inverter & AC Servicing', 'Packers & Movers Logistics']
      },
      {
        id: 'pricing_model',
        label: 'Pricing Structure',
        type: 'select',
        required: true,
        options: ['Starting Fixed Package Rate', 'Hourly Rate', 'Free Inspection & Custom Quote']
      },
      {
        id: 'availability',
        label: 'Service Availability',
        type: 'select',
        options: ['Same Day / Immediate Slots Available', 'Scheduled Appointments', '24x7 Emergency Service']
      },
      {
        id: 'experience',
        label: 'Professional Experience',
        type: 'text',
        placeholder: 'e.g. 8+ years verified background checked team'
      }
    ]
  },
  {
    id: 'Jobs',
    name: 'Jobs & Careers',
    icon: 'Briefcase',
    description: 'Full-time, part-time, remote, engineering, sales & skilled employment',
    subcategories: [
      'Software & IT Engineering',
      'Sales & Business Development',
      'Logistics & Delivery Executives',
      'Design & Digital Marketing',
      'Hospitality & Customer Support',
      'Teaching & Tutoring'
    ],
    defaultImage: '/images/h6.png',
    presetImages: [
      { id: 'j1', label: 'Corporate & Engineering Team', path: '/images/h6.png' }
    ],
    fields: [
      {
        id: 'job_role',
        label: 'Job Designation / Title',
        type: 'text',
        placeholder: 'e.g. Senior Frontend Engineer / Store Manager',
        required: true
      },
      {
        id: 'employment_type',
        label: 'Employment Type',
        type: 'select',
        required: true,
        options: ['Full-Time', 'Part-Time', 'Contract / Consultant', 'Internship', 'Freelance']
      },
      {
        id: 'work_mode',
        label: 'Work Mode',
        type: 'select',
        required: true,
        options: ['In-Office / On-Site', 'Hybrid', '100% Remote']
      },
      {
        id: 'experience',
        label: 'Experience Required',
        type: 'select',
        required: true,
        options: ['Fresher (0 - 1 years)', '1 - 3 years', '3 - 5 years', '5 - 8 years', '8+ years Senior']
      },
      {
        id: 'salary_period',
        label: 'Salary Offering',
        type: 'select',
        options: ['Per Annum (LPA)', 'Per Month (Fixed + Incentives)', 'Hourly / Project Based']
      },
      {
        id: 'company_name',
        label: 'Hiring Company / Organization',
        type: 'text',
        placeholder: 'e.g. Apex Tech Solutions Ltd.'
      }
    ]
  },
  {
    id: 'General',
    name: 'General & Others',
    icon: 'Sparkles',
    description: 'Sports equipment, books, hobbies, fashion, musical instruments & more',
    subcategories: [
      'Sports & Fitness Equipment',
      'Fashion, Watches & Bags',
      'Musical Instruments',
      'Books, Hobbies & Collectibles',
      'Baby Products & Toys',
      'Commercial Tools & Machinery'
    ],
    defaultImage: '/images/h4.png',
    presetImages: [
      { id: 'gen1', label: 'Classified Merchandise', path: '/images/h4.png' }
    ],
    fields: [
      {
        id: 'item_type',
        label: 'Item Type / Subcategory',
        type: 'text',
        placeholder: 'e.g. Acoustic Guitar / Treadmill / Mountain Bike',
        required: true
      },
      {
        id: 'condition',
        label: 'Item Condition',
        type: 'select',
        required: true,
        options: ['Brand New Sealed', 'Gently Used • Mint', 'Well Used • Working']
      },
      {
        id: 'brand',
        label: 'Brand / Manufacturer',
        type: 'text',
        placeholder: 'e.g. Yamaha, Decathlon, Nike, etc.'
      }
    ]
  }
];

export const POPULAR_LOCATIONS = [
  'Kochi',
  'Thiruvananthapuram',
  'Bengaluru',
  'Kollam',
  'Kozhikode',
  'Kowdiar',
  'Kakkanad',
  'Thrissur',
  'Alappuzha',
  'Kannur',
  'Indiranagar, Bengaluru',
  'HSR Layout, Bengaluru'
];

export function getCategoryById(categoryId) {
  return AD_CATEGORIES.find(c => c.id.toLowerCase() === (categoryId || '').toLowerCase()) || AD_CATEGORIES[0];
}
