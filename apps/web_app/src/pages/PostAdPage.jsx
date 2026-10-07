import React, { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { 
  ChevronLeft, 
  Sparkles, 
  Car, 
  Building2, 
  Smartphone, 
  Laptop, 
  Sofa, 
  ShoppingBasket, 
  Wrench, 
  Briefcase, 
  Plus, 
  Trash2, 
  Upload, 
  Image as ImageIcon, 
  CheckCircle2, 
  MapPin, 
  Tag, 
  Phone, 
  ShieldCheck, 
  Eye, 
  Check, 
  ArrowRight,
  Info,
  Fuel,
  Gauge,
  MessageSquare,
  Share2
} from 'lucide-react';
import { AD_CATEGORIES, POPULAR_LOCATIONS, getCategoryById } from '../data/adCategoriesSchema';
import { savePublishedListing } from '../data/userListingsData';
import { createListing, resolveImageUrl } from '../api/client';
import './PostAdPage.css';

// Icon resolver helper for categories
function CategoryIcon({ name, size = 20, className = '' }) {
  switch (name) {
    case 'Vehicles': return <Car size={size} className={className} />;
    case 'Property': return <Building2 size={size} className={className} />;
    case 'Mobiles': return <Smartphone size={size} className={className} />;
    case 'Electronics': return <Laptop size={size} className={className} />;
    case 'Furniture': return <Sofa size={size} className={className} />;
    case 'Groceries': return <ShoppingBasket size={size} className={className} />;
    case 'Services': return <Wrench size={size} className={className} />;
    case 'Jobs': return <Briefcase size={size} className={className} />;
    default: return <Sparkles size={size} className={className} />;
  }
}

// Format numbers in Indian currency style
function formatIndianCurrency(amount) {
  const num = Number(amount);
  if (isNaN(num) || num <= 0) return '₹ 0';
  if (num >= 10000000) {
    return `₹ ${(num / 10000000).toFixed(2).replace(/\.00$/, '')} Cr`;
  }
  if (num >= 100000) {
    return `₹ ${(num / 100000).toFixed(2).replace(/\.00$/, '')} Lakh`;
  }
  return `₹ ${num.toLocaleString('en-IN')}`;
}

export default function PostAdPage() {
  const navigate = useNavigate();

  // Core Ad Form States
  const [selectedCatId, setSelectedCatId] = useState('Vehicles');
  const [selectedSubcat, setSelectedSubcat] = useState('Cars');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('725000');
  const [priceType, setPriceType] = useState('negotiable'); // 'negotiable' | 'fixed' | 'quote'
  
  // Category-specific specifications
  const [specsData, setSpecsData] = useState({});
  const [customSpecs, setCustomSpecs] = useState([]); // Array of { key: '', value: '' }

  // Media / Photos
  const [selectedPresetImage, setSelectedPresetImage] = useState('/images/h1.png');
  const [uploadedImages, setUploadedImages] = useState([]);
  const [activeCoverImage, setActiveCoverImage] = useState('/images/h1.png');
  const [showPresetPicker, setShowPresetPicker] = useState(false);

  // Location & Seller
  const [city, setCity] = useState('Kochi');
  const [locality, setLocality] = useState('Kakkanad');
  const [sellerName, setSellerName] = useState('Alex Morgan');
  const [sellerPhone, setSellerPhone] = useState('+91 98470 54321');
  const [showPhonePublicly, setShowPhonePublicly] = useState(true);
  const [allowWhatsapp, setAllowWhatsapp] = useState(true);

  // Preview Mode Tab: 'card' (Feed card) | 'detail' (Full page)
  const [previewTab, setPreviewTab] = useState('card');

  // Submission State
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [publishedAd, setPublishedAd] = useState(null);
  const [countdown, setCountdown] = useState(4);

  const currentCategory = getCategoryById(selectedCatId);

  // Sync subcategory & presets when category changes
  useEffect(() => {
    if (currentCategory) {
      setSelectedSubcat(currentCategory.subcategories[0] || 'General');
      const defaultImg = currentCategory.defaultImage || '/images/h1.png';
      setSelectedPresetImage(defaultImg);
      if (uploadedImages.length === 0) {
        setActiveCoverImage(defaultImg);
      }
      
      // Initialize category specs with sensible defaults
      const initialSpecs = {};
      currentCategory.fields.forEach((f) => {
        if (f.options && f.options.length > 0) {
          initialSpecs[f.id] = f.options[0];
        } else if (f.placeholder) {
          initialSpecs[f.id] = '';
        }
      });
      setSpecsData(initialSpecs);
    }
  }, [selectedCatId]);

  // Handle uploaded images from local file picker
  const handleFileUpload = (e) => {
    const files = Array.from(e.target.files || []);
    if (files.length === 0) return;

    const newImageUrls = files.map((file) => URL.createObjectURL(file));
    setUploadedImages((prev) => {
      const combined = [...prev, ...newImageUrls].slice(0, 8);
      setActiveCoverImage(combined[0]);
      return combined;
    });
  };

  const handleRemoveUploadedImage = (indexToRemove) => {
    setUploadedImages((prev) => {
      const filtered = prev.filter((_, idx) => idx !== indexToRemove);
      if (filtered.length > 0) {
        setActiveCoverImage(filtered[0]);
      } else {
        setActiveCoverImage(selectedPresetImage || currentCategory.defaultImage);
      }
      return filtered;
    });
  };

  const handleSelectPreset = (presetPath) => {
    setSelectedPresetImage(presetPath);
    if (uploadedImages.length === 0) {
      setActiveCoverImage(presetPath);
    }
  };

  const handleAddCustomSpec = () => {
    setCustomSpecs((prev) => [...prev, { key: '', value: '' }]);
  };

  const handleUpdateCustomSpec = (index, field, val) => {
    setCustomSpecs((prev) => {
      const updated = [...prev];
      updated[index] = { ...updated[index], [field]: val };
      return updated;
    });
  };

  const handleRemoveCustomSpec = (index) => {
    setCustomSpecs((prev) => prev.filter((_, idx) => idx !== index));
  };

  // Form Validation & Submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!title.trim()) {
      alert('Please enter an ad title.');
      return;
    }
    if (!price && priceType !== 'quote') {
      alert('Please enter a price.');
      return;
    }

    setIsSubmitting(true);
    const parsedPrice = parseFloat(String(price).replace(/[^0-9.]/g, '')) || 0;

    // Merge structured specs and custom specs
    const combinedSpecs = { ...specsData };
    customSpecs.forEach((cs) => {
      if (cs.key.trim() && cs.value.trim()) {
        const normalizedKey = cs.key.trim().toLowerCase().replace(/\s+/g, '_');
        combinedSpecs[normalizedKey] = cs.value.trim();
      }
    });

    // All active images
    const allImages = uploadedImages.length > 0 ? uploadedImages : [selectedPresetImage];
    const fullLocation = locality ? `${locality}, ${city}` : city;

    const catPrefix = (selectedCatId || 'item').toLowerCase().replace(/\s+/g, '_');
    const payload = {
      id: `list_${catPrefix}_${Date.now()}`,
      title: title.trim(),
      price: parsedPrice,
      formatted_price: priceType === 'quote' ? 'Price on Request' : `₹ ${parsedPrice.toLocaleString('en-IN')}`,
      location: fullLocation,
      category: selectedCatId,
      subcategory: selectedSubcat,
      image_path: activeCoverImage,
      images: allImages,
      description: description.trim() || `${title.trim()} available in verified condition in ${fullLocation}. Genuine seller.`,
      seller_id: 'usr_current_user',
      seller_name: sellerName || 'You (Verified Seller)',
      seller_phone: sellerPhone,
      show_phone: showPhonePublicly,
      allow_whatsapp: allowWhatsapp,
      is_featured: true,
      specifications: combinedSpecs,
      negotiable: priceType === 'negotiable',
      price_type: priceType,
      status: 'active',
      created_at: new Date().toISOString()
    };

    // 1. Save to local storage for instant multi-page visibility & reactive sync
    const saved = savePublishedListing(payload);

    // 2. Post to Dart Frog backend API
    try {
      await createListing(payload);
    } catch (err) {
      console.warn('API sync warning:', err);
    }

    setIsSubmitting(false);
    setPublishedAd(saved);
  };

  // Auto redirect countdown on success
  useEffect(() => {
    let timer;
    if (publishedAd && countdown > 0) {
      timer = setTimeout(() => setCountdown((c) => c - 1), 1000);
    } else if (publishedAd && countdown === 0) {
      navigate(`/listings/${publishedAd.id}`);
    }
    return () => clearTimeout(timer);
  }, [publishedAd, countdown, navigate]);

  const parsedNumericPrice = parseFloat(String(price).replace(/[^0-9.]/g, '')) || 0;
  const displayFormattedPrice = priceType === 'quote' 
    ? 'Price on Request' 
    : formatIndianCurrency(parsedNumericPrice);

  return (
    <div className="post-ad-page-container">
      {/* ── Top Bar ── */}
      <header className="post-ad-topbar">
        <div className="post-ad-topbar-inner">
          <Link to="/" className="topbar-back-link">
            <ChevronLeft size={18} />
            <span>Exit to Home</span>
          </Link>

          <div className="topbar-branding">
            <div className="branding-sparkle-pill">
              <Sparkles size={14} className="sparkle-gold" />
              <span>Create Ad</span>
            </div>
            <h1 className="topbar-main-title">Post a Free Ad</h1>
          </div>

          <div className="topbar-badge-pill">
            <ShieldCheck size={14} />
            <span>Verified Marketplace</span>
          </div>
        </div>
      </header>

      {/* ── Main Two-Column View ── */}
      <div className="post-ad-main-layout">
        {/* ── Left Column: Comprehensive Form ── */}
        <div className="post-ad-form-column">
          <form onSubmit={handleSubmit} className="post-ad-form">

            {/* 1. Category Picker */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">01</div>
                <div>
                  <h3 className="section-title">Select Category</h3>
                  <p className="section-sub">Choose the primary classification for your listing</p>
                </div>
              </div>

              <div className="categories-select-grid">
                {AD_CATEGORIES.map((cat) => {
                  const isSelected = selectedCatId === cat.id;
                  return (
                    <button
                      key={cat.id}
                      type="button"
                      className={`cat-select-card ${isSelected ? 'selected' : ''}`}
                      onClick={() => setSelectedCatId(cat.id)}
                    >
                      <div className="cat-card-icon-wrap">
                        <CategoryIcon name={cat.id} size={22} className={isSelected ? 'icon-active' : ''} />
                      </div>
                      <span className="cat-card-name">{cat.name}</span>
                      {isSelected && <span className="cat-active-check"><Check size={12} /></span>}
                    </button>
                  );
                })}
              </div>

              {/* Subcategories horizontal chips */}
              {currentCategory.subcategories && (
                <div className="subcategories-pills-row">
                  <span className="subcat-label">Subcategory:</span>
                  <div className="subcat-pills-list">
                    {currentCategory.subcategories.map((sub) => (
                      <button
                        key={sub}
                        type="button"
                        className={`subcat-pill ${selectedSubcat === sub ? 'active' : ''}`}
                        onClick={() => setSelectedSubcat(sub)}
                      >
                        {sub}
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* 2. Listing Title & Description */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">02</div>
                <div>
                  <h3 className="section-title">Ad Details & Description</h3>
                  <p className="section-sub">A clear, descriptive title helps buyers find your ad faster</p>
                </div>
              </div>

              <div className="field-group">
                <label className="field-label">Ad Title *</label>
                <input 
                  type="text" 
                  className="input-text-main"
                  placeholder={`e.g. ${
                    selectedCatId === 'Vehicles' ? '2023 Hyundai Tucson Signature AWD Automatic' :
                    selectedCatId === 'Property' ? '3BHK Luxury High-Rise Apartment in Kakkanad' :
                    selectedCatId === 'Mobiles' ? 'Apple iPhone 15 Pro Max 256GB Natural Titanium' :
                    selectedCatId === 'Electronics' ? 'Apple MacBook Pro M3 16GB RAM 512GB SSD' :
                    selectedCatId === 'Furniture' ? 'Solid Teak Wood 6-Seater Dining Table Set' :
                    selectedCatId === 'Groceries' ? 'Farm Fresh Organic Vegetable Basket (7kg Combo)' :
                    selectedCatId === 'Services' ? 'Complete 3BHK Home Deep Cleaning & Sanitization' :
                    selectedCatId === 'Jobs' ? 'Senior Full-Stack Engineer (React & Flutter)' :
                    'Premium Item in Mint Condition'
                  }`}
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  required
                />
              </div>

              <div className="field-group">
                <label className="field-label">Description *</label>
                <textarea 
                  rows={4}
                  className="input-textarea-main"
                  placeholder="Detail condition, features, reasons for selling, inclusions, and key highlights..."
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                />
              </div>
            </div>

            {/* 3. Category Dynamic Attributes */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">03</div>
                <div>
                  <h3 className="section-title">{currentCategory.name} Specifications</h3>
                  <p className="section-sub">Key parameters that buyers filter and search by</p>
                </div>
              </div>

              <div className="specs-dynamic-grid">
                {currentCategory.fields.map((field) => (
                  <div key={field.id} className="field-group">
                    <label className="field-label">
                      {field.label} {field.required ? '*' : ''}
                    </label>
                    {field.type === 'select' ? (
                      <select 
                        className="input-select-main"
                        value={specsData[field.id] || (field.options ? field.options[0] : '')}
                        onChange={(e) => setSpecsData({ ...specsData, [field.id]: e.target.value })}
                      >
                        {field.options?.map((opt) => (
                          <option key={opt} value={opt}>{opt}</option>
                        ))}
                      </select>
                    ) : (
                      <input 
                        type="text"
                        className="input-text-main"
                        placeholder={field.placeholder || ''}
                        value={specsData[field.id] || ''}
                        onChange={(e) => setSpecsData({ ...specsData, [field.id]: e.target.value })}
                        required={field.required}
                      />
                    )}
                  </div>
                ))}
              </div>

              {/* Freeform Custom Key-Value Attribute Builder */}
              <div className="custom-specs-block">
                <div className="custom-specs-head">
                  <span className="custom-specs-title">Additional Custom Specifications (Optional)</span>
                  <button 
                    type="button" 
                    className="btn-add-spec"
                    onClick={handleAddCustomSpec}
                  >
                    <Plus size={14} />
                    <span>Add Custom Spec</span>
                  </button>
                </div>

                {customSpecs.map((cs, idx) => (
                  <div key={idx} className="custom-spec-row">
                    <input 
                      type="text" 
                      placeholder="e.g. Color / RAM / Warranty" 
                      className="input-text-sub"
                      value={cs.key}
                      onChange={(e) => handleUpdateCustomSpec(idx, 'key', e.target.value)}
                    />
                    <input 
                      type="text" 
                      placeholder="e.g. Midnight Black / 16GB" 
                      className="input-text-sub"
                      value={cs.value}
                      onChange={(e) => handleUpdateCustomSpec(idx, 'value', e.target.value)}
                    />
                    <button 
                      type="button" 
                      className="btn-del-spec"
                      onClick={() => handleRemoveCustomSpec(idx)}
                      title="Remove specification"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                ))}
              </div>
            </div>

            {/* 4. Media & Photos */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">04</div>
                <div>
                  <h3 className="section-title">Photos & Gallery</h3>
                  <p className="section-sub">Ads with photos get up to 3x more views and buyer trust</p>
                </div>
              </div>

              {/* Upload Zone */}
              <div className="photo-upload-zone">
                <label className="upload-drop-area">
                  <input 
                    type="file" 
                    multiple 
                    accept="image/*" 
                    onChange={handleFileUpload} 
                    style={{ display: 'none' }} 
                  />
                  <div className="upload-icon-circle">
                    <Upload size={22} />
                  </div>
                  <span className="upload-prompt-text">
                    <strong>Click to upload</strong> or drag & drop files here
                  </span>
                  <span className="upload-subtext">Supports PNG, JPG, WebP (up to 8 photos)</span>
                </label>
              </div>

              {/* Uploaded images gallery */}
              {uploadedImages.length > 0 && (
                <div className="uploaded-gallery-strip">
                  {uploadedImages.map((imgUrl, idx) => {
                    const isCover = activeCoverImage === imgUrl;
                    return (
                      <div key={idx} className={`uploaded-thumb-box ${isCover ? 'is-cover' : ''}`}>
                        <img src={imgUrl} alt={`Upload ${idx}`} className="uploaded-thumb-img" />
                        {isCover && <span className="cover-badge">Cover</span>}
                        <div className="thumb-actions-overlay">
                          <button 
                            type="button" 
                            onClick={() => setActiveCoverImage(imgUrl)}
                            className="btn-set-cover"
                            title="Set as cover image"
                          >
                            Set Cover
                          </button>
                          <button 
                            type="button" 
                            onClick={() => handleRemoveUploadedImage(idx)}
                            className="btn-delete-thumb"
                            title="Delete image"
                          >
                            <Trash2 size={13} />
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}

              {/* High-Res Presets Gallery Toggle */}
              <div className="presets-accordion-box">
                <button 
                  type="button" 
                  className="presets-toggle-btn"
                  onClick={() => setShowPresetPicker(!showPresetPicker)}
                >
                  <div className="presets-btn-left">
                    <ImageIcon size={16} />
                    <span>Or Select from {currentCategory.name} Stock Photos</span>
                  </div>
                  <span className="presets-count-badge">
                    {currentCategory.presetImages?.length || 1} available
                  </span>
                </button>

                {showPresetPicker && (
                  <div className="presets-gallery-grid">
                    {currentCategory.presetImages?.map((preset) => {
                      const isSelected = activeCoverImage === preset.path;
                      return (
                        <button
                          key={preset.id}
                          type="button"
                          className={`preset-thumb-card ${isSelected ? 'active-preset' : ''}`}
                          onClick={() => handleSelectPreset(preset.path)}
                        >
                          <img src={preset.path} alt={preset.label} className="preset-img" />
                          <span className="preset-label-tag">{preset.label}</span>
                          {isSelected && <span className="preset-checked"><Check size={12} /></span>}
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
            </div>

            {/* 5. Pricing & Terms */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">05</div>
                <div>
                  <h3 className="section-title">Pricing & Terms</h3>
                  <p className="section-sub">Set an attractive, competitive price for your ad</p>
                </div>
              </div>

              <div className="price-type-tabs">
                <button
                  type="button"
                  className={`price-tab-btn ${priceType === 'negotiable' ? 'active' : ''}`}
                  onClick={() => setPriceType('negotiable')}
                >
                  Negotiable Price
                </button>
                <button
                  type="button"
                  className={`price-tab-btn ${priceType === 'fixed' ? 'active' : ''}`}
                  onClick={() => setPriceType('fixed')}
                >
                  Fixed Price
                </button>
                <button
                  type="button"
                  className={`price-tab-btn ${priceType === 'quote' ? 'active' : ''}`}
                  onClick={() => setPriceType('quote')}
                >
                  Price on Request
                </button>
              </div>

              {priceType !== 'quote' && (
                <div className="price-input-row">
                  <div className="price-field-wrap">
                    <span className="price-currency-symbol">₹</span>
                    <input 
                      type="text" 
                      className="input-price-main"
                      placeholder="e.g. 725000"
                      value={price}
                      onChange={(e) => setPrice(e.target.value)}
                      required
                    />
                  </div>
                  <div className="price-formatted-callout">
                    <span className="callout-label">Formatted Display:</span>
                    <strong className="callout-value">{displayFormattedPrice}</strong>
                  </div>
                </div>
              )}
            </div>

            {/* 6. Location & Seller Contact */}
            <div className="form-card-section">
              <div className="section-head-row">
                <div className="section-step-num">06</div>
                <div>
                  <h3 className="section-title">Location & Contact</h3>
                  <p className="section-sub">Where the item or service is located and how buyers reach you</p>
                </div>
              </div>

              <div className="location-row-inputs">
                <div className="field-group">
                  <label className="field-label">City / Region *</label>
                  <select 
                    className="input-select-main"
                    value={city}
                    onChange={(e) => setCity(e.target.value)}
                  >
                    {POPULAR_LOCATIONS.map((loc) => (
                      <option key={loc} value={loc}>{loc}</option>
                    ))}
                  </select>
                </div>

                <div className="field-group">
                  <label className="field-label">Locality / Area / Landmark</label>
                  <input 
                    type="text" 
                    className="input-text-main"
                    placeholder="e.g. Kakkanad Infopark / Kowdiar / Indiranagar"
                    value={locality}
                    onChange={(e) => setLocality(e.target.value)}
                  />
                </div>
              </div>

              <div className="seller-contact-inputs">
                <div className="field-group">
                  <label className="field-label">Seller Name *</label>
                  <input 
                    type="text" 
                    className="input-text-main"
                    value={sellerName}
                    onChange={(e) => setSellerName(e.target.value)}
                    required
                  />
                </div>

                <div className="field-group">
                  <label className="field-label">Phone Number *</label>
                  <input 
                    type="text" 
                    className="input-text-main"
                    value={sellerPhone}
                    onChange={(e) => setSellerPhone(e.target.value)}
                    required
                  />
                </div>
              </div>

              <div className="privacy-toggles-list">
                <label className="toggle-checkbox-row">
                  <input 
                    type="checkbox" 
                    checked={showPhonePublicly} 
                    onChange={(e) => setShowPhonePublicly(e.target.checked)} 
                  />
                  <span>Display phone number publicly on the ad for calls</span>
                </label>
                <label className="toggle-checkbox-row">
                  <input 
                    type="checkbox" 
                    checked={allowWhatsapp} 
                    onChange={(e) => setAllowWhatsapp(e.target.checked)} 
                  />
                  <span>Enable direct WhatsApp chat inquiry button</span>
                </label>
              </div>
            </div>

            {/* Bottom Form Actions */}
            <div className="form-submit-actions-box">
              <button 
                type="button" 
                onClick={() => navigate('/')} 
                className="btn-cancel-post"
              >
                Cancel
              </button>
              <button 
                type="submit" 
                disabled={isSubmitting}
                className="btn-publish-post"
              >
                {isSubmitting ? (
                  <span>Publishing Ad...</span>
                ) : (
                  <>
                    <Sparkles size={18} />
                    <span>Publish Ad Live</span>
                  </>
                )}
              </button>
            </div>

          </form>
        </div>

        {/* ── Right Column: Sticky Live Interactive Preview ── */}
        <aside className="post-ad-preview-column">
          <div className="preview-sticky-card">
            
            <div className="preview-header-bar">
              <div className="preview-title-group">
                <Eye size={16} className="preview-eye-icon" />
                <span className="preview-head-title">Real-Time Preview</span>
              </div>
              <div className="preview-live-indicator">
                <span className="live-pulsing-dot" />
                <span>Live View</span>
              </div>
            </div>

            {/* Preview Viewport Switcher */}
            <div className="preview-tabs-row">
              <button 
                type="button" 
                className={`preview-tab-pill ${previewTab === 'card' ? 'active' : ''}`}
                onClick={() => setPreviewTab('card')}
              >
                Feed Card View
              </button>
              <button 
                type="button" 
                className={`preview-tab-pill ${previewTab === 'detail' ? 'active' : ''}`}
                onClick={() => setPreviewTab('detail')}
              >
                Full Ad Page View
              </button>
            </div>

            {/* Preview Body */}
            <div className="preview-viewport-content">
              {previewTab === 'card' ? (
                /* ── TAB 1: Catalog Feed Card Preview ── */
                <div className="catalog-preview-card">
                  <div className="preview-card-img-wrap">
                    <img 
                      src={resolveImageUrl(activeCoverImage)} 
                      alt={title || 'Preview Ad'} 
                      className="preview-card-img" 
                    />
                    <div className="preview-card-badges">
                      <span className="badge-just-posted">
                        <Sparkles size={10} /> Just Posted
                      </span>
                      <span className="badge-featured">Featured</span>
                      <span className="badge-verified">Verified</span>
                    </div>
                  </div>

                  <div className="preview-card-info">
                    <div className="preview-price-row">
                      <span className="preview-bold-price">{displayFormattedPrice}</span>
                      <span className="preview-cat-badge">{selectedCatId}</span>
                    </div>

                    <h4 className="preview-ad-title">
                      {title.trim() || 'Your Ad Title Will Appear Here'}
                    </h4>

                    {/* Quick Specs Pills */}
                    <div className="preview-specs-chips">
                      {specsData.fuel_type && (
                        <span className="preview-chip">
                          <Fuel size={11} /> {specsData.fuel_type}
                        </span>
                      )}
                      {specsData.transmission && (
                        <span className="preview-chip">
                          <Gauge size={11} /> {specsData.transmission}
                        </span>
                      )}
                      {specsData.bedrooms && (
                        <span className="preview-chip">
                          {specsData.bedrooms}
                        </span>
                      )}
                      {specsData.storage && (
                        <span className="preview-chip">
                          {specsData.storage}
                        </span>
                      )}
                      {specsData.work_mode && (
                        <span className="preview-chip">
                          {specsData.work_mode}
                        </span>
                      )}
                      {specsData.material && (
                        <span className="preview-chip">
                          {specsData.material}
                        </span>
                      )}
                    </div>

                    <div className="preview-card-footer">
                      <span className="preview-loc-text">
                        <MapPin size={12} /> {locality ? `${locality}, ${city}` : city}
                      </span>
                      <span className="preview-time-text">Just now</span>
                    </div>
                  </div>
                </div>
              ) : (
                /* ── TAB 2: Detail Page Hero & Price Card Preview ── */
                <div className="detail-preview-panel">
                  <div className="detail-preview-hero-img-box">
                    <img 
                      src={resolveImageUrl(activeCoverImage)} 
                      alt={title} 
                      className="detail-preview-hero-img" 
                    />
                  </div>

                  <div className="detail-preview-pricing-card">
                    <div className="detail-preview-price-row">
                      <span className="detail-preview-amount">{displayFormattedPrice}</span>
                      <span className="detail-preview-neg-tag">
                        {priceType === 'negotiable' ? 'Negotiable' : priceType === 'fixed' ? 'Fixed Price' : 'Quote'}
                      </span>
                    </div>

                    <h3 className="detail-preview-title">
                      {title.trim() || 'Listing Title'}
                    </h3>

                    <div className="detail-preview-meta">
                      <span><MapPin size={12} /> {locality ? `${locality}, ${city}` : city}</span>
                      <span>• Just now • 1 view</span>
                    </div>

                    <div className="detail-preview-seller-card">
                      <div className="seller-avatar-circle">
                        {(sellerName || 'Y')[0].toUpperCase()}
                      </div>
                      <div className="seller-avatar-info">
                        <strong>{sellerName || 'You (Verified Seller)'}</strong>
                        <span>Individual Seller (Just Posted)</span>
                      </div>
                    </div>

                    <div className="detail-preview-btn-mock">
                      <MessageSquare size={14} />
                      <span>Chat with Seller</span>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Seller Advisory Box */}
            <div className="preview-seller-tips-box">
              <div className="tips-icon-wrap">
                <Info size={16} />
              </div>
              <p className="tips-text">
                Your ad will immediately be placed at <strong>Position #1</strong> in the Marketplace Feed and accessible via permalink with seller contact tools.
              </p>
            </div>

          </div>
        </aside>
      </div>

      {/* ── Success Celebration Modal ── */}
      {publishedAd && (
        <div className="modal-backdrop">
          <div className="modal-card post-success-card">
            <div className="success-confetti-circle">
              <CheckCircle2 size={50} className="success-icon" />
            </div>

            <h2 className="success-headline">🎉 Ad Published Live!</h2>
            <p className="success-sub">
              Your ad has been verified and published at <strong>Position #1</strong> in the marketplace catalog.
            </p>

            {/* Summary preview of newly published ad */}
            <div className="live-ad-preview-box">
              <img 
                src={resolveImageUrl(publishedAd.image_path)} 
                alt={publishedAd.title} 
                className="live-ad-thumb" 
              />
              <div className="live-ad-details">
                <div className="live-ad-tag-row">
                  <span className="live-ad-badge-live">
                    <span className="live-dot" /> LIVE NOW
                  </span>
                  <span className="live-ad-cat">{publishedAd.category}</span>
                </div>
                <h5 className="live-ad-title">{publishedAd.title}</h5>
                <div className="live-ad-price">{publishedAd.formatted_price}</div>
                <div className="live-ad-loc">
                  <MapPin size={12} /> {publishedAd.location}
                </div>
              </div>
            </div>

            <div className="success-actions-row">
              <button 
                type="button" 
                onClick={() => navigate(`/listings/${publishedAd.id}`)}
                className="btn-success-primary"
              >
                <Eye size={16} />
                View My Live Ad ({countdown}s)
              </button>
              <button 
                type="button" 
                onClick={() => navigate(`/listings?category=${publishedAd.category}`)}
                className="btn-success-secondary"
              >
                Browse in Catalog
                <ArrowRight size={16} />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
