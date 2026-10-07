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
import { getPublishedListings, cacheRuntimeListing, getCategoryDefaultImage } from '../data/userListingsData';
import HeroSearch from '../components/home/HeroSearch';
import './ListingsPage.css';

function matchLocation(itemLocation, filterQuery) {
  if (!filterQuery || filterQuery === 'All') return true;
  if (!itemLocation) return false;

  const loc = itemLocation.toLowerCase();
  const q = filterQuery.toLowerCase().trim();
  if (!q) return true;

  // Direct substring match
  if (loc.includes(q)) return true;

  // City clusters / aliases
  if (q === 'thiruvananthapuram' || q === 'trivandrum' || q === 'tvm') {
    return (
      loc.includes('thiruvananthapuram') || 
      loc.includes('trivandrum') || 
      loc.includes('kazhakkoottam') || 
      loc.includes('kowdiar')
    );
  }

  if (q === 'kochi' || q === 'cochin' || q === 'ernakulam') {
    return (
      loc.includes('kochi') || 
      loc.includes('cochin') || 
      loc.includes('kakkanad') || 
      loc.includes('ernakulam') || 
      loc.includes('aluva')
    );
  }

  if (q === 'bengaluru' || q === 'bangalore') {
    return (
      loc.includes('bengaluru') || 
      loc.includes('bangalore') || 
      loc.includes('hsr')
    );
  }

  if (q === 'kollam' || q === 'quilon') {
    return loc.includes('kollam') || loc.includes('quilon');
  }

  if (q === 'remote') {
    return loc.includes('remote') || loc.includes('hybrid');
  }

  return false;
}

export default function ListingsPage({ favorites = [], onToggleFavorite }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const [listings, setListings] = useState([]);
  const [loading, setLoading] = useState(true);

  // Filter States from URL
  const currentCategory = searchParams.get('category') || 'All';
  const currentQuery = searchParams.get('query') || '';
  const currentLocation = searchParams.get('location') || '';
  const isFavoritesOnly = searchParams.get('favorites') === 'true';

  // Sub-filter states
  const [fuelFilter, setFuelFilter] = useState('All');
  const [transmissionFilter, setTransmissionFilter] = useState('All');
  const [bedroomFilter, setBedroomFilter] = useState('All');
  const [workModeFilter, setWorkModeFilter] = useState('All');
  const [brandFilter, setBrandFilter] = useState('All');
  const [produceFilter, setProduceFilter] = useState('All');
  const [serviceFilter, setServiceFilter] = useState('All');
  const [sortBy, setSortBy] = useState('newest');
  const [searchQuery, setSearchQuery] = useState(currentQuery);
  const [locationFilter, setLocationFilter] = useState(currentLocation || 'All');
  const [maxPrice, setMaxPrice] = useState(50000000);

  // Synchronize internal query and location when URL changes
  useEffect(() => {
    setSearchQuery(currentQuery);
  }, [currentQuery]);

  useEffect(() => {
    setLocationFilter(currentLocation || 'All');
  }, [currentLocation]);

  const handleSelectLocation = (loc) => {
    const val = loc || 'All';
    setLocationFilter(val);
    const newParams = new URLSearchParams(searchParams);
    if (!val || val === 'All') {
      newParams.delete('location');
    } else {
      newParams.set('location', val);
    }
    setSearchParams(newParams);
  };

  const handleResetFilters = () => {
    setFuelFilter('All');
    setTransmissionFilter('All');
    setBedroomFilter('All');
    setWorkModeFilter('All');
    setBrandFilter('All');
    setProduceFilter('All');
    setServiceFilter('All');
    setSearchQuery('');
    setMaxPrice(50000000);
    handleSelectLocation('All');
  };

  useEffect(() => {
    async function loadData() {
      setLoading(true);
      const apiData = await fetchListings({
        category: currentCategory === 'All' ? undefined : currentCategory,
        query: currentQuery,
        location: currentLocation && currentLocation !== 'All' ? currentLocation : undefined,
        sort: sortBy,
      });

      // Retrieve locally published listings
      const userPublished = getPublishedListings();
      const userList = userPublished.map((item) => ({
        id: item.id,
        title: item.title,
        price: item.price,
        formatted_price: item.formatted_price,
        location: item.location,
        category: item.category,
        subcategory: item.subcategory,
        image_path: resolveImageUrl(item.image_path),
        specifications: {
          fuel_type: item.specifications?.fuel_type || item.fuel_type,
          transmission: item.specifications?.transmission || item.transmission,
          ...item.specifications,
        },
        is_featured: true,
        is_just_posted: true,
        created_at: item.created_at,
      }));

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

      // Priority ordering: user-published listings FIRST (at top of catalog),
      // then API items, then curated catalog
      let combined = [...userList];

      apiData.forEach((apiItem) => {
        cacheRuntimeListing(apiItem);
        if (!combined.some((c) => c.id === apiItem.id)) {
          combined.push({
            ...apiItem,
            is_just_posted: apiItem.id.startsWith('list_test') || apiItem.id.startsWith('list_1'),
          });
        }
      });

      curatedList.forEach((cItem) => {
        if (!combined.some((c) => c.id === cItem.id)) {
          combined.push(cItem);
        }
      });

      // Filter by category if specified (with alias support for Vegetables <-> Groceries)
      if (currentCategory !== 'All') {
        const catLower = currentCategory.toLowerCase();
        combined = combined.filter((item) => {
          const itemCat = item.category?.toLowerCase() || '';
          if (catLower === 'vegetables' || catLower === 'groceries') {
            return itemCat === 'groceries' || itemCat === 'vegetables';
          }
          return itemCat === catLower;
        });
      }

      setListings(combined);
      setLoading(false);
    }

    loadData();

    // Listen for real-time published listing additions
    const handleUpdate = () => loadData();
    window.addEventListener('galletrix_listings_updated', handleUpdate);
    return () => window.removeEventListener('galletrix_listings_updated', handleUpdate);
  }, [currentCategory, currentQuery, currentLocation, sortBy]);

  // Client-side filtering
  const filteredListings = listings.filter((item) => {
    if (isFavoritesOnly && !favorites.includes(item.id)) return false;

    // Location filter
    if (!matchLocation(item.location, locationFilter)) return false;

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

    // Groceries & Produce filters
    if (item.category === 'Groceries' && produceFilter !== 'All') {
      const sub = item.subcategory || '';
      if (!sub.toLowerCase().includes(produceFilter.toLowerCase())) return false;
    }

    // Services filters
    if (item.category === 'Services' && serviceFilter !== 'All') {
      const sub = item.subcategory || '';
      if (!sub.toLowerCase().includes(serviceFilter.toLowerCase())) return false;
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
      {/* 1. Hero Search Header Banner matching Figma Desktop - 73 */}
      <HeroSearch />

      {/* 2. Top Breadcrumb & Catalog Header */}
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
                  : currentCategory === 'Groceries' || currentCategory === 'Vegetables'
                  ? 'Farm-fresh vegetables, crisp greens, seasonal fruits, and certified organic produce.'
                  : currentCategory === 'Services'
                  ? 'Verified home maintenance, deep cleaning, appliance repair, and professional services.'
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
                onClick={handleResetFilters}
                className="filter-reset-btn"
              >
                Reset
              </button>
            </div>

            {/* Location Filter Section */}
            <div className="filter-group">
              <div className="filter-group-header">
                <label className="filter-label">Location</label>
                {locationFilter !== 'All' && locationFilter !== '' && (
                  <button 
                    type="button" 
                    className="filter-clear-sub-btn"
                    onClick={() => handleSelectLocation('All')}
                  >
                    Clear
                  </button>
                )}
              </div>

              <div className="filter-search-box filter-loc-box">
                <MapPin size={16} className="filter-loc-icon" />
                <input 
                  type="text" 
                  placeholder="City or area (e.g. Kochi, Kowdiar)..."
                  value={locationFilter === 'All' ? '' : locationFilter}
                  onChange={(e) => handleSelectLocation(e.target.value)}
                />
                {locationFilter && locationFilter !== 'All' && (
                  <button 
                    type="button" 
                    className="filter-loc-clear-icon-btn" 
                    onClick={() => handleSelectLocation('All')}
                    title="Clear location"
                  >
                    <X size={14} />
                  </button>
                )}
              </div>

              <div className="filter-pills-row">
                {[
                  { label: 'All', value: 'All' },
                  { label: 'Thiruvananthapuram', value: 'Thiruvananthapuram' },
                  { label: 'Kochi', value: 'Kochi' },
                  { label: 'Kollam', value: 'Kollam' },
                  { label: 'Bengaluru', value: 'Bengaluru' },
                  { label: 'Remote', value: 'Remote' },
                ].map((loc) => (
                  <button
                    key={loc.value}
                    type="button"
                    className={`filter-pill ${
                      (locationFilter === loc.value || (loc.value === 'All' && (!locationFilter || locationFilter === 'All')))
                        ? 'active' 
                        : ''
                    }`}
                    onClick={() => handleSelectLocation(loc.value)}
                  >
                    {loc.label}
                  </button>
                ))}
              </div>
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

            {/* Groceries & Vegetables Specific Filters */}
            {(currentCategory === 'Groceries' || currentCategory === 'Vegetables') && (
              <div className="filter-group">
                <label className="filter-label">Produce Type</label>
                <div className="filter-pills-row">
                  {['All', 'Vegetables', 'Leafy Greens', 'Fruits'].map((ptype) => (
                    <button
                      key={ptype}
                      type="button"
                      className={`filter-pill ${produceFilter === ptype ? 'active' : ''}`}
                      onClick={() => setProduceFilter(ptype)}
                    >
                      {ptype}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {/* Services Specific Filters */}
            {currentCategory === 'Services' && (
              <div className="filter-group">
                <label className="filter-label">Service Type</label>
                <div className="filter-pills-row">
                  {['All', 'Cleaning', 'Appliance Repair', 'Plumbing'].map((stype) => (
                    <button
                      key={stype}
                      type="button"
                      className={`filter-pill ${serviceFilter === stype ? 'active' : ''}`}
                      onClick={() => setServiceFilter(stype)}
                    >
                      {stype}
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
          {/* Catalog Results Header Bar with Active Filter Pills */}
          <div className="catalog-results-header">
            <div className="results-count-title">
              <span>Showing <strong>{filteredListings.length}</strong> {filteredListings.length === 1 ? 'listing' : 'listings'}</span>
              {locationFilter && locationFilter !== 'All' && (
                <span className="results-location-tag"> in {locationFilter}</span>
              )}
            </div>

            {/* Active Filter Chips */}
            <div className="active-filters-chips-wrap">
              {locationFilter && locationFilter !== 'All' && (
                <span className="active-filter-badge">
                  <MapPin size={12} />
                  <span>{locationFilter}</span>
                  <button 
                    type="button" 
                    onClick={() => handleSelectLocation('All')} 
                    title="Remove location filter"
                  >
                    <X size={12} />
                  </button>
                </span>
              )}

              {searchQuery && (
                <span className="active-filter-badge">
                  <Search size={12} />
                  <span>"{searchQuery}"</span>
                  <button 
                    type="button" 
                    onClick={() => setSearchQuery('')} 
                    title="Remove search query"
                  >
                    <X size={12} />
                  </button>
                </span>
              )}

              {currentCategory && currentCategory !== 'All' && (
                <span className="active-filter-badge">
                  <span>{currentCategory}</span>
                  <button 
                    type="button" 
                    onClick={() => {
                      const newParams = new URLSearchParams(searchParams);
                      newParams.delete('category');
                      setSearchParams(newParams);
                    }} 
                    title="Clear category"
                  >
                    <X size={12} />
                  </button>
                </span>
              )}
            </div>
          </div>

          {loading ? (
            <div className="loading-state">
              <div className="spinner"></div>
              <span>Loading verified marketplace listings...</span>
            </div>
          ) : filteredListings.length === 0 ? (
            <div className="empty-state">
              <MapPin size={40} className="empty-icon" />
              <h3>No listings found {locationFilter !== 'All' ? `in "${locationFilter}"` : 'matching your filter criteria'}</h3>
              <p>{locationFilter !== 'All' ? 'Try exploring all locations or searching for another area.' : 'Try resetting filters or exploring other categories.'}</p>
              <div className="empty-state-actions">
                {locationFilter !== 'All' && (
                  <button 
                    type="button"
                    onClick={() => handleSelectLocation('All')} 
                    className="filter-pill active"
                    style={{ padding: '8px 18px', fontSize: '0.85rem' }}
                  >
                    Explore All Locations
                  </button>
                )}
                <button 
                  type="button"
                  onClick={handleResetFilters}
                  className="btn-primary"
                >
                  Clear All Filters
                </button>
              </div>
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
                          onError={(e) => {
                            e.target.onerror = null;
                            e.target.src = getCategoryDefaultImage(item.category);
                          }}
                        />
                      </Link>

                      {/* Top Badges */}
                      <div className="item-top-badges">
                        {item.is_just_posted && (
                          <span className="badge-just-posted">
                            <Sparkles size={11} />
                            Just Posted
                          </span>
                        )}
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

                        {/* Groceries & Fresh Produce Specs */}
                        {specs.weight && (
                          <span className="spec-chip">
                            {specs.weight}
                          </span>
                        )}
                        {specs.farming && (
                          <span className="spec-chip">
                            {specs.farming}
                          </span>
                        )}
                        {specs.harvest_date && (
                          <span className="spec-chip">
                            {specs.harvest_date}
                          </span>
                        )}

                        {/* Professional Services Specs */}
                        {specs.duration && (
                          <span className="spec-chip">
                            {specs.duration}
                          </span>
                        )}
                        {specs.team_size && (
                          <span className="spec-chip">
                            {specs.team_size}
                          </span>
                        )}
                        {specs.warranty && (
                          <span className="spec-chip">
                            {specs.warranty}
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
