import React from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, Heart, Star, Check, ShieldCheck } from 'lucide-react';
import './TrendingSection.css';

export default function TrendingSection({ favorites = [], onToggleFavorite }) {
  // 1. Discover what's trending matching Figma Desktop - 71 screenshot
  const trendingListings = [
    {
      id: 'list_creta_sx_2024',
      imagePath: '/images/h1.png',
      title: '2024 Hyundai Creta SX',
      location: 'Kochi',
      price: '₹ 16.5 Lakh',
      sellerType: 'Dealer',
      condition: 'Excellent',
    },
    {
      id: 'list_apt_kakkanad_3bhk',
      imagePath: '/images/h2.png',
      title: '3BHK Apartment in Kakkanad',
      location: 'Kochi',
      price: '₹ 1.25 Crore',
      sellerType: 'Dealer',
      condition: 'Excellent',
    },
    {
      id: 'list_job_senior_fe',
      imagePath: '/images/h3.png',
      title: 'Senior Frontend Engineer',
      location: 'Bengaluru',
      price: '₹ 18 - 24 LPA',
      sellerType: 'Employer',
      condition: 'Excellent',
    },
  ];

  // 2. Featured Near You items matching Figma screenshot
  const featuredNearYouItems = [
    {
      id: 'list_creta_near_1',
      imagePath: '/images/h1.png',
      price: '₹ 7,25,000',
      title: '2021 Hyundai Creta SX',
      location: 'Thiruvananthapuram',
    },
    {
      id: 'list_apt_near_2',
      imagePath: '/images/h2.png',
      price: '₹ 80,00,000',
      title: '2BHK Apartment Seaside',
      location: 'Thiruvananthapuram',
    },
    {
      id: 'list_designer_remote_3',
      imagePath: '/images/h3.png',
      price: '₹ 8,50,000 / yr',
      title: 'Senior UI/UX Designer',
      location: 'Remote',
    },
    {
      id: 'list_oak_dining_1',
      imagePath: '/images/h8.png',
      price: '₹ 48,000',
      title: 'Solid Oak Dining Table',
      location: 'Thiruvananthapuram',
    },
  ];

  // 3. Discover Trusted Business matching Figma screenshot
  const trustedBusinesses = [
    {
      id: 'biz_1',
      imagePath: '/images/h2.png',
      name: 'Greenfield Realtors',
      categoryLocation: 'Property • Thiruvananthapuram',
      rating: '4.8',
      listingsCount: '58 listings',
      route: '/listings?category=Property&query=Greenfield',
    },
    {
      id: 'biz_2',
      imagePath: '/images/h3.png',
      name: 'Lumen Labs',
      categoryLocation: 'Jobs • Remote',
      rating: '4.6',
      listingsCount: '12 listings',
      route: '/listings?category=Jobs&query=Lumen',
    },
    {
      id: 'biz_3',
      imagePath: '/images/h5.png',
      name: 'TechZone Electronics',
      categoryLocation: 'Electronics • Remote',
      rating: '4.7',
      listingsCount: '142 listings',
      route: '/listings?category=Electronics&query=TechZone',
    },
  ];

  return (
    <div className="home-third-page-wrap">
      <div className="container third-page-container">
        {/* ── SECTION 1: Discover what's trending ── */}
        <section className="trending-section-figma">
          <div className="section-head-figma">
            <h2 className="section-title-serif">Discover what's trending</h2>
            <p className="section-subtitle-clean">Fresh listings catching attention right now</p>
          </div>

          <div className="trending-three-grid-figma">
            {trendingListings.map((item) => (
              <Link key={item.id} to={`/listings/${item.id}`} className="trending-card-figma">
                <div className="trending-card-img-wrap">
                  <img src={item.imagePath} alt={item.title} className="trending-card-img" />
                </div>
                <div className="trending-card-body">
                  <div className="trending-card-row-top">
                    <h3 className="trending-card-title">{item.title}</h3>
                    <span className="trending-card-loc">{item.location}</span>
                  </div>
                  <div className="trending-card-row-bottom">
                    <span className="trending-card-price">{item.price}</span>
                    <div className="trending-card-badges">
                      <span className="trending-badge-pill">
                        <Check size={10} className="badge-check-icon" />
                        <span>{item.sellerType}</span>
                      </span>
                      <span className="trending-badge-pill">
                        <ShieldCheck size={10} className="badge-check-icon" />
                        <span>{item.condition}</span>
                      </span>
                    </div>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </section>

        {/* ── SECTION 2: Featured Near You (Enclosed Box Container) ── */}
        <section className="featured-near-container-box">
          <div className="featured-near-header">
            <h2 className="section-title-serif">Featured Near You</h2>
            <p className="section-subtitle-clean">Premium listing from trusted sellers and businesses.</p>
          </div>

          <div className="featured-near-four-grid">
            {featuredNearYouItems.map((item) => {
              const isFav = favorites.includes(item.id);
              return (
                <div key={item.id} className="featured-four-card-figma">
                  <div className="featured-img-wrap">
                    <Link to={`/listings/${item.id}`}>
                      <img src={item.imagePath} alt={item.title} className="featured-img" />
                    </Link>
                    <button 
                      type="button"
                      className={`featured-heart-btn ${isFav ? 'is-fav' : ''}`}
                      onClick={(e) => {
                        e.preventDefault();
                        onToggleFavorite(item.id);
                      }}
                      aria-label="Save to favorites"
                    >
                      <Heart 
                        size={13} 
                        fill={isFav ? "#F95738" : "none"} 
                        color={isFav ? "#F95738" : "#ffffff"} 
                      />
                    </button>
                  </div>
                  <div className="featured-info-box">
                    <span className="featured-price-text">{item.price}</span>
                    <Link to={`/listings/${item.id}`} className="featured-title-text">
                      {item.title}
                    </Link>
                    <span className="featured-loc-text">{item.location}</span>
                  </div>
                </div>
              );
            })}
          </div>
        </section>

        {/* ── SECTION 3: Discover Trusted Business ── */}
        <section className="trusted-biz-section-figma">
          <div className="trusted-biz-header-row">
            <div>
              <h2 className="section-title-serif">Discover Trusted Business</h2>
              <p className="section-subtitle-clean">Verified shops and businesses on the marketplace.</p>
            </div>
            <Link to="/shops" className="trusted-view-all-link">
              <span>View All</span>
              <ArrowRight size={13} />
            </Link>
          </div>

          <div className="trusted-biz-three-grid">
            {trustedBusinesses.map((biz) => (
              <div key={biz.id} className="trusted-biz-card-figma">
                <div className="biz-top-row">
                  <img src={biz.imagePath} alt={biz.name} className="biz-logo-img" />
                  <div className="biz-details-col">
                    <strong className="biz-name-text">{biz.name}</strong>
                    <span className="biz-cat-loc-text">{biz.categoryLocation}</span>
                    <div className="biz-rating-listings-row">
                      <Star size={11} fill="#F59E0B" color="#F59E0B" />
                      <span className="biz-rating-num">{biz.rating}</span>
                      <span className="biz-listings-count">{biz.listingsCount}</span>
                    </div>
                  </div>
                </div>
                <Link to={biz.route || "/shops"} className="biz-view-shop-btn">
                  View Shop
                </Link>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
