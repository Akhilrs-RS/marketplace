import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  X, 
  Upload, 
  CheckCircle2, 
  Sparkles, 
  MapPin, 
  Tag, 
  ExternalLink,
  ChevronRight,
  Eye,
  Check
} from 'lucide-react';
import { createListing, resolveImageUrl } from '../../api/client';
import { savePublishedListing, getCategoryDefaultImage } from '../../data/userListingsData';
import './PostAdModal.css';

export default function PostAdModal({ isOpen, onClose, onListingCreated }) {
  const navigate = useNavigate();

  const [title, setTitle] = useState('');
  const [category, setCategory] = useState('Vehicles');
  const [price, setPrice] = useState('');
  const [location, setLocation] = useState('Kochi');
  const [description, setDescription] = useState('');
  
  // Specific attributes
  const [fuelType, setFuelType] = useState('Petrol');
  const [transmission, setTransmission] = useState('Automatic');
  const [propertyBhk, setPropertyBhk] = useState('3 BHK');
  const [deviceCondition, setDeviceCondition] = useState('Like New • Flawless');

  const [submitting, setSubmitting] = useState(false);
  const [success, setSuccess] = useState(false);
  const [createdItem, setCreatedItem] = useState(null);
  const [countdown, setCountdown] = useState(4);

  // Reset form when modal opens
  useEffect(() => {
    if (isOpen) {
      setSuccess(false);
      setCreatedItem(null);
      setSubmitting(false);
      setCountdown(4);
    }
  }, [isOpen]);

  // Auto-redirect countdown on success
  useEffect(() => {
    let timer;
    if (success && createdItem && countdown > 0) {
      timer = setTimeout(() => {
        setCountdown((prev) => prev - 1);
      }, 1000);
    } else if (success && createdItem && countdown === 0) {
      handleViewListing();
    }
    return () => clearTimeout(timer);
  }, [success, createdItem, countdown]);

  if (!isOpen) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim() || !price) {
      alert('Please fill in both a title and a price.');
      return;
    }

    setSubmitting(true);
    const parsedPrice = parseFloat(String(price).replace(/[^0-9.]/g, '')) || 500000;
    const categoryImg = getCategoryDefaultImage(category);

    const specifications = {};
    if (category === 'Vehicles') {
      specifications.fuel_type = fuelType;
      specifications.transmission = transmission;
      specifications.owner = '1st Owner • Verified';
      specifications.total_capacity = '5 Seats';
    } else if (category === 'Property') {
      specifications.bedrooms = propertyBhk;
      specifications.super_area = '1,850 sq.ft';
      specifications.furnishing = 'Semi-Furnished';
    } else {
      specifications.condition = deviceCondition;
      specifications.warranty = 'Available / Verified';
    }

    const catPrefix = (category || 'item').toLowerCase().replace(/\s+/g, '_');
    const payload = {
      id: `list_${catPrefix}_${Date.now()}`,
      title: title.trim(),
      price: parsedPrice,
      formatted_price: `₹ ${parsedPrice.toLocaleString('en-IN')}`,
      location,
      category,
      subcategory: category === 'Vehicles' ? 'Car' : category,
      image_path: categoryImg,
      description: description.trim() || `${title.trim()} available in pristine condition in ${location}. Full paperwork and verified ownership.`,
      seller_id: 'usr_current_user',
      seller_name: 'You (Alex Morgan)',
      is_featured: true,
      specifications,
      status: 'active',
      created_at: new Date().toISOString()
    };

    // 1. Immediately persist locally so all web pages & listing detail page have it
    const saved = savePublishedListing(payload);

    // 2. Submit to Dart Frog REST backend
    try {
      await createListing(payload);
    } catch (err) {
      console.warn('API sync warning:', err);
    }

    setSubmitting(false);
    setCreatedItem(saved);
    setSuccess(true);

    if (onListingCreated) {
      onListingCreated(saved);
    }
  };

  const handleViewListing = () => {
    if (!createdItem) return;
    onClose();
    navigate(`/listings/${createdItem.id}`);
  };

  const handleBrowseCatalog = () => {
    if (!createdItem) return;
    onClose();
    navigate(`/listings?category=${createdItem.category}`);
  };

  return (
    <div className="modal-backdrop" onClick={(e) => {
      if (e.target === e.currentTarget && !submitting) onClose();
    }}>
      <div className="modal-card">
        <div className="modal-header">
          <div className="modal-title-group">
            <Sparkles size={20} className="modal-sparkle" />
            <h3 className="modal-title">
              {success ? 'Ad Published Live!' : 'Post a New Ad'}
            </h3>
          </div>
          <button 
            onClick={onClose} 
            className="modal-close-btn" 
            aria-label="Close modal"
            disabled={submitting}
          >
            <X size={20} />
          </button>
        </div>

        {success && createdItem ? (
          <div className="modal-success-state">
            <div className="success-icon-wrap">
              <CheckCircle2 size={46} className="success-icon" />
            </div>

            <h4 className="success-heading">Your Ad is Now Live!</h4>
            <p className="success-subheading">
              Published at <strong>Position #1</strong> in the Marketplace Feed and live on its dedicated ad page.
            </p>

            {/* Live Listing Preview Card */}
            <div className="live-ad-preview-box">
              <img 
                src={resolveImageUrl(createdItem.image_path)} 
                alt={createdItem.title} 
                className="live-ad-thumb" 
              />
              <div className="live-ad-details">
                <div className="live-ad-tag-row">
                  <span className="live-ad-badge-live">
                    <span className="live-dot" /> LIVE NOW
                  </span>
                  <span className="live-ad-cat">{createdItem.category}</span>
                </div>
                <h5 className="live-ad-title">{createdItem.title}</h5>
                <div className="live-ad-price">{createdItem.formatted_price}</div>
                <div className="live-ad-loc">
                  <MapPin size={12} /> {createdItem.location}
                </div>
              </div>
            </div>

            {/* Direct Navigation Actions */}
            <div className="success-actions-row">
              <button 
                type="button" 
                onClick={handleViewListing} 
                className="btn-success-primary"
              >
                <Eye size={16} />
                View My Ad Now ({countdown}s)
              </button>
              <button 
                type="button" 
                onClick={handleBrowseCatalog} 
                className="btn-success-secondary"
              >
                Browse in Catalog
                <ChevronRight size={16} />
              </button>
            </div>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="modal-form">
            <div className="form-group">
              <label>Ad Title *</label>
              <input 
                type="text" 
                placeholder="e.g. 2023 Hyundai Tucson Signature AWD" 
                value={title} 
                onChange={(e) => setTitle(e.target.value)} 
                required 
                autoFocus
              />
            </div>

            <div className="form-row">
              <div className="form-group">
                <label>Category *</label>
                <select 
                  value={category} 
                  onChange={(e) => setCategory(e.target.value)}
                >
                  <option value="Vehicles">Vehicles</option>
                  <option value="Property">Property</option>
                  <option value="Mobiles">Mobiles</option>
                  <option value="Electronics">Electronics</option>
                  <option value="Furniture">Furniture</option>
                  <option value="Services">Services</option>
                  <option value="Groceries">Groceries</option>
                  <option value="Jobs">Jobs</option>
                </select>
              </div>

              <div className="form-group">
                <label>Price (₹) *</label>
                <input 
                  type="text" 
                  placeholder="e.g. 725000" 
                  value={price} 
                  onChange={(e) => setPrice(e.target.value)} 
                  required 
                />
              </div>
            </div>

            {/* Category-Specific dynamic fields */}
            {category === 'Vehicles' && (
              <div className="form-row">
                <div className="form-group">
                  <label>Fuel Type</label>
                  <select value={fuelType} onChange={(e) => setFuelType(e.target.value)}>
                    <option value="Petrol">Petrol</option>
                    <option value="Diesel">Diesel</option>
                    <option value="Electric">Electric</option>
                    <option value="Hybrid">Hybrid</option>
                  </select>
                </div>

                <div className="form-group">
                  <label>Transmission</label>
                  <select value={transmission} onChange={(e) => setTransmission(e.target.value)}>
                    <option value="Automatic">Automatic</option>
                    <option value="Manual">Manual</option>
                  </select>
                </div>
              </div>
            )}

            {category === 'Property' && (
              <div className="form-group">
                <label>Configuration / Bedrooms</label>
                <select value={propertyBhk} onChange={(e) => setPropertyBhk(e.target.value)}>
                  <option value="1 BHK">1 BHK</option>
                  <option value="2 BHK">2 BHK</option>
                  <option value="3 BHK">3 BHK</option>
                  <option value="4+ BHK">4+ BHK / Luxury Villa</option>
                </select>
              </div>
            )}

            {(category === 'Electronics' || category === 'Mobiles') && (
              <div className="form-group">
                <label>Device Condition</label>
                <select value={deviceCondition} onChange={(e) => setDeviceCondition(e.target.value)}>
                  <option value="Brand New • Sealed">Brand New • Sealed</option>
                  <option value="Like New • Flawless">Like New • Flawless</option>
                  <option value="Gently Used • Mint">Gently Used • Mint</option>
                </select>
              </div>
            )}

            <div className="form-group">
              <label>Location *</label>
              <select value={location} onChange={(e) => setLocation(e.target.value)}>
                <option value="Kochi">Kochi</option>
                <option value="Thiruvananthapuram">Thiruvananthapuram</option>
                <option value="Bengaluru">Bengaluru</option>
                <option value="Kollam">Kollam</option>
                <option value="Kozhikode">Kozhikode</option>
                <option value="Kowdiar">Kowdiar</option>
              </select>
            </div>

            <div className="form-group">
              <label>Detailed Description</label>
              <textarea 
                rows="3" 
                placeholder="Mention condition, service history, documentation, and special highlights..." 
                value={description}
                onChange={(e) => setDescription(e.target.value)}
              />
            </div>

            <div className="modal-actions">
              <button 
                type="button" 
                onClick={onClose} 
                className="btn-secondary"
                disabled={submitting}
              >
                Cancel
              </button>
              <button 
                type="submit" 
                disabled={submitting} 
                className="btn-primary"
              >
                {submitting ? 'Publishing Ad...' : 'Publish Listing'}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
