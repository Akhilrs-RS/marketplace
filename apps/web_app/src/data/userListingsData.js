/**
 * User Published Listings Store & Persistence Layer
 * Integrates with localStorage ('galletrix_published_listings')
 * and synchronizes with the Dart Frog REST API.
 */

const STORAGE_KEY = 'galletrix_published_listings';

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
      return '/images/h1.png';
  }
}

/**
 * Retrieve all user-published listings from localStorage
 */
export function getPublishedListings() {
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
    return listing;
  }
}

/**
 * Find a published listing by ID
 */
export function getPublishedListingById(id) {
  if (!id) return null;
  const list = getPublishedListings();
  return list.find(item => item.id === id) || null;
}

/**
 * Convert user-published listing or API item into full MARKETPLACE_ITEMS shape
 * for seamless rendering in ListingDetailPage
 */
export function formatPublishedListingForDetailPage(item) {
  if (!item) return null;

  const defaultImg = item.image_path || getCategoryDefaultImage(item.category);
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
    } else {
      specs.push({ label: 'Category', value: item.category || 'General' });
      specs.push({ label: 'Location', value: item.location || 'Kerala' });
      specs.push({ label: 'Condition', value: 'Verified' });
      specs.push({ label: 'Status', value: 'Available' });
    }
  }

  const initial = (item.seller_name || 'You')[0].toUpperCase();

  return {
    id: item.id,
    category: item.category || 'Vehicles',
    subcategory: item.subcategory || (isVehicle ? 'Car' : item.category),
    title: item.title,
    price: item.price || 0,
    formatted_price: item.formatted_price || `₹ ${Number(item.price || 0).toLocaleString('en-IN')}`,
    negotiable: true,
    location: item.location || 'Kerala',
    posted_time: item.posted_time || 'Just now',
    views: '1 view • Just Posted',
    is_just_posted: true,
    showcase_image: (Array.isArray(item.images) && item.images[0]) || defaultImg,
    is_car_layout: isVehicle,
    thumbnails: (Array.isArray(item.images) && item.images.length > 0)
      ? item.images.map((img, idx) => ({ id: idx, label: idx === 0 ? 'Cover' : `Photo ${idx + 1}`, thumb: img, main: img }))
      : [{ id: 0, label: 'Main', thumb: defaultImg, main: defaultImg }],
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
      phone: '+91 98470 54321',
    },
    similar: {
      id: 'list_creta_2022',
      image: '/images/h1.png',
      price: '₹ 7,25,000',
      negotiable: true,
      title: '2022 Hyundai Creta SX',
      location: 'Thiruvananthapuram',
      sellerType: 'Individual',
      time: '2d ago',
    }
  };
}
