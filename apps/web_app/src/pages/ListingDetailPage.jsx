import React, { useState, useEffect } from 'react';
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
  ShieldCheck,
  Send,
  Briefcase,
  ShoppingBag,
  Leaf
} from 'lucide-react';
import HeroSearch from '../components/home/HeroSearch';
import { getMarketplaceItemById } from '../data/marketplaceData';
import './ListingDetailPage.css';

export default function ListingDetailPage({ 
  onOpenContact, 
  favorites = [], 
  onToggleFavorite 
}) {
  const { id } = useParams();
  const item = getMarketplaceItemById(id);
  const listingId = item.id;
  const isFav = favorites.includes(listingId);

  const [activeThumbIndex, setActiveThumbIndex] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');

  // Reset active thumbnail when item changes
  useEffect(() => {
    setActiveThumbIndex(0);
    window.scrollTo(0, 0);
  }, [id]);

  const thumbnails = item.thumbnails || [
    { id: 0, label: 'Main', thumb: item.showcase_image, main: item.showcase_image }
  ];

  const currentMainImage = thumbnails[activeThumbIndex]?.main || item.showcase_image;

  const handleShare = () => {
    if (navigator.clipboard) {
      navigator.clipboard.writeText(window.location.href);
      alert('Listing link copied to clipboard!');
    }
  };

  // Dynamic search placeholder based on category
  const getSearchPlaceholder = () => {
    switch (item.category) {
      case 'Vehicles':
        return 'Explore Hyundai Creta Vehicles';
      case 'Property':
        return 'Explore Apartments & Properties';
      case 'Jobs':
        return 'Explore Tech & Design Jobs';
      case 'Groceries':
        return 'Explore Fresh Organic Vegetables & Groceries';
      case 'Electronics':
        return 'Explore Laptops & Apple Tech';
      case 'Mobiles':
        return 'Explore Smartphones & Tablets';
      case 'Furniture':
        return 'Explore Living & Home Decor';
      default:
        return 'Explore Marketplace Listings';
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
              placeholder={getSearchPlaceholder()}
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
            {/* Main Showcase Image Card */}
            <div className={`detail-main-showcase-box ${item.is_car_layout ? 'car-dark-bg' : 'generic-clean-bg'}`}>
              <img 
                src={currentMainImage} 
                alt={item.title} 
                className="detail-main-img" 
              />
            </div>

            {/* Thumbnails Row */}
            {thumbnails.length > 1 && (
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
            )}

            {/* Description Section */}
            <div className="detail-content-block">
              <h2 className="detail-block-title">Description</h2>
              <p className="detail-description-p">
                {item.description}
              </p>
            </div>

            {/* Details (Specifications Grid) */}
            <div className="detail-content-block">
              <h2 className="detail-block-title">Details</h2>
              <div className="detail-specs-grid">
                {item.specs.map((s, idx) => (
                  <div key={idx} className="spec-card-pill">
                    <span className="spec-label-sub">{s.label}</span>
                    <strong className="spec-value-main">{s.value}</strong>
                  </div>
                ))}
              </div>
            </div>

            {/* Similar Listings Section */}
            {item.similar && (
              <div className="detail-content-block">
                <h2 className="detail-block-title">Similar Listings</h2>
                <Link to={`/listings/${item.similar.id}`} className="similar-listing-card">
                  <div className="similar-car-img-wrap">
                    <img src={item.similar.image} alt={item.similar.title} className="similar-car-img" />
                  </div>
                  <div className="similar-car-info">
                    <div className="similar-price-row">
                      <strong className="similar-price-text">{item.similar.price}</strong>
                      {item.similar.negotiable && (
                        <span className="similar-negotiable-badge">Negotiable</span>
                      )}
                    </div>
                    <h3 className="similar-title-text">{item.similar.title}</h3>
                    <div className="similar-meta-row">
                      <span className="similar-location">{item.similar.location}</span>
                      <span className="similar-seller-dot">• {item.similar.sellerType}</span>
                      <span className="similar-time">{item.similar.time}</span>
                    </div>
                  </div>
                </Link>
              </div>
            )}
          </div>

          {/* ── Right Column: Sticky Price, Contact & Seller Profile ── */}
          <div className="detail-right-col">
            {/* Price & Vehicle / Item Title Card */}
            <div className="detail-card-panel price-card-panel">
              <div className="price-top-header-row">
                <div className="price-tag-col">
                  <div className="price-bold-amount">{item.formatted_price}</div>
                  {item.negotiable ? (
                    <span className="price-negotiable-tag">Negotiable</span>
                  ) : (
                    <span className="price-fixed-tag">Fixed Price</span>
                  )}
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

              <h1 className="detail-vehicle-name">{item.title}</h1>

              <div className="vehicle-meta-tags-list">
                <div className="vehicle-meta-item">
                  <MapPin size={14} className="meta-icon" />
                  <span>{item.location}</span>
                </div>
                <div className="vehicle-meta-item">
                  <Clock size={14} className="meta-icon" />
                  <span>{item.posted_time}</span>
                </div>
                <div className="vehicle-meta-item">
                  <Eye size={14} className="meta-icon" />
                  <span>{item.views}</span>
                </div>
              </div>
            </div>

            {/* Contact Seller / Action Card */}
            <div className="detail-card-panel contact-card-panel">
              <h3 className="panel-subhead-bold">
                {item.category === 'Jobs'
                  ? 'Apply for Position'
                  : item.category === 'Groceries'
                  ? 'Order Fresh Farm Produce'
                  : 'Contact Seller'}
              </h3>

              <div className="contact-buttons-stack">
                {item.category === 'Jobs' ? (
                  <>
                    <button 
                      type="button"
                      onClick={() => alert(`Submitting application for ${item.title} at ${item.seller.name}...`)}
                      className="btn-chat-orange"
                    >
                      <Briefcase size={16} />
                      <span>Apply Now</span>
                    </button>

                    <button 
                      type="button"
                      onClick={() => {
                        if (onOpenContact) {
                          onOpenContact({
                            title: item.title,
                            formatted_price: item.formatted_price,
                            seller_name: item.seller.name,
                            seller_phone: item.seller.phone,
                          });
                        }
                      }}
                      className="btn-outline-white"
                    >
                      <MessageSquare size={15} />
                      <span>Message Recruiter</span>
                    </button>
                  </>
                ) : item.category === 'Groceries' ? (
                  <>
                    <button 
                      type="button"
                      onClick={() => alert(`Placing same-day delivery order for ${item.title} (${item.formatted_price}). Farm fresh delivery guaranteed within 2 hours!`)}
                      className="btn-chat-orange"
                    >
                      <ShoppingBag size={16} />
                      <span>Order Fresh Produce</span>
                    </button>

                    <button 
                      type="button"
                      onClick={() => {
                        if (onOpenContact) {
                          onOpenContact({
                            title: item.title,
                            formatted_price: item.formatted_price,
                            seller_name: item.seller.name,
                            seller_phone: item.seller.phone,
                          });
                        } else {
                          alert(`Opening direct chat with ${item.seller.name}...`);
                        }
                      }}
                      className="btn-outline-white"
                    >
                      <MessageSquare size={15} />
                      <span>Chat with Farm Producer</span>
                    </button>

                    <button 
                      type="button"
                      onClick={() => alert(`Calling farm helpline for ${item.seller.name} at ${item.seller.phone}`)}
                      className="btn-outline-white"
                    >
                      <Phone size={15} />
                      <span>Call Farm</span>
                    </button>
                  </>
                ) : (
                  <>
                    <button 
                      type="button"
                      onClick={() => {
                        if (onOpenContact) {
                          onOpenContact({
                            title: item.title,
                            formatted_price: item.formatted_price,
                            seller_name: item.seller.name,
                            seller_phone: item.seller.phone,
                          });
                        } else {
                          alert(`Opening chat with ${item.seller.name}...`);
                        }
                      }}
                      className="btn-chat-orange"
                    >
                      <MessageSquare size={16} />
                      <span>Chat with Seller</span>
                    </button>

                    <button 
                      type="button"
                      onClick={() => alert(`Requesting inspection appointment for ${item.title}...`)}
                      className="btn-outline-white"
                    >
                      <ExternalLink size={15} />
                      <span>View with seller</span>
                    </button>

                    <button 
                      type="button"
                      onClick={() => alert(`Calling ${item.seller.name} at ${item.seller.phone}`)}
                      className="btn-outline-white"
                    >
                      <Phone size={15} />
                      <span>Call</span>
                    </button>
                  </>
                )}
              </div>
            </div>

            {/* Seller Profile Card */}
            <div className="detail-card-panel seller-profile-panel">
              <div className="seller-header-flex">
                <div className="seller-avatar-initial">{item.seller.initial}</div>
                <div className="seller-name-col">
                  <h4 className="seller-full-name">{item.seller.name}</h4>
                  <span className="seller-sub-meta">{item.seller.role}</span>
                </div>
              </div>

              <div className="seller-stats-three-boxes">
                {item.seller.stats.map((st, idx) => (
                  <div key={idx} className="seller-stat-box">
                    <strong className="stat-number">{st.number}</strong>
                    <span className="stat-label">{st.label}</span>
                  </div>
                ))}
              </div>

              <button 
                type="button" 
                onClick={() => alert(`Viewing profile of ${item.seller.name}...`)}
                className="btn-view-profile-white"
              >
                View Profile
              </button>
            </div>

            {/* Safety / Freshness Notice Box */}
            <div className="safety-notice-banner">
              {item.category === 'Groceries' ? (
                <Leaf size={16} className="safety-shield-icon" style={{ color: '#16A34A' }} />
              ) : (
                <ShieldCheck size={16} className="safety-shield-icon" />
              )}
              <p className="safety-notice-text">
                {item.category === 'Jobs'
                  ? 'Galletrix ensures employer identity and salary transparency. Never pay any fee for interview or job offers.'
                  : item.category === 'Groceries'
                  ? 'Galletrix Fresh Guarantee: 100% farm-picked with zero chemical pesticides. Quality checked & delivered under temperature-controlled logistics.'
                  : 'Meet in a safe public place for transactions. Report any suspicious behavior to keep the community safe.'}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
