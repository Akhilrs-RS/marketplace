import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { 
  ChevronLeft, 
  Search, 
  MapPin, 
  Car, 
  Bike, 
  Star, 
  Heart, 
  ArrowRight 
} from 'lucide-react';
import HeroSearch from '../components/home/HeroSearch';
import './ShopsPage.css';

export default function ShopsPage({ onOpenContact, favorites = [], onToggleFavorite }) {
  const [searchTerm, setSearchTerm] = useState('');
  const [locationTerm, setLocationTerm] = useState('');

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
    const qLoc = locationTerm.trim().toLowerCase();
    const matchesName = !qName || 
      shop.name.toLowerCase().includes(qName) || 
      shop.category.toLowerCase().includes(qName);
    const matchesLoc = !qLoc || shop.location.toLowerCase().includes(qLoc);
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
                  onChange={(e) => setLocationTerm(e.target.value)}
                  className="search-pill-input search-pill-location"
                />
              </div>

              <button type="submit" className="search-pill-submit-btn">
                <span>Search</span>
                <ArrowRight size={14} />
              </button>
            </form>
          </div>

          {/* 3x3 Grid of 9 Vehicle Shop Cards */}
          <div className="vehicle-shops-grid">
            {filteredShops.map((shop) => {
              const isFav = favorites.includes(shop.id);
              return (
                <div key={shop.id} className="vehicle-shop-card">
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
                      <Link 
                        to={`/listings?query=${encodeURIComponent(shop.name)}`}
                        className="shop-action-btn-circle"
                        title="View showroom"
                      >
                        <ArrowRight size={16} color="#475569" />
                      </Link>
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
                </div>
              );
            })}
          </div>
        </div>
      </section>
    </div>
  );
}
