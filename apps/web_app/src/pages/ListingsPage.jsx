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
  ChevronDown,
  Home,
  Briefcase,
  Laptop,
  Smartphone,
  Sofa,
  Sparkles
} from 'lucide-react';
import { fetchListings, resolveImageUrl } from '../api/client';
import { MARKETPLACE_ITEMS } from '../data/marketplaceData';
import './ListingsPage.css';

export default function ListingsPage({ favorites = [], onToggleFavorite }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [listings, setListings] = useState([]);
  const [loading, setLoading] = useState(true);

  // Filter States from URL
  const currentCategory = searchParams.get('category') || 'All';
  const currentQuery = searchParams.get('query') || '';
  const isFavoritesOnly = searchParams.get('favorites') === 'true';

  // Sub-filter states
  const [fuelFilter, setFuelFilter] = useState('All');
  const [transmissionFilter, setTransmissionFilter] = useState('All');
  const [bedroomFilter, setBedroomFilter] = useState('All');
  const [workModeFilter, setWorkModeFilter] = useState('All');
  const [brandFilter, setBrandFilter] = useState('All');
  const [sortBy, setSortBy] = useState('newest');
  const [searchQuery, setSearchQuery] = useState(currentQuery);
  const [maxPrice, setMaxPrice] = useState(50000000);

  // Synchronize internal search query when URL changes
  useEffect(() => {
    setSearchQuery(currentQuery);
  }, [currentQuery]);

  useEffect(() => {
    async function loadData() {
      setLoading(true);
      const apiData = await fetchListings({
        category: currentCategory === 'All' ? undefined : currentCategory,
        query: currentQuery,
        sort: sortBy,
      });

      // Transform curated items from MARKETPLACE_ITEMS
      const curatedList = Object.values(MARKETPLACE_ITEMS).map((item) => ({
        id: item.id,
        title: item.title,
        price: item.price,
        formatted_price: item.formatted_price,
        location: item.location,
        category: item.category,
        subcategory: item.subcategory,
        image_path: item.showcase_image || item.thumbnails?.[0]?.main,
        specifications: {
          ...item.specs?.reduce((acc, s) => ({ ...acc, [s.label.toLowerCase().replace(/ /g, '_')]: s.value }), {}),
          ...item.specifications,
        },
        is_featured: true,
      }));

      // Combine API results with curated catalog
      let combined = [...curatedList];
      apiData.forEach((apiItem) => {
        if (!combined.some((c) => c.id === apiItem.id)) {
          combined.push(apiItem);
        }
      });

      // Filter by category if specified
      if (currentCategory !== 'All') {
        combined = combined.filter(
          (item) => item.category?.toLowerCase() === currentCategory.toLowerCase()
        );
      }

      setListings(combined);
      setLoading(false);
    }

    loadData();
  }, [currentCategory, currentQuery, sortBy]);

  // Client-side filtering
  const filteredListings = listings.filter((item) => {
    if (isFavoritesOnly && !favorites.includes(item.id)) return false;

    // Vehicle filters
    if (item.category === 'Vehicles') {
      if (fuelFilter !== 'All') {
        const fuel = item.specifications?.fuel || item.specifications?.fuel_type || '';
        if (!fuel.toLowerCase().includes(fuelFilter.toLowerCase())) return false;
      }
      if (transmissionFilter !== 'All') {
        const trans = item.specifications?.transmission || '';
        if (!trans.toLowerCase().includes(transmissionFilter.toLowerCase())) return false;
      }
    }

    // Property filters
    if (item.category === 'Property' && bedroomFilter !== 'All') {
      const beds = item.specifications?.bedrooms || '';
      if (!beds.toLowerCase().includes(bedroomFilter.toLowerCase())) return false;
    }

    // Jobs filters
    if (item.category === 'Jobs' && workModeFilter !== 'All') {
      const mode = item.specifications?.work_mode || '';
      if (!mode.toLowerCase().includes(workModeFilter.toLowerCase())) return false;
    }

    // Tech & Mobiles filters
    if ((item.category === 'Electronics' || item.category === 'Mobiles') && brandFilter !== 'All') {
      const brand = item.specifications?.brand || '';
      if (!brand.toLowerCase().includes(brandFilter.toLowerCase())) return false;
    }

    // Keyword search
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const inTitle = item.title?.toLowerCase().includes(q);
      const inLoc = item.location?.toLowerCase().includes(q);
      const inCat = item.category?.toLowerCase().includes(q);
      if (!inTitle && !inLoc && !inCat) return false;
    }

    if (item.price && item.price > maxPrice) return false;

    return true;
  });

  const categoriesList = [
    'All',
    'Vehicles',
    'Property',
    'Jobs',
    'Electronics',
    'Mobiles',
    'Furniture',
    'Groceries',
    'Services',
  ];

  return (
    <div className="listings-page">
      {/* Top Breadcrumb & Catalog Header */}
      <section className="catalog-header-bar">
        <div className="container">
          <div className="breadcrumbs">
            <Link to="/">Home</Link>
            <span>/</span>
            <span className="current-crumb">
              {currentCategory === 'All' ? 'All Marketplace Listings' : currentCategory}
            </span>
          </div>

          <div className="catalog-title-row">
            <div>
              <h1 className="catalog-title">
                {currentCategory === 'All' ? 'Discover What’s Trending' : `${currentCategory} Listings`}
              </h1>
              <p className="catalog-subtitle">
                {currentCategory === 'Property'
                  ? 'Explore apartments, flats, and villas from verified builders and landlords.'
                  : currentCategory === 'Jobs'
                  ? 'Discover career openings in tech, design, marketing, and operations.'
                  : currentCategory === 'Vehicles'
                  ? 'Explore certified multi-brand cars, SUVs, and bikes with verified history.'
                  : currentCategory === 'Electronics'
                  ? 'High-performance laptops, screens, audio gear, and gadgets.'
                  : currentCategory === 'Mobiles'
                  ? 'Verified flagship smartphones, tablets, and mobile accessories.'
                  : currentCategory === 'Furniture'
                  ? 'Solid wood dining sets, living room sofas, and home decor.'
                  : 'Verified items, products, and services across South India.'}
              </p>
            </div>

            {/* Quick Category Badges */}
            <div className="catalog-category-badges">
              {categoriesList.map((cat) => (
                <button
                  key={cat}
                  type="button"
                  onClick={() => {
                    const newParams = new URLSearchParams(searchParams);
                    if (cat === 'All') {
                      newParams.delete('category');
                    } else {
                      newParams.set('category', cat);
                    }
                    setSearchParams(newParams);
                  }}
                  className={`cat-pill-btn ${currentCategory === cat ? 'active' : ''}`}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Main Content Layout */}
      <div className="container catalog-body-layout">
        {/* Left Filter Sidebar */}
        <aside className="catalog-sidebar">
          <div className="sidebar-card">
            <div className="sidebar-header">
              <div className="filter-title">
                <SlidersHorizontal size={17} />
                <span>Filters</span>
              </div>
              <button 
                type="button" 
                onClick={() => {
                  setFuelFilter('All');
                  setTransmissionFilter('All');
                  setBedroomFilter('All');
                  setWorkModeFilter('All');
                  setBrandFilter('All');
                  setMaxPrice(50000000);
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
                  placeholder={`Search ${currentCategory === 'All' ? 'items' : currentCategory}...`}
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
            </div>

            {/* Vehicles Specific Filters */}
            {(currentCategory === 'Vehicles' || currentCategory === 'All') && (
              <>
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
              </>
            )}

            {/* Property Specific Filters */}
            {currentCategory === 'Property' && (
              <div className="filter-group">
                <label className="filter-label">Bedrooms</label>
                <div className="filter-pills-row">
                  {['All', '2 BHK', '3 BHK'].map((bed) => (
                    <button
                      key={bed}
                      type="button"
                      className={`filter-pill ${bedroomFilter === bed ? 'active' : ''}`}
                      onClick={() => setBedroomFilter(bed)}
                    >
                      {bed}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Jobs Specific Filters */}
            {currentCategory === 'Jobs' && (
              <div className="filter-group">
                <label className="filter-label">Work Mode</label>
                <div className="filter-pills-row">
                  {['All', 'Hybrid', 'Remote'].map((mode) => (
                    <button
                      key={mode}
                      type="button"
                      className={`filter-pill ${workModeFilter === mode ? 'active' : ''}`}
                      onClick={() => setWorkModeFilter(mode)}
                    >
                      {mode}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Electronics & Mobiles Brand Filters */}
            {(currentCategory === 'Electronics' || currentCategory === 'Mobiles') && (
              <div className="filter-group">
                <label className="filter-label">Brand</label>
                <div className="filter-pills-row">
                  {['All', 'Apple', 'Samsung'].map((brand) => (
                    <button
                      key={brand}
                      type="button"
                      className={`filter-pill ${brandFilter === brand ? 'active' : ''}`}
                      onClick={() => setBrandFilter(brand)}
                    >
                      {brand}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Price Range */}
            <div className="filter-group">
              <div className="price-slider-label">
                <label className="filter-label">Max Budget</label>
                <span className="price-val">
                  {maxPrice >= 10000000
                    ? `₹ ${(maxPrice / 10000000).toFixed(1)} Cr`
                    : maxPrice >= 100000
                    ? `₹ ${(maxPrice / 100000).toFixed(1)} Lakh`
                    : `₹ ${maxPrice.toLocaleString('en-IN')}`}
                </span>
              </div>
              <input 
                type="range" 
                min="500" 
                max="50000000" 
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
                <p>Every listing is checked for genuine seller credentials and identity verification.</p>
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
              <p>Try resetting filters or exploring other categories</p>
              <button 
                onClick={() => {
                  setFuelFilter('All');
                  setTransmissionFilter('All');
                  setBedroomFilter('All');
                  setWorkModeFilter('All');
                  setBrandFilter('All');
                  setSearchQuery('');
                  setMaxPrice(50000000);
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
                        {item.category && (
                          <span className="item-owner-tag">
                            {item.category}
                          </span>
                        )}
                      </div>

                      <Link to={`/listings/${item.id}`} className="item-title-link">
                        <h3 className="item-title">{item.title}</h3>
                      </Link>

                      {/* Category-Specific Specs Pills */}
                      <div className="item-specs-pills">
                        {/* Vehicle Specs */}
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

                        {/* Property Specs */}
                        {specs.bedrooms && (
                          <span className="spec-chip">
                            {specs.bedrooms}
                          </span>
                        )}
                        {specs.super_area && (
                          <span className="spec-chip">
                            {specs.super_area}
                          </span>
                        )}

                        {/* Job Specs */}
                        {specs.work_mode && (
                          <span className="spec-chip">
                            {specs.work_mode}
                          </span>
                        )}
                        {specs.experience && (
                          <span className="spec-chip">
                            {specs.experience}
                          </span>
                        )}

                        {/* Tech / Mobile Specs */}
                        {specs.storage && (
                          <span className="spec-chip">
                            {specs.storage}
                          </span>
                        )}
                        {specs.processor && (
                          <span className="spec-chip">
                            {specs.processor}
                          </span>
                        )}

                        {/* Furniture Specs */}
                        {specs.material && (
                          <span className="spec-chip">
                            {specs.material}
                          </span>
                        )}
                        {specs.seating && (
                          <span className="spec-chip">
                            {specs.seating}
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
