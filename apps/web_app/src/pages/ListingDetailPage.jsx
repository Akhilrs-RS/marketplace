import React, { useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { 
  ChevronLeft, 
  Search, 
  ArrowRight, 
  Heart, 
  Share2, 
  Bookmark, 
  MapPin, 
  Clock, 
  Eye, 
  MessageSquare, 
  Phone, 
  ExternalLink, 
  ShieldCheck 
} from 'lucide-react';
import HeroSearch from '../components/home/HeroSearch';
import './ListingDetailPage.css';

export default function ListingDetailPage({ 
  onOpenContact, 
  favorites = [], 
  onToggleFavorite 
}) {
  const { id } = useParams();
  const listingId = id || 'list_creta_2022';
  const isFav = favorites.includes(listingId);

  // Color variants / thumbnails matching Figma Desktop - 74
  const thumbnails = [
    { id: 0, label: 'White', thumb: '/images/creta_thumb_white.png', main: '/images/creta_main.png' },
    { id: 1, label: 'Red', thumb: '/images/creta_thumb_red.png', main: '/images/creta_thumb_red.png' },
    { id: 2, label: 'Green', thumb: '/images/creta_thumb_green.png', main: '/images/creta_thumb_green.png' },
    { id: 3, label: 'Black', thumb: '/images/creta_thumb_black.png', main: '/images/creta_thumb_black.png' },
  ];

  const [activeThumbIndex, setActiveThumbIndex] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');

  // Specs grid items matching Figma Desktop - 74
  const specs = [
    { label: 'Brand', value: 'Hyundai' },
    { label: 'Model', value: 'Creta SX' },
    { label: 'Year', value: '2022' },
    { label: 'Fuel', value: 'Petrol' },
    { label: 'Transmission', value: 'Manual' },
    { label: 'KM', value: '18400' },
    { label: 'Ownership', value: '1st' },
  ];

  const handleShare = () => {
    if (navigator.clipboard) {
      navigator.clipboard.writeText(window.location.href);
      alert('Listing link copied to clipboard!');
    }
  };

  return (
    <div className="listing-detail-page-root">
      {/* 1. Hero Search Header Banner matching Figma Desktop - 74 */}
      <HeroSearch />

      {/* 2. Main Page Content Container */}
      <div className="container listing-detail-container">
        {/* Top Control Bar: Back Button on Left, Secondary Search on Right */}
        <div className="detail-top-bar">
          <Link to="/listings" className="detail-back-btn">
            <ChevronLeft size={15} />
            <span>Back</span>
          </Link>

          <form 
            className="detail-search-pill" 
            onSubmit={(e) => e.preventDefault()}
          >
            <Search size={15} className="detail-search-icon" />
            <input 
              type="text" 
              placeholder="Explore Hyundai Creta Vehicles" 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="detail-search-input"
            />
            <button type="submit" className="detail-search-submit">
              <span>Search</span>
              <ArrowRight size={13} />
            </button>
          </form>
        </div>

        {/* Two-Column Layout */}
        <div className="listing-detail-grid">
          {/* ── Left Column: Showcase, Thumbnails, Specs, Similar ── */}
          <div className="detail-left-col">
            {/* Main Showcase Image Card (Dark slate container) */}
            <div className="detail-main-showcase-box">
              <img 
                src={thumbnails[activeThumbIndex].main} 
                alt="2022 Hyundai Creta SX" 
                className="detail-main-img" 
              />
            </div>

            {/* Thumbnails Row */}
            <div className="detail-thumbnails-row">
              {thumbnails.map((t, idx) => (
                <button
                  key={t.id}
                  type="button"
                  onClick={() => setActiveThumbIndex(idx)}
                  className={`detail-thumb-box ${activeThumbIndex === idx ? 'active' : ''}`}
                >
                  <img src={t.thumb} alt={t.label} className="detail-thumb-img" />
                </button>
              ))}
            </div>

            {/* Description Section */}
            <div className="detail-content-block">
              <h2 className="detail-block-title">Description</h2>
              <p className="detail-description-p">
                Single owner, well-maintained, full service history, Sunroof, leather seats, reverse camera.
              </p>
            </div>

            {/* Details (Specifications Grid) */}
            <div className="detail-content-block">
              <h2 className="detail-block-title">Details</h2>
              <div className="detail-specs-grid">
                {specs.map((item, idx) => (
                  <div key={idx} className="spec-card-pill">
                    <span className="spec-label-sub">{item.label}</span>
                    <strong className="spec-value-main">{item.value}</strong>
                  </div>
                ))}
              </div>
            </div>

            {/* Similar Listings Section */}
            <div className="detail-content-block">
              <h2 className="detail-block-title">Similar Listings</h2>
              <Link to="/listings/list_i20_sportz" className="similar-listing-card">
                <div className="similar-car-img-wrap">
                  <img src="/images/i20_sportz.png" alt="Hyundai i20 Sportz" className="similar-car-img" />
                </div>
                <div className="similar-car-info">
                  <div className="similar-price-row">
                    <strong className="similar-price-text">₹ 7,80,000</strong>
                    <span className="similar-negotiable-badge">Negotiable</span>
                  </div>
                  <h3 className="similar-title-text">Hyundai i20 Sportz</h3>
                  <div className="similar-meta-row">
                    <span className="similar-location">Kollam</span>
                    <span className="similar-seller-dot">• Individual</span>
                    <span className="similar-time">2w ago</span>
                  </div>
                </div>
              </Link>
            </div>
          </div>

          {/* ── Right Column: Sticky Price, Contact & Seller Profile ── */}
          <div className="detail-right-col">
            {/* Price & Vehicle Title Card */}
            <div className="detail-card-panel price-card-panel">
              <div className="price-top-header-row">
                <div className="price-tag-col">
                  <div className="price-bold-amount">₹ 7,25,000</div>
                  <span className="price-negotiable-tag">Negotiable</span>
                </div>

                <div className="price-actions-icons-row">
                  <button 
                    type="button" 
                    onClick={() => onToggleFavorite && onToggleFavorite(listingId)}
                    className="icon-action-btn"
                    title={isFav ? 'Remove from favorites' : 'Save to favorites'}
                  >
                    <Heart 
                      size={18} 
                      fill={isFav ? '#EF4444' : 'none'} 
                      color={isFav ? '#EF4444' : '#64748B'} 
                    />
                  </button>

                  <button 
                    type="button" 
                    onClick={handleShare}
                    className="icon-action-btn"
                    title="Share listing"
                  >
                    <Share2 size={17} color="#64748B" />
                  </button>

                  <button 
                    type="button" 
                    onClick={() => alert('Listing bookmarked!')}
                    className="icon-action-btn"
                    title="Bookmark listing"
                  >
                    <Bookmark size={17} color="#64748B" />
                  </button>
                </div>
              </div>

              <h1 className="detail-vehicle-name">2022 Hyundai Creta SX</h1>

              <div className="vehicle-meta-tags-list">
                <div className="vehicle-meta-item">
                  <MapPin size={14} className="meta-icon" />
                  <span>Thiruvananthapuram</span>
                </div>
                <div className="vehicle-meta-item">
                  <Clock size={14} className="meta-icon" />
                  <span>Posted 2d ago</span>
                </div>
                <div className="vehicle-meta-item">
                  <Eye size={14} className="meta-icon" />
                  <span>1,148 views</span>
                </div>
              </div>
            </div>

            {/* Contact Seller Card */}
            <div className="detail-card-panel contact-card-panel">
              <h3 className="panel-subhead-bold">Contact Seller</h3>

              <div className="contact-buttons-stack">
                <button 
                  type="button"
                  onClick={() => {
                    if (onOpenContact) {
                      onOpenContact({
                        title: '2022 Hyundai Creta SX',
                        formatted_price: '₹ 7,25,000',
                        seller_name: 'Arjun Menon',
                        seller_phone: '+91 98470 54321',
                      });
                    } else {
                      alert('Opening chat with Arjun Menon...');
                    }
                  }}
                  className="btn-chat-orange"
                >
                  <MessageSquare size={16} />
                  <span>Chat with Seller</span>
                </button>

                <button 
                  type="button"
                  onClick={() => alert('Requesting verified inspection with seller...')}
                  className="btn-outline-white"
                >
                  <ExternalLink size={15} />
                  <span>View with seller</span>
                </button>

                <button 
                  type="button"
                  onClick={() => alert('Calling seller at +91 98470 54321')}
                  className="btn-outline-white"
                >
                  <Phone size={15} />
                  <span>Call</span>
                </button>
              </div>
            </div>

            {/* Seller Profile Card */}
            <div className="detail-card-panel seller-profile-panel">
              <div className="seller-header-flex">
                <div className="seller-avatar-initial">A</div>
                <div className="seller-name-col">
                  <h4 className="seller-full-name">Arjun Menon</h4>
                  <span className="seller-sub-meta">Individual Seller (Member Since 2024)</span>
                </div>
              </div>

              <div className="seller-stats-three-boxes">
                <div className="seller-stat-box">
                  <strong className="stat-number">12</strong>
                  <span className="stat-label">Active</span>
                </div>
                <div className="seller-stat-box">
                  <strong className="stat-number">98%</strong>
                  <span className="stat-label">Response</span>
                </div>
                <div className="seller-stat-box">
                  <strong className="stat-number">12</strong>
                  <span className="stat-label">Sold</span>
                </div>
              </div>

              <button 
                type="button" 
                onClick={() => alert('Viewing profile of Arjun Menon...')}
                className="btn-view-profile-white"
              >
                View Profile
              </button>
            </div>

            {/* Safety Notice Box */}
            <div className="safety-notice-banner">
              <ShieldCheck size={16} className="safety-shield-icon" />
              <p className="safety-notice-text">
                Meet in a safe public place for transactions. Report any suspicious behavior to keep the community safe.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
