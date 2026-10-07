import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { 
  Package, 
  PlusCircle, 
  Eye, 
  Sparkles, 
  MapPin, 
  Clock, 
  Tag, 
  Share2, 
  Trash2, 
  ExternalLink,
  ChevronRight,
  ShieldCheck,
  CheckCircle2
} from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { getPublishedListings, getCategoryDefaultImage, cacheRuntimeListing } from '../data/userListingsData';
import { fetchListings, resolveImageUrl } from '../api/client';
import './MyAdsPage.css';

export default function MyAdsPage() {
  const { currentUser, isLoggedIn, openLoginModal } = useAuth();
  const navigate = useNavigate();
  const [ads, setAds] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadUserAds() {
      setLoading(true);
      // 1. Get locally created ads
      const local = getPublishedListings();

      // 2. Fetch backend ads matching current user (Alex Morgan / usr_current_user)
      let backendAds = [];
      try {
        const allRemote = await fetchListings();
        if (Array.isArray(allRemote)) {
          backendAds = allRemote.filter(item => 
            item.seller_id === 'usr_current_user' || 
            item.seller_name?.toLowerCase().includes('alex') ||
            item.id === 'list_1791357264921' // user's apple iphone ad
          );
        }
      } catch (err) {
        console.warn('Could not fetch backend ads:', err);
      }

      // Merge and deduplicate by ID
      const combined = [...local];
      backendAds.forEach(b => {
        cacheRuntimeListing(b);
        if (!combined.some(c => c.id === b.id)) {
          combined.push(b);
        }
      });

      setAds(combined);
      setLoading(false);
    }

    loadUserAds();
    window.addEventListener('galletrix_listings_updated', loadUserAds);
    return () => window.removeEventListener('galletrix_listings_updated', loadUserAds);
  }, []);

  const handleShare = (adId, e) => {
    e.preventDefault();
    e.stopPropagation();
    const url = `${window.location.origin}/listings/${adId}`;
    if (navigator.clipboard) {
      navigator.clipboard.writeText(url);
      alert('Listing link copied to clipboard!');
    }
  };

  const handleDelete = (adId, e) => {
    e.preventDefault();
    e.stopPropagation();
    if (window.confirm('Are you sure you want to remove this listing?')) {
      const updated = ads.filter(a => a.id !== adId);
      setAds(updated);
      try {
        localStorage.setItem('galletrix_published_listings', JSON.stringify(updated));
      } catch (err) {
        console.error(err);
      }
    }
  };

  return (
    <div className="my-ads-page-root">
      <div className="container my-ads-container">
        {/* Header Breadcrumb & Top Bar */}
        <div className="my-ads-header-row">
          <div className="my-ads-title-col">
            <span className="my-ads-badge">
              <Package size={14} /> Seller Dashboard
            </span>
            <h1 className="my-ads-page-title">My Existing Ads</h1>
            <p className="my-ads-page-desc">
              Manage your active listings, track customer views, and inspect live ad details.
            </p>
          </div>

          <div className="my-ads-actions-col">
            <Link to="/post-ad" className="btn-post-ad-primary">
              <PlusCircle size={17} />
              <span>Post a New Ad</span>
            </Link>
          </div>
        </div>

        {/* User Identity Strip */}
        <div className="my-ads-seller-strip">
          <div className="seller-strip-left">
            <div className="seller-strip-avatar">
              {currentUser?.name ? currentUser.name[0].toUpperCase() : 'A'}
            </div>
            <div className="seller-strip-info">
              <strong className="seller-strip-name">{currentUser?.name || 'Alex Morgan'}</strong>
              <span className="seller-strip-role">
                <ShieldCheck size={13} color="#10b981" /> Verified Active Seller • All in One Today
              </span>
            </div>
          </div>

          <div className="seller-strip-stats">
            <div className="strip-stat-item">
              <span className="strip-stat-val">{ads.length}</span>
              <span className="strip-stat-lbl">Existing Ads</span>
            </div>
            <div className="strip-stat-divider" />
            <div className="strip-stat-item">
              <span className="strip-stat-val">100%</span>
              <span className="strip-stat-lbl">Response Rate</span>
            </div>
            <div className="strip-stat-divider" />
            <div className="strip-stat-item">
              <span className="strip-stat-val">Active</span>
              <span className="strip-stat-lbl">Account Status</span>
            </div>
          </div>
        </div>

        {/* Listings Content */}
        {loading ? (
          <div className="my-ads-loading-state">
            <div className="spinner-blue" />
            <p>Loading your existing listings...</p>
          </div>
        ) : ads.length === 0 ? (
          <div className="my-ads-empty-card">
            <div className="empty-icon-circle">
              <Package size={48} color="#64748b" />
            </div>
            <h3 className="empty-title">No Existing Ads Found</h3>
            <p className="empty-desc">
              You haven't posted any ads yet. Start selling to thousands of verified buyers today!
            </p>
            <Link to="/post-ad" className="btn-empty-post">
              <PlusCircle size={16} />
              <span>Post Your First Ad Now</span>
            </Link>
          </div>
        ) : (
          <div className="my-ads-grid">
            {ads.map((ad) => {
              const defaultImage = getCategoryDefaultImage(ad.category);
              const coverImage = resolveImageUrl(ad.image_path || defaultImage, ad.category);
              const formattedPrice = ad.formatted_price || (ad.price ? `₹ ${Number(ad.price).toLocaleString('en-IN')}` : 'Price on request');

              return (
                <div key={ad.id} className="my-ad-card">
                  {/* Photo with status tag */}
                  <div className="my-ad-img-box">
                    <img 
                      src={coverImage} 
                      alt={ad.title} 
                      className="my-ad-img"
                      onError={(e) => {
                        e.target.onerror = null;
                        e.target.src = defaultImage;
                      }}
                    />
                    <span className="my-ad-live-pill">
                      <span className="pulse-dot" /> LIVE NOW
                    </span>
                    <span className="my-ad-cat-tag">
                      {ad.category || 'Mobiles'}
                    </span>
                  </div>

                  {/* Body Content */}
                  <div className="my-ad-body">
                    <div className="my-ad-price-row">
                      <strong className="my-ad-price">{formattedPrice}</strong>
                      <span className="my-ad-id-chip">ID: {ad.id}</span>
                    </div>

                    <h3 className="my-ad-title">{ad.title}</h3>

                    <div className="my-ad-meta-row">
                      <span className="my-ad-meta-item">
                        <MapPin size={13} /> {ad.location || 'Kerala'}
                      </span>
                      <span className="my-ad-meta-item">
                        <Clock size={13} /> {ad.posted_time || 'Active'}
                      </span>
                    </div>

                    {/* Specifications Chips */}
                    {ad.specifications && Object.keys(ad.specifications).length > 0 && (
                      <div className="my-ad-specs-row">
                        {Object.entries(ad.specifications).slice(0, 3).map(([k, v]) => (
                          <span key={k} className="my-ad-spec-badge">
                            {k}: {String(v)}
                          </span>
                        ))}
                      </div>
                    )}

                    {/* Bottom Action Buttons */}
                    <div className="my-ad-footer-actions">
                      <Link 
                        to={`/listings/${ad.id}`} 
                        className="btn-view-ad-primary"
                        title="View live marketplace detail page"
                      >
                        <Eye size={15} />
                        <span>View Live Ad</span>
                        <ChevronRight size={14} />
                      </Link>

                      <button
                        type="button"
                        className="btn-ad-icon-secondary"
                        onClick={(e) => handleShare(ad.id, e)}
                        title="Share listing link"
                      >
                        <Share2 size={15} />
                      </button>

                      <button
                        type="button"
                        className="btn-ad-icon-danger"
                        onClick={(e) => handleDelete(ad.id, e)}
                        title="Remove listing"
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
