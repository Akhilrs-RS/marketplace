import React, { useState, useEffect } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { 
  ChevronLeft, 
  Search, 
  MapPin, 
  Car, 
  Bike, 
  Star, 
  Heart, 
  ArrowRight,
  X
} from 'lucide-react';
import HeroSearch from '../components/home/HeroSearch';
import './ShopsPage.css';

function matchLocation(itemLocation, filterQuery) {
  if (!filterQuery || filterQuery === 'All') return true;
  if (!itemLocation) return false;

  const loc = itemLocation.toLowerCase();
  const q = filterQuery.toLowerCase().trim();
  if (!q) return true;

  if (loc.includes(q)) return true;

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

  return false;
}

export default function ShopsPage({ onOpenContact, favorites = [], onToggleFavorite }) {
  const [searchParams, setSearchParams] = useSearchParams();
  const urlLoc = searchParams.get('location') || '';
  const [searchTerm, setSearchTerm] = useState('');
  const [locationTerm, setLocationTerm] = useState(urlLoc);

  useEffect(() => {
    setLocationTerm(urlLoc);
  }, [urlLoc]);

  const handleLocationChange = (val) => {
    setLocationTerm(val);
    const p = new URLSearchParams(searchParams);
    if (!val || val === 'All') {
      p.delete('location');
    } else {
      p.set('location', val);
    }
    setSearchParams(p);
  };

  // 9 Dealership Cards exactly matching Figma Screenshot (Desktop - 72)
  const allDealerships = [
    {
      id: 'shop_hyundai_1',
      name: 'Hyundai Auto Hub',
      image: '/images/dealership_cars.png',
      vehiclesCount: '12 Vehicles',
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.6',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_moto_world',
      name: 'Moto World',
      image: '/images/dealership_bikes.png',
      vehiclesCount: '24 Vehicles',
      location: 'Thiruvananthapuram',
      category: 'Bikes & Scooter',
      iconType: 'bike',
      rating: '4.6',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_maruti_car_point',
      name: 'Maruti Car Point',
      image: '/images/dealership_cars.png',
      vehiclesCount: '12 Vehicles',
      location: 'Kowdiar',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.8',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_honda_2_wheelers',
      name: 'Honda 2 Wheelers',
      image: '/images/dealership_indoor.png',
      vehiclesCount: null,
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.8',
      badge: 'Trusted Dealer',
      actionType: 'arrow',
    },
    {
      id: 'shop_kerala_commercial',
      name: 'Kerala Commercial Motor',
      image: '/images/dealership_bikes.png',
      vehiclesCount: '24 Vehicles',
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.8',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_hyundai_2',
      name: 'Hyundai Auto Hub',
      image: '/images/dealership_cars.png',
      vehiclesCount: '12 Vehicles',
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.8',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_hyundai_night',
      name: 'Hyundai Auto Hub',
      image: '/images/dealership_night.png',
      vehiclesCount: null,
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.6',
      badge: 'Trusted Dealer',
      actionType: null,
    },
    {
      id: 'shop_hyundai_3',
      name: 'Hyundai Auto Hub',
      image: '/images/dealership_cars.png',
      vehiclesCount: '12 Vehicles',
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.6',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
    {
      id: 'shop_hyundai_4',
      name: 'Hyundai Auto Hub',
      image: '/images/dealership_cars.png',
      vehiclesCount: '12 Vehicles',
      location: 'Kazhakkoottam',
      category: 'Cars & SUVs',
      iconType: 'car',
      rating: '4.6',
      badge: 'Trusted Dealer',
      actionType: 'heart',
    },
  ];

  const filteredShops = allDealerships.filter((shop) => {
    const qName = searchTerm.trim().toLowerCase();
    const matchesName = !qName || 
      shop.name.toLowerCase().includes(qName) || 
      shop.category.toLowerCase().includes(qName);
    const matchesLoc = matchLocation(shop.location, locationTerm);
    return matchesName && matchesLoc;
  });

  return (
    <div className="shops-page-root">
      {/* 1. Hero Search Banner matching Figma Desktop - 72 */}
      <HeroSearch />

      {/* 2. Vehicle Shops Content Section */}
      <section className="vehicle-shops-main-section">
        <div className="container vehicle-shops-container">
          {/* Back Button */}
          <div className="shops-nav-back-row">
            <Link to="/" className="vehicle-shops-back-btn">
              <ChevronLeft size={15} />
              <span>Back</span>
            </Link>
          </div>

          {/* Header Row: Title & Subtitle on Left, Inline Search Pill on Right */}
          <div className="vehicle-shops-header-row">
            <div className="shops-title-col">
              <h1 className="shops-title-serif">Vehicle Shops</h1>
              <p className="shops-subtitle-clean">
                Find the best showrooms and trusted dealers near you. Explore a wide range of vehicles from top brands.
              </p>
            </div>

            <form 
              className="shops-pill-search-bar" 
              onSubmit={(e) => e.preventDefault()}
            >
              <div className="search-bar-input-group">
                <Search size={16} className="search-pill-icon" />
                <input 
                  type="text" 
                  placeholder="Explore Vehicle Shops"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="search-pill-input"
                />
              </div>

              <div className="search-pill-divider" />

              <div className="search-bar-input-group">
                <MapPin size={16} className="search-pill-icon" />
                <input 
                  type="text" 
                  placeholder="Location"
                  value={locationTerm}
                  onChange={(e) => handleLocationChange(e.target.value)}
                  className="search-pill-input search-pill-location"
                />
                {locationTerm && (
                  <button 
                    type="button" 
                    onClick={() => handleLocationChange('')}
                    style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#94A3B8', display: 'flex', alignItems: 'center', padding: '0 4px' }}
                    title="Clear location"
                  >
                    <X size={14} />
                  </button>
                )}
              </div>

              <button type="submit" className="search-pill-submit-btn">
                <span>Search</span>
                <ArrowRight size={14} />
              </button>
            </form>
          </div>

          {/* Quick Location Pills */}
          <div className="shops-quick-city-pills">
            <span className="shops-loc-pill-label">Filter by City:</span>
            {['All', 'Kazhakkoottam', 'Kowdiar', 'Thiruvananthapuram'].map((c) => (
              <button
                key={c}
                type="button"
                className={`shops-city-pill ${(locationTerm === c || (c === 'All' && !locationTerm)) ? 'active' : ''}`}
                onClick={() => handleLocationChange(c === 'All' ? '' : c)}
              >
                {c}
              </button>
            ))}
          </div>

          {/* 3x3 Grid of 9 Vehicle Shop Cards or Empty State */}
          {filteredShops.length === 0 ? (
            <div className="empty-state" style={{ margin: '40px 0' }}>
              <MapPin size={40} className="empty-icon" />
              <h3>No vehicle showrooms found in "{locationTerm}"</h3>
              <p>Explore all dealerships across Kerala & South India.</p>
              <button
                type="button"
                className="btn-primary"
                onClick={() => handleLocationChange('')}
              >
                View All Dealerships
              </button>
            </div>
          ) : (
            <div className="vehicle-shops-grid">
            {filteredShops.map((shop) => {
              const isFav = favorites.includes(shop.id);
              return (
                <Link 
                  key={shop.id} 
                  to={`/shops/${shop.id}`}
                  className="vehicle-shop-card"
                >
                  {/* Image Wrap with count badge and action button */}
                  <div className="shop-card-image-wrap">
                    <img 
                      src={shop.image} 
                      alt={shop.name} 
                      className="shop-card-img" 
                      loading="lazy"
                    />

                    {/* Left Bottom Vehicles Count Pill */}
                    {shop.vehiclesCount && (
                      <span className="shop-badge-vehicles">
                        {shop.vehiclesCount}
                      </span>
                    )}

                    {/* Top Right Action Button */}
                    {shop.actionType === 'heart' && (
                      <button 
                        type="button"
                        onClick={(e) => {
                          e.preventDefault();
                          e.stopPropagation();
                          if (onToggleFavorite) onToggleFavorite(shop.id);
                        }}
                        className={`shop-action-btn-circle ${isFav ? 'is-favorited' : ''}`}
                        title={isFav ? 'Remove from favorites' : 'Save to favorites'}
                      >
                        <Heart 
                          size={16} 
                          fill={isFav ? '#EF4444' : 'none'} 
                          color={isFav ? '#EF4444' : '#475569'} 
                        />
                      </button>
                    )}

                    {shop.actionType === 'arrow' && (
                      <div 
                        className="shop-action-btn-circle"
                        title="View showroom"
                      >
                        <ArrowRight size={16} color="#475569" />
                      </div>
                    )}
                  </div>

                  {/* Card Body */}
                  <div className="shop-card-body">
                    <h3 className="shop-card-title">{shop.name}</h3>

                    {/* Meta Row: Location and Vehicle Type */}
                    <div className="shop-card-meta-row">
                      <span className="shop-meta-item">
                        <MapPin size={13} className="shop-meta-icon" />
                        <span>{shop.location}</span>
                      </span>

                      <span className="shop-meta-item">
                        {shop.iconType === 'bike' ? (
                          <Bike size={14} className="shop-meta-icon" />
                        ) : (
                          <Car size={14} className="shop-meta-icon" />
                        )}
                        <span>{shop.category}</span>
                      </span>
                    </div>

                    {/* Rating & Trust Row */}
                    <div className="shop-card-rating-row">
                      <span className="shop-rating-pill">
                        <Star size={12} fill="#F59E0B" color="#F59E0B" />
                        <span>{shop.rating}</span>
                      </span>
                      <span className="shop-rating-dot">•</span>
                      <span className="shop-trust-badge">{shop.badge}</span>
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        )}
        </div>
      </section>
    </div>
  );
}
