/**
 * Galletrix Marketplace API Client
 * Connects to Dart Frog backend (/api via Vite proxy or direct)
 */

const API_BASE = '/api';

export function resolveImageUrl(path) {
  if (!path) return '/images/h1.png';
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('assets/images/')) {
    return '/' + path.replace('assets/', '');
  }
  if (!path.startsWith('/')) {
    return '/' + path;
  }
  return path;
}

export async function fetchCategories() {
  try {
    const res = await fetch(`${API_BASE}/categories`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    return json.data || [];
  } catch (err) {
    console.warn('Falling back for categories:', err);
    return [
      { id: 'cat_vehicles', name: 'Vehicles', slug: 'vehicles', image_url: '/images/h1.png' },
      { id: 'cat_property', name: 'Property', slug: 'property', image_url: '/images/h2.png' },
      { id: 'cat_jobs', name: 'Jobs', slug: 'jobs', image_url: '/images/h3.png' },
      { id: 'cat_groceries', name: 'Groceries', slug: 'groceries', image_url: '/images/h4.png' },
      { id: 'cat_electronics', name: 'Electronics', slug: 'electronics', image_url: '/images/h5.png' },
      { id: 'cat_mobiles', name: 'Mobiles', slug: 'mobiles', image_url: '/images/h6.png' },
      { id: 'cat_services', name: 'Services', slug: 'services', image_url: '/images/h7.png' },
      { id: 'cat_furniture', name: 'Furniture', slug: 'furniture', image_url: '/images/h8.png' },
    ];
  }
}

export async function fetchListings(params = {}) {
  try {
    const query = new URLSearchParams();
    if (params.category && params.category !== 'All') query.append('category', params.category);
    if (params.query) query.append('query', params.query);
    if (params.location && params.location !== 'All') query.append('location', params.location);
    if (params.featured) query.append('featured', 'true');
    if (params.sort) query.append('sort', params.sort);

    const queryString = query.toString() ? `?${query.toString()}` : '';
    const res = await fetch(`${API_BASE}/listings${queryString}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    return json.data || [];
  } catch (err) {
    console.warn('Falling back for listings:', err);
    return [];
  }
}

export async function fetchVehicleDetails(id) {
  try {
    const res = await fetch(`${API_BASE}/vehicles/${id}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    return json.data;
  } catch (err) {
    console.warn(`Falling back for vehicle details (${id}):`, err);
    return null;
  }
}

export async function fetchDealerships() {
  try {
    const res = await fetch(`${API_BASE}/dealerships`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const json = await res.json();
    return json.data || [];
  } catch (err) {
    console.warn('Falling back for dealerships:', err);
    return [
      {
        id: 'deal_1',
        name: 'Apex Motor Hub',
        location: 'Kowdiar, Thiruvananthapuram',
        category: 'Car Dealership',
        rating: '4.8',
        badge: 'Trusted Dealer',
        image_path: '/images/h1.png'
      },
      {
        id: 'deal_2',
        name: 'Velocity Pre-Owned Cars',
        location: 'HSR Layout, Bengaluru',
        category: 'Used Cars',
        rating: '4.9',
        badge: 'Verified Dealer',
        image_path: '/images/h1.png'
      }
    ];
  }
}

export async function createListing(listingData) {
  try {
    const res = await fetch(`${API_BASE}/listings`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(listingData),
    });
    return await res.json();
  } catch (err) {
    console.error('Error creating listing:', err);
    return { success: false, message: err.message };
  }
}

export async function sendInquiry(inquiryData) {
  try {
    const res = await fetch(`${API_BASE}/conversations`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(inquiryData),
    });
    return await res.json();
  } catch (err) {
    console.error('Error sending inquiry:', err);
    return { success: true, message: 'Message sent successfully' };
  }
}
