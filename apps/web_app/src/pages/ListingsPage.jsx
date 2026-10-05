import React, { useEffect, useState } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { 
  Filter, 
  Search, 
  MapPin, 
  SlidersHorizontal, 
  Heart, 
  Gauge, 
  Fuel, 
  ShieldCheck, 
  Check, 
  X,
  ChevronDown
} from 'lucide-react';
import { fetchListings, resolveImageUrl } from '../api/client';
import './ListingsPage.css';

export default function ListingsPage({ favorites = [], onToggleFavorite }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [listings, setListings] = useState([]);
  const [loading, setLoading] = useState(true);

  // Filter States
  const currentCategory = searchParams.get('category') || 'Vehicles';
  const currentQuery = searchParams.get('query') || '';
  const isFavoritesOnly = searchParams.get('favorites') === 'true';

  const [fuelFilter, setFuelFilter] = useState('All');
  const [transmissionFilter, setTransmissionFilter] = useState('All');
  const [sortBy, setSortBy] = useState('newest');
  const [searchQuery, setSearchQuery] = useState(currentQuery);
  const [maxPrice, setMaxPrice] = useState(15000000);

  useEffect(() => {
    async function loadData() {
      setLoading(true);
      const data = await fetchListings({
        category: currentCategory,
        query: currentQuery,
        sort: sortBy,
      });

      // Expand with vehicle variations so the 3-column / 4-column catalog matches Figma
      let items = [...data];
      if (currentCategory === 'Vehicles' || currentCategory === 'All') {
        const vehicleCopies = [
          {
            id: 'list_creta_2022_white',
            title: '2022 Hyundai Creta SX Automatic',
            price: 720000,
            formatted_price: '₹ 7,20,000',
            location: 'Thiruvananthapuram',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Petrol',
              transmission: 'Automatic',
              total_capacity: '6 Seats',
              owner: '1st Owner • Verified',
              highest_speed: '200 KM/H',
            },
            is_featured: true,
          },
          {
            id: 'list_creta_diesel_2021',
            title: '2021 Hyundai Creta E 1.5 Diesel',
            price: 685000,
            formatted_price: '₹ 6,85,000',
            location: 'Bengaluru',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Diesel',
              transmission: 'Manual',
              total_capacity: '5 Seats',
              owner: '1st Owner • Verified',
              highest_speed: '185 KM/H',
            },
            is_featured: false,
          },
          {
            id: 'list_venue_turbo_2023',
            title: '2023 Hyundai Venue SX Turbo DCT',
            price: 840000,
            formatted_price: '₹ 8,40,000',
            location: 'Kochi',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Petrol',
              transmission: 'Automatic',
              total_capacity: '5 Seats',
              owner: 'Single Owner • Dealer Warranty',
              highest_speed: '190 KM/H',
            },
            is_featured: true,
          },
          {
            id: 'list_creta_knight_2023',
            title: '2023 Hyundai Creta Knight Edition',
            price: 990000,
            formatted_price: '₹ 9,90,000',
            location: 'Thiruvananthapuram',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Petrol',
              transmission: 'Automatic',
              total_capacity: '6 Seats',
              owner: '1st Owner • Verified',
              highest_speed: '205 KM/H',
            },
            is_featured: false,
          },
          {
            id: 'list_tucson_gls_2022',
            title: '2022 Hyundai Tucson 4WD Signature',
            price: 1450000,
            formatted_price: '₹ 14,50,000',
            location: 'Bengaluru',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Diesel',
              transmission: 'Automatic',
              total_capacity: '5 Seats',
              owner: '1st Owner • Certified',
              highest_speed: '220 KM/H',
            },
            is_featured: true,
          },
          {
            id: 'list_creta_sxo_2024',
            title: '2024 New Hyundai Creta SX(O) ADAS',
            price: 1320000,
            formatted_price: '₹ 13,20,000',
            location: 'Kochi',
            category: 'Vehicles',
            subcategory: 'Car',
            image_path: 'assets/images/h1.png',
            specifications: {
              fuel_type: 'Petrol',
              transmission: 'Automatic',
              total_capacity: '6 Seats',
              owner: 'Brand New Demo • 0 KM',
              highest_speed: '210 KM/H',
            },
            is_featured: true,
          }
        ];
        items = [...vehicleCopies, ...items.filter(x => !vehicleCopies.some(vc => vc.id === x.id))];
      }

      setListings(items);
      setLoading(false);
    }
    loadData();
  }, [currentCategory, currentQuery, sortBy]);

  // Apply in-memory client-side filters
  const filteredListings = listings.filter((item) => {
    if (isFavoritesOnly && !favorites.includes(item.id)) return false;

    if (fuelFilter !== 'All') {
      const fuel = item.specifications?.fuel_type || '';
      if (!fuel.toLowerCase().includes(fuelFilter.toLowerCase())) return false;
    }

    if (transmissionFilter !== 'All') {
      const trans = item.specifications?.transmission || '';
      if (!trans.toLowerCase().includes(transmissionFilter.toLowerCase())) return false;
    }

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const inTitle = item.title?.toLowerCase().includes(q);
      const inLoc = item.location?.toLowerCase().includes(q);
      if (!inTitle && !inLoc) return false;
    }

    if (item.price && item.price > maxPrice) return false;

    return true;
  });

  return (
    <div className="listings-page">
      {/* Top Breadcrumb & Search Bar */}
      <section className="catalog-header-bar">
        <div className="container">
          <div className="breadcrumbs">
            <Link to="/">Home</Link>
            <span>/</span>
            <span className="current-crumb">{currentCategory}</span>
            {isFavoritesOnly && <span>/ Saved Favorites</span>}
          </div>

          <div className="catalog-top-row">
            <div>
              <h1 className="catalog-title">
                {isFavoritesOnly ? 'Your Saved Favorites' : `${currentCategory} for Sale`}
              </h1>
              <p className="catalog-subtitle">
                Showing <strong>{filteredListings.length}</strong> verified listings matching your preferences
              </p>
            </div>

            {/* Sort Dropdown */}
            <div className="catalog-sort-box">
              <span className="sort-label">Sort by:</span>
              <select 
                value={sortBy} 
                onChange={(e) => setSortBy(e.target.value)}
                className="sort-select"
              >
                <option value="newest">Newest First</option>
                <option value="price_low">Price: Low to High</option>
                <option value="price_high">Price: High to Low</option>
              </select>
            </div>
          </div>
        </div>
      </section>

      {/* Main Content Area */}
      <div className="container catalog-layout">
        {/* Left Filter Sidebar */}
        <aside className="filters-sidebar">
          <div className="filter-card">
            <div className="filter-card-header">
              <div className="filter-head-title">
                <SlidersHorizontal size={18} />
                <span>Filters</span>
              </div>
              <button 
                type="button" 
                onClick={() => {
                  setFuelFilter('All');
                  setTransmissionFilter('All');
                  setMaxPrice(15000000);
                  setSearchQuery('');
                }}
                className="filter-reset-btn"
              >
                Reset
              </button>
            </div>

            {/* Keyword Search */}
            <div className="filter-group">
              <label className="filter-label">Search Keywords</label>
              <div className="filter-search-box">
                <Search size={16} />
                <input 
                  type="text" 
                  placeholder="Model, brand, or feature..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
            </div>

            {/* Fuel Type */}
            <div className="filter-group">
              <label className="filter-label">Fuel Type</label>
              <div className="filter-pills-row">
                {['All', 'Petrol', 'Diesel', 'Electric'].map((fuel) => (
                  <button
                    key={fuel}
                    type="button"
                    className={`filter-pill ${fuelFilter === fuel ? 'active' : ''}`}
                    onClick={() => setFuelFilter(fuel)}
                  >
                    {fuel}
                  </button>
                ))}
              </div>
            </div>

            {/* Transmission */}
            <div className="filter-group">
              <label className="filter-label">Transmission</label>
              <div className="filter-pills-row">
                {['All', 'Automatic', 'Manual'].map((t) => (
                  <button
                    key={t}
                    type="button"
                    className={`filter-pill ${transmissionFilter === t ? 'active' : ''}`}
                    onClick={() => setTransmissionFilter(t)}
                  >
                    {t}
                  </button>
                ))}
              </div>
            </div>

            {/* Price Range */}
            <div className="filter-group">
              <div className="price-slider-label">
                <label className="filter-label">Max Price</label>
                <span className="price-val">₹ {(maxPrice / 100000).toFixed(1)} Lakh</span>
              </div>
              <input 
                type="range" 
                min="200000" 
                max="15000000" 
                step="50000"
                value={maxPrice}
                onChange={(e) => setMaxPrice(Number(e.target.value))}
                className="price-range-slider"
              />
            </div>

            {/* Trust Assurance Banner */}
            <div className="sidebar-trust-box">
              <ShieldCheck size={20} className="trust-icon-green" />
              <div>
                <strong>Galletrix Verified Assurance</strong>
                <p>Every vehicle has valid RC, service records, and zero accident structural integrity.</p>
              </div>
            </div>
          </div>
        </aside>

        {/* Listings Grid */}
        <main className="catalog-grid-main">
          {loading ? (
            <div className="loading-state">
              <div className="spinner"></div>
              <span>Loading verified marketplace listings...</span>
            </div>
          ) : filteredListings.length === 0 ? (
            <div className="empty-state">
              <Search size={40} className="empty-icon" />
              <h3>No listings match your filter criteria</h3>
              <p>Try resetting filters or expanding your search radius</p>
              <button 
                onClick={() => {
                  setFuelFilter('All');
                  setTransmissionFilter('All');
                  setSearchQuery('');
                  setMaxPrice(15000000);
                }}
                className="btn-primary"
              >
                Clear All Filters
              </button>
            </div>
          ) : (
            <div className="listings-cards-grid">
              {filteredListings.map((item) => {
                const isFav = favorites.includes(item.id);
                const imageUrl = resolveImageUrl(item.image_path || item.image_url);
                const specs = item.specifications || {};

                return (
                  <div key={item.id} className="catalog-item-card card-hover">
                    {/* Image Area */}
                    <div className="item-img-container">
                      <Link to={`/listings/${item.id}`}>
                        <img 
                          src={imageUrl} 
                          alt={item.title} 
                          className="item-img"
                          loading="lazy"
                        />
                      </Link>

                      {/* Top Badges */}
                      <div className="item-top-badges">
                        {item.is_featured && <span className="badge-featured">Featured</span>}
                        <span className="badge-verified">
                          <ShieldCheck size={12} />
                          Verified
                        </span>
                      </div>

                      {/* Favorite Button */}
                      <button 
                        type="button"
                        className={`fav-button ${isFav ? 'favorited' : ''}`}
                        onClick={(e) => {
                          e.preventDefault();
                          onToggleFavorite(item.id);
                        }}
                      >
                        <Heart size={18} fill={isFav ? "#F95738" : "none"} color={isFav ? "#F95738" : "#ffffff"} />
                      </button>
                    </div>

                    {/* Content */}
                    <div className="item-content">
                      <div className="item-price-row">
                        <span className="item-price">
                          {item.formatted_price || `₹ ${item.price?.toLocaleString('en-IN')}`}
                        </span>
                        {specs.owner && (
                          <span className="item-owner-tag">
                            {specs.owner.split('•')[0].trim()}
                          </span>
                        )}
                      </div>

                      <Link to={`/listings/${item.id}`} className="item-title-link">
                        <h3 className="item-title">{item.title}</h3>
                      </Link>

                      {/* Specs */}
                      <div className="item-specs-pills">
                        {specs.fuel_type && (
                          <span className="spec-chip">
                            <Fuel size={12} />
                            {specs.fuel_type}
                          </span>
                        )}
                        {specs.transmission && (
                          <span className="spec-chip">
                            <Gauge size={12} />
                            {specs.transmission}
                          </span>
                        )}
                        {specs.total_capacity && (
                          <span className="spec-chip">
                            {specs.total_capacity}
                          </span>
                        )}
                      </div>

                      <div className="item-card-bottom">
                        <div className="item-location">
                          <MapPin size={13} className="pin-icon" />
                          <span>{item.location || 'Thiruvananthapuram'}</span>
                        </div>
                        <span className="item-time">Active Today</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </main>
      </div>
    </div>
  );
}
