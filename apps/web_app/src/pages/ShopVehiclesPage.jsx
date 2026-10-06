import React, { useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { ChevronLeft, Search, Star, Heart, ArrowRight, Fuel } from 'lucide-react';
import HeroSearch from '../components/home/HeroSearch';
import { getDealershipInventory } from '../data/dealershipInventoryData';
import './ShopVehiclesPage.css';

export default function ShopVehiclesPage({ favorites = [], onToggleFavorite }) {
  const { id } = useParams();
  const [searchTerm, setSearchTerm] = useState('');

  const dealership = getDealershipInventory(id);
  const vehicles = dealership.vehicles || [];

  const filteredVehicles = vehicles.filter((v) => {
    const q = searchTerm.trim().toLowerCase();
    if (!q) return true;
    return (
      v.title.toLowerCase().includes(q) ||
      v.specs.toLowerCase().includes(q) ||
      v.fuelMileage.toLowerCase().includes(q)
    );
  });

  return (
    <div className="shop-vehicles-page-root">
      {/* 1. Hero Search Banner matching Figma Desktop - 73 */}
      <HeroSearch />

      {/* 2. Main Vehicle Inventory Content */}
      <section className="shop-vehicles-main-section">
        <div className="container shop-vehicles-container">
          {/* Subheader bar with Back button and search pill */}
          <div className="inventory-subbar-row">
            <Link to="/shops" className="inventory-back-btn">
              <ChevronLeft size={16} />
              <span>Back</span>
            </Link>

            <form 
              className="inventory-search-pill"
              onSubmit={(e) => e.preventDefault()}
            >
              <Search size={16} className="inventory-search-icon" />
              <input
                type="text"
                placeholder={`Explore ${dealership.searchKeyword || dealership.name}`}
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="inventory-search-input"
              />
              <button type="submit" className="inventory-search-submit-btn">
                <span>Search</span>
                <ArrowRight size={14} />
              </button>
            </form>
          </div>

          {/* 3-column Grid of Vehicles matching Figma Desktop - 73 */}
          <div className="shop-vehicles-grid">
            {filteredVehicles.map((car) => {
              const isFav = favorites.includes(car.id);
              return (
                <Link
                  key={car.id}
                  to={`/listings/${car.listingId}`}
                  className="shop-vehicle-card"
                >
                  {/* Card Header with Favorite Heart Button */}
                  <div className="car-card-top-bar">
                    <button
                      type="button"
                      onClick={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        if (onToggleFavorite) onToggleFavorite(car.id);
                      }}
                      className={`car-card-fav-btn ${isFav ? 'is-fav' : ''}`}
                      title={isFav ? 'Remove from favorites' : 'Save to favorites'}
                    >
                      <Heart
                        size={17}
                        fill={isFav ? '#EF4444' : '#334155'}
                        color={isFav ? '#EF4444' : '#334155'}
                      />
                    </button>
                  </div>

                  {/* Centered Vehicle Image */}
                  <div className="car-card-image-wrap">
                    <img
                      src={car.image}
                      alt={car.title}
                      className="car-card-img"
                      loading="lazy"
                    />
                  </div>

                  {/* Card Info Section */}
                  <div className="car-card-body">
                    {/* Title & Rating Row */}
                    <div className="car-card-title-row">
                      <h3 className="car-card-title">{car.title}</h3>
                      <div className="car-card-rating">
                        <Star size={13} fill="#F59E0B" color="#F59E0B" />
                        <span className="car-rating-score">{car.rating}</span>
                      </div>
                    </div>

                    {/* Price Row: Strikethrough original and bold final price */}
                    <div className="car-card-price-row">
                      <span className="car-card-strike-price">{car.originalPrice}</span>
                      <span className="car-card-final-price">{car.price}</span>
                    </div>

                    {/* Spec Row 1 */}
                    <div className="car-card-specs-row">
                      <span>{car.specs}</span>
                    </div>

                    {/* Fuel & Mileage Row 2 */}
                    <div className="car-card-fuel-row">
                      <Fuel size={13} className="car-fuel-icon" />
                      <span>{car.fuelMileage}</span>
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>

          {filteredVehicles.length === 0 && (
            <div className="inventory-empty-state">
              <p>No vehicles found matching "{searchTerm}".</p>
              <button 
                type="button" 
                onClick={() => setSearchTerm('')} 
                className="inventory-reset-btn"
              >
                Clear Search
              </button>
            </div>
          )}
        </div>
      </section>
    </div>
  );
}
