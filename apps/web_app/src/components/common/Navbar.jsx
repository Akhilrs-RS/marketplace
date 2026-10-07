import React, { useState, useEffect, useRef } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Search, Heart, MessageSquare, Menu, X, Building2, MapPin, ChevronDown } from 'lucide-react';
import './Navbar.css';

export default function Navbar({ onOpenPostAd, favoritesCount = 0, unreadMessagesCount = 2 }) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [navLocMenuOpen, setNavLocMenuOpen] = useState(false);
  const navLocRef = useRef(null);
  const location = useLocation();
  const navigate = useNavigate();

  const currentNavLocation = new URLSearchParams(location.search).get('location') || '';

  const quickCities = [
    { label: 'All Locations', value: '' },
    { label: 'Thiruvananthapuram', value: 'Thiruvananthapuram' },
    { label: 'Kochi', value: 'Kochi' },
    { label: 'Kollam', value: 'Kollam' },
    { label: 'Bengaluru', value: 'Bengaluru' },
    { label: 'Remote', value: 'Remote' },
  ];

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 40) {
        setScrolled(true);
      } else {
        setScrolled(false);
      }
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    function handleOutside(e) {
      if (navLocRef.current && !navLocRef.current.contains(e.target)) {
        setNavLocMenuOpen(false);
      }
    }
    document.addEventListener('mousedown', handleOutside);
    return () => document.removeEventListener('mousedown', handleOutside);
  }, []);

  const handleSelectNavCity = (cityVal) => {
    setNavLocMenuOpen(false);
    setMobileMenuOpen(false);
    const params = new URLSearchParams(location.search);
    if (!cityVal) {
      params.delete('location');
    } else {
      params.set('location', cityVal);
    }
    const targetPath = location.pathname.startsWith('/shops') ? '/shops' : '/listings';
    navigate(`${targetPath}?${params.toString()}`);
  };

  const isSolidPage = location.pathname.startsWith('/messages');

  return (
    <header className={`navbar-root ${scrolled || isSolidPage ? 'navbar-scrolled' : 'navbar-transparent'}`}>
      <div className="container navbar-container">
        {/* Brand Logo & Location Pill */}
        <div className="figma-navbar-left-group">
          <Link to="/" className="figma-navbar-brand">
            <span className="figma-brand-text">Marketplace</span>
          </Link>

          {/* Global Location Selector Pill */}
          <div className="figma-nav-location-picker" ref={navLocRef}>
            <button
              type="button"
              className={`figma-nav-loc-btn ${currentNavLocation ? 'has-location' : ''}`}
              onClick={() => setNavLocMenuOpen(!navLocMenuOpen)}
              title="Select browsing city"
            >
              <MapPin size={13} className="nav-loc-icon" />
              <span className="nav-loc-label">{currentNavLocation || 'All Locations'}</span>
              <ChevronDown size={12} className={`nav-loc-chevron ${navLocMenuOpen ? 'open' : ''}`} />
            </button>

            {navLocMenuOpen && (
              <div className="figma-nav-loc-popover">
                <div className="nav-loc-popover-title">
                  <MapPin size={13} />
                  <span>Choose Location</span>
                </div>
                <div className="nav-loc-popover-list">
                  {quickCities.map((c) => (
                    <button
                      key={c.label}
                      type="button"
                      className={`nav-loc-popover-item ${(currentNavLocation === c.value || (!currentNavLocation && !c.value)) ? 'active' : ''}`}
                      onClick={() => handleSelectNavCity(c.value)}
                    >
                      <span>{c.label}</span>
                      {(currentNavLocation === c.value || (!currentNavLocation && !c.value)) && (
                        <span className="nav-loc-check-dot" />
                      )}
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Desktop Navigation Links matching Figma Desktop - 71 */}
        <nav className="figma-desktop-nav">
          <Link to="/listings" className="figma-nav-item">
            <Search size={16} className="nav-item-icon" />
            <span>Browse</span>
          </Link>

          <Link to="/shops" className="figma-nav-item">
            <Building2 size={16} className="nav-item-icon" />
            <span>Shops</span>
          </Link>

          <Link to="/listings?favorites=true" className="figma-nav-item">
            <Heart size={16} className="nav-item-icon" />
            <span>Favorites</span>
            {favoritesCount > 0 && <span className="nav-fav-pill">{favoritesCount}</span>}
          </Link>

          <Link to="/messages" className="figma-nav-item">
            <MessageSquare size={16} className="nav-item-icon" />
            <span>Message</span>
            {unreadMessagesCount > 0 && <span className="nav-fav-pill">{unreadMessagesCount}</span>}
          </Link>

          {/* Black Pill Button: "Post an Ad" linking to full page /post-ad */}
          <Link 
            to="/post-ad"
            className="figma-post-btn-black"
          >
            Post an Ad
          </Link>
        </nav>

        {/* Mobile Toggle */}
        <button 
          className="mobile-toggle"
          onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          aria-label="Toggle menu"
        >
          {mobileMenuOpen ? <X size={24} color="#ffffff" /> : <Menu size={24} color="#ffffff" />}
        </button>
      </div>

      {/* Mobile Menu Drawer */}
      {mobileMenuOpen && (
        <div className="figma-mobile-drawer">
          {/* Mobile Location Selector */}
          <div className="mobile-loc-section">
            <div className="mobile-loc-label-row">
              <MapPin size={14} />
              <span>Browsing Location:</span>
            </div>
            <div className="mobile-loc-pills-row">
              {quickCities.map((c) => (
                <button
                  key={c.label}
                  type="button"
                  className={`mobile-loc-pill ${(currentNavLocation === c.value || (!currentNavLocation && !c.value)) ? 'active' : ''}`}
                  onClick={() => handleSelectNavCity(c.value)}
                >
                  {c.label}
                </button>
              ))}
            </div>
          </div>

          <Link to="/listings" onClick={() => setMobileMenuOpen(false)}>
            <Search size={16} />
            <span>Browse</span>
          </Link>
          <Link to="/listings?favorites=true" onClick={() => setMobileMenuOpen(false)}>
            <Heart size={16} />
            <span>Favorites</span>
          </Link>
          <Link to="/shops" onClick={() => setMobileMenuOpen(false)}>
            <Building2 size={16} />
            <span>Vehicle Shops</span>
          </Link>
          <Link to="/messages" onClick={() => setMobileMenuOpen(false)}>
            <MessageSquare size={16} />
            <span>Messages</span>
            {unreadMessagesCount > 0 && <span className="nav-fav-pill" style={{ marginLeft: 'auto' }}>{unreadMessagesCount}</span>}
          </Link>
          <Link 
            to="/post-ad"
            onClick={() => setMobileMenuOpen(false)}
            className="figma-post-btn-black"
            style={{ width: '100%', marginTop: '10px', textAlign: 'center' }}
          >
            Post an Ad
          </Link>
        </div>
      )}
    </header>
  );
}
