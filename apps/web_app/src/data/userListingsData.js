/**
 * User Published Listings Store & Persistence Layer
 * Integrates with localStorage ('galletrix_published_listings')
 * and synchronizes with the Dart Frog REST API.
 */

const STORAGE_KEY = 'galletrix_published_listings';

// Fast in-memory runtime cache for API-fetched items & active session listings
const runtimeItemCache = new Map();

export function getCategoryDefaultImage(category) {
  switch (category) {
    case 'Vehicles':
      return '/images/h1.png';
    case 'Property':
      return '/images/h2.png';
    case 'Mobiles':
      return '/images/h3.png';
    case 'Electronics':
      return '/images/h4.png';
    case 'Furniture':
      return '/images/h5.png';
    case 'Jobs':
      return '/images/h6.png';
    case 'Services':
      return '/images/h7.png';
    case 'Groceries':
      return '/images/h8.png';
    default:
      return '/images/h3.png';
  }
}

/**
 * Cache an item into memory for instant synchronous lookup
 */
export function cacheRuntimeListing(listing) {
  if (!listing || !listing.id) return;
  runtimeItemCache.set(listing.id, listing);
}

/**
 * Get an item from memory cache
 */
export function getRuntimeListing(id) {
  if (!id) return null;
  return runtimeItemCache.get(id) || null;
}

/**
 * Category-aware similar listing generator
 */
export function getSimilarListingForCategory(category) {
  switch (category) {
    case 'Mobiles':
      return {
        id: 'list_iphone_15_pro',
        image: '/images/h6.png',
        price: '₹ 1,34,900',
        negotiable: true,
        title: 'iPhone 15 Pro Max 256GB Titanium',
        location: 'Indiranagar, Bengaluru',
        sellerType: 'Premium Tech Hub',
        time: '3h ago',
      };
    case 'Electronics':
      return {
        id: 'list_macbook_m3',
        image: '/images/h5.png',
        price: '₹ 1,69,900',
        negotiable: true,
        title: 'Apple MacBook Pro 14" M3 Pro',
        location: 'Kakkanad, Kochi',
        sellerType: 'Premium Tech Hub',
        time: '1d ago',
      };
    case 'Property':
      return {
        id: 'list_apt_kakkanad_3bhk',
        image: '/images/h2.png',
        price: '₹ 1.25 Crore',
        negotiable: true,
        title: '3BHK Luxury Apartment in Kakkanad',
        location: 'Infopark, Kochi',
        sellerType: 'Verified Broker',
        time: '1d ago',
      };
    case 'Jobs':
      return {
        id: 'list_job_senior_fe',
        image: '/images/h3.png',
        price: '₹ 18 - 24 LPA',
        negotiable: false,
        title: 'Senior Frontend Engineer (React/Flutter)',
        location: 'Bengaluru / Hybrid',
        sellerType: 'Employer',
        time: 'Just now',
      };
    case 'Groceries':
      return {
        id: 'list_veg_combo',
        image: '/images/h4.png',
        price: '₹ 499',
        negotiable: false,
        title: 'Organic Farm Fresh Veggies Combo Pack',
        location: 'Kakkanad',
        sellerType: 'Direct Farmer',
        time: '2h ago',
      };
    case 'Services':
      return {
        id: 'list_clean_service',
        image: '/images/h7.png',
        price: '₹ 2,500',
        negotiable: false,
        title: 'Home Deep Cleaning & Sanitization Service',
        location: 'Kakkanad',
        sellerType: 'Certified Pro',
        time: '4h ago',
      };
    case 'Furniture':
      return {
        id: 'list_teak_sofa',
        image: '/images/h8.png',
        price: '₹ 38,500',
        negotiable: true,
        title: 'Handcrafted Teak Wood Sofa Set',
        location: 'Thiruvananthapuram',
        sellerType: 'Artisan',
        time: '1d ago',
      };
    case 'Vehicles':
    default:
      return {
        id: 'list_creta_2022',
        image: '/images/h1.png',
        price: '₹ 7,25,000',
        negotiable: true,
        title: '2022 Hyundai Creta SX',
        location: 'Thiruvananthapuram',
        sellerType: 'Individual',
        time: '2d ago',
      };
  }
}

/**
 * Retrieve all user-published listings from localStorage
 */
export function getPublishedListings() {
  if (typeof window === 'undefined' || typeof localStorage === 'undefined') return [];
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.error('Failed to read published listings from localStorage:', err);
    return [];
  }
}

/**
 * Save or prepend a new published listing
 */
export function savePublishedListing(listing) {
  if (!listing) return listing;
  try {
    const current = getPublishedListings();
    
    // Ensure properly formatted fields
    const formatted = {
      ...listing,
      id: listing.id || `list_${Date.now()}`,
      created_at: listing.created_at || new Date().toISOString(),
      posted_time: listing.posted_time || 'Just now',
      is_just_posted: true,
      image_path: listing.image_path || getCategoryDefaultImage(listing.category),
      formatted_price: listing.formatted_price || (listing.price ? `₹ ${Number(listing.price).toLocaleString('en-IN')}` : 'Price on request'),
      status: 'active'
    };

    // Cache in runtime memory
    cacheRuntimeListing(formatted);

    // Filter out if duplicate ID exists, then unshift to the very beginning
    const filtered = current.filter(item => item.id !== formatted.id);
    const updated = [formatted, ...filtered];

    localStorage.setItem(STORAGE_KEY, JSON.stringify(updated));

    // Dispatch custom event for real-time reactive updates across components
    if (typeof window !== 'undefined') {
      window.dispatchEvent(new CustomEvent('galletrix_listings_updated', { detail: formatted }));
    }

    return formatted;
  } catch (err) {
    console.error('Failed to save published listing:', err);
    cacheRuntimeListing(listing);
    return listing;
  }
}

/**
 * Find a published listing by ID
 */
export function getPublishedListingById(id) {
  if (!id) return null;
  // 1. Check in-memory runtime cache
  const cached = getRuntimeListing(id);
  if (cached) return cached;

  // 2. Check localStorage
  const list = getPublishedListings();
  const found = list.find(item => item.id === id);
  if (found) {
    cacheRuntimeListing(found);
    return found;
  }
  return null;
}

/**
 * Convert user-published listing or API item into full MARKETPLACE_ITEMS shape
 * for seamless rendering in ListingDetailPage
 */
export function formatPublishedListingForDetailPage(item) {
  if (!item) return null;

  const defaultImg = getCategoryDefaultImage(item.category);
  const isVehicle = item.category === 'Vehicles';

  // Construct specifications list
  const specs = [];
  if (item.specifications && typeof item.specifications === 'object') {
    Object.entries(item.specifications).forEach(([k, v]) => {
      if (v) {
        const label = k.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
        specs.push({ label, value: String(v) });
      }
    });
  }

  if (specs.length === 0) {
    if (isVehicle) {
      specs.push({ label: 'Category', value: 'Vehicle' });
      specs.push({ label: 'Fuel', value: item.fuel_type || 'Petrol' });
      specs.push({ label: 'Transmission', value: item.transmission || 'Automatic' });
      specs.push({ label: 'Location', value: item.location || 'Kerala' });
      specs.push({ label: 'Condition', value: 'Verified Pre-Owned' });
    } else if (item.category === 'Mobiles') {
      specs.push({ label: 'Brand', value: item.specifications?.brand || 'Smartphone' });
      specs.push({ label: 'Model', value: item.specifications?.model || item.title });
      specs.push({ label: 'Storage', value: item.specifications?.storage || '128 GB' });
      specs.push({ label: 'Condition', value: item.specifications?.condition || 'Verified' });
      specs.push({ label: 'Location', value: item.location || 'Kerala' });
    } else {
      specs.push({ label: 'Category', value: item.category || 'General' });
      specs.push({ label: 'Location', value: item.location || 'Kerala' });
      specs.push({ label: 'Condition', value: 'Verified' });
      specs.push({ label: 'Status', value: 'Available' });
    }
  }

  const initial = (item.seller_name || 'You')[0].toUpperCase();

  // Resolve cover photo: if blob url or missing, defaultImg is safe fallback
  const primaryImg = (Array.isArray(item.images) && item.images[0]) || item.image_path || defaultImg;
  const thumbnails = (Array.isArray(item.images) && item.images.length > 0)
    ? item.images.map((img, idx) => ({ id: idx, label: idx === 0 ? 'Cover' : `Photo ${idx + 1}`, thumb: img, main: img }))
    : [{ id: 0, label: 'Main', thumb: primaryImg, main: primaryImg }];

  return {
    id: item.id,
    category: item.category || 'Mobiles',
    subcategory: item.subcategory || (isVehicle ? 'Car' : item.category),
    title: item.title,
    price: item.price || 0,
    formatted_price: item.formatted_price || `₹ ${Number(item.price || 0).toLocaleString('en-IN')}`,
    negotiable: item.negotiable !== false,
    location: item.location || 'Kerala',
    posted_time: item.posted_time || 'Just now',
    views: '1 view • Just Posted',
    is_just_posted: true,
    showcase_image: primaryImg,
    default_image: defaultImg,
    is_car_layout: isVehicle,
    thumbnails: thumbnails,
    description: item.description || `${item.title} available for sale in ${item.location}. Verified listing.`,
    specs: specs,
    seller: {
      initial: initial,
      name: item.seller_name || 'You (Verified Seller)',
      role: 'Individual Seller (Just Posted)',
      stats: [
        { number: '1', label: 'Active Ad' },
        { number: '100%', label: 'Response' },
        { number: 'New', label: 'Seller' },
      ],
      phone: item.seller_phone || '+91 98470 54321',
    },
    similar: getSimilarListingForCategory(item.category)
  };
}
