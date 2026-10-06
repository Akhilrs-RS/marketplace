import React, { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, MapPin, ArrowRight, X } from 'lucide-react';
import './HeroSearch.css';

export default function HeroSearch() {
  const [keyword, setKeyword] = useState('');
  const [location, setLocation] = useState('');
  const [showLocationMenu, setShowLocationMenu] = useState(false);
  const locationMenuRef = useRef(null);
  const navigate = useNavigate();

  const popularLocations = [
    { name: 'All Locations', value: '' },
    { name: 'Thiruvananthapuram', sub: 'Kazhakkoottam, Kowdiar', value: 'Thiruvananthapuram' },
    { name: 'Kochi', sub: 'Kakkanad, Ernakulam, Aluva', value: 'Kochi' },
    { name: 'Kollam', sub: 'City, Chavara', value: 'Kollam' },
    { name: 'Bengaluru', sub: 'HSR Layout, Whitefield', value: 'Bengaluru' },
    { name: 'Remote', sub: 'Work from home / All India', value: 'Remote' },
  ];

  // Close dropdown on click outside
  useEffect(() => {
    function handleClickOutside(event) {
      if (locationMenuRef.current && !locationMenuRef.current.contains(event.target)) {
        setShowLocationMenu(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleSearch = (e) => {
    e.preventDefault();
    const params = new URLSearchParams();
    if (keyword.trim()) params.append('query', keyword.trim());
    if (location.trim()) params.append('location', location.trim());
    navigate(`/listings?${params.toString()}`);
  };

  const popularTags = [
    { label: 'Cars', category: 'Vehicles' },
    { label: 'Property', category: 'Property' },
    { label: 'Jobs', category: 'Jobs' },
    { label: 'Mobiles', category: 'Mobiles' },
    { label: 'Electronics', category: 'Electronics' },
    { label: 'Services', category: 'Services' },
    { label: 'Furniture', category: 'Furniture' },
  ];

  return (
    <section className="figma-hero-section">
      <div className="figma-hero-overlay"></div>

      <div className="container figma-hero-inner">
        {/* Left-aligned Hero Content matching Figma Desktop - 71 */}
        <div className="figma-hero-left-box">
          {/* Headline */}
          <h1 className="figma-hero-title">
            Find What You Need. <br />
            Discover What's Next.
          </h1>

          {/* Subtitle */}
          <p className="figma-hero-description">
            Explore products, properties, vehicles, jobs and services from trusted sellers around you.
          </p>

          {/* Translucent Search Pill Bar matching Figma Desktop - 71 */}
          <form onSubmit={handleSearch} className="figma-glass-search-capsule">
            {/* Search Input */}
            <div className="capsule-field query-field">
              <Search size={16} className="capsule-icon" />
              <input 
                type="text" 
                placeholder="What are you looking for?"
                value={keyword}
                onChange={(e) => setKeyword(e.target.value)}
              />
            </div>

            <div className="capsule-divider"></div>

            {/* Location Input with Popover Menu */}
            <div className="capsule-field location-field" ref={locationMenuRef}>
              <MapPin size={16} className="capsule-icon" />
              <input 
                type="text" 
                placeholder="Location"
                value={location}
                onFocus={() => setShowLocationMenu(true)}
                onChange={(e) => {
                  setLocation(e.target.value);
                  setShowLocationMenu(true);
                }}
              />
              {location && (
                <button
                  type="button"
                  className="hero-clear-loc-btn"
                  onClick={() => setLocation('')}
                  title="Clear location"
                >
                  <X size={13} />
                </button>
              )}

              {showLocationMenu && (
                <div className="hero-location-dropdown">
                  <div className="hero-location-dropdown-header">
                    <span>Popular Cities & Areas</span>
                  </div>
                  <div className="hero-location-dropdown-list">
                    {popularLocations.map((loc) => (
                      <button
                        key={loc.name}
                        type="button"
                        className="hero-location-item"
                        onClick={() => {
                          setLocation(loc.value);
                          setShowLocationMenu(false);
                        }}
                      >
                        <MapPin size={14} className="hero-loc-pin" />
                        <div className="hero-loc-text-col">
                          <span className="hero-loc-name">{loc.name}</span>
                          {loc.sub && <span className="hero-loc-sub">{loc.sub}</span>}
                        </div>
                      </button>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Blue Pill Button: Search → */}
            <button type="submit" className="capsule-blue-search-btn">
              <span>Search</span>
              <ArrowRight size={14} />
            </button>
          </form>

          {/* Popular Tags Row matching Figma Desktop - 71 */}
          <div className="figma-popular-row">
            <span className="popular-label">Popular :</span>
            <div className="popular-tags-group">
              {popularTags.map((tag) => (
                <button
                  key={tag.label}
                  type="button"
                  className="popular-pill-tag"
                  onClick={() => navigate(`/listings?category=${tag.category}`)}
                >
                  {tag.label}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
