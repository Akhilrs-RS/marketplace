import React, { useState, useEffect, useRef } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { Search, Heart, MessageSquare, Menu, X, Building2, ChevronDown, User, PlusCircle, LogOut, Package, ShieldCheck, ArrowLeft } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import './Navbar.css';

export default function Navbar({ onOpenPostAd, favoritesCount = 0, unreadMessagesCount = 2 }) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const userMenuRef = useRef(null);

  const { currentUser, isLoggedIn, logout, openLoginModal } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

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

  // Close user dropdown on outside click
  useEffect(() => {
    function handleOutside(e) {
      if (userMenuRef.current && !userMenuRef.current.contains(e.target)) {
        setUserMenuOpen(false);
      }
    }
    document.addEventListener('mousedown', handleOutside);
    return () => document.removeEventListener('mousedown', handleOutside);
  }, []);

  // On dedicated, distraction-free flows like /post-ad, do not render global navbar
  if (location.pathname === '/post-ad') {
    return null;
  }

  const isAdminPage = location.pathname.startsWith('/admin');
  const isSolidPage = location.pathname.startsWith('/messages') || location.pathname.startsWith('/my-ads') || isAdminPage;

  return (
    <header className={`navbar-root ${scrolled || isSolidPage ? 'navbar-scrolled' : 'navbar-transparent'}`}>
      <div className="container navbar-container">
        {/* Brand Logo matching reference screenshot: All in One Today */}
        <div className="figma-navbar-left-group">
          <Link to="/" className="figma-navbar-brand">
            <span className="figma-brand-text">All in One Today</span>
          </Link>
          {isAdminPage && (
            <div className="figma-admin-nav-tag">
              <ShieldCheck size={14} />
              <span>Admin Portal</span>
            </div>
          )}
        </div>

        {/* Navigation Links: Admin variant vs Marketplace Buyer variant */}
        {isAdminPage ? (
          <nav className="figma-desktop-nav">
            <Link to="/" className="btn-back-marketplace">
              <ArrowLeft size={16} />
              <span>Back to Marketplace</span>
            </Link>

            {!isLoggedIn ? (
              <button
                type="button"
                className="figma-nav-login-btn"
                onClick={openLoginModal}
              >
                Login
              </button>
            ) : (
              <div className="figma-nav-user-dropdown" ref={userMenuRef}>
                <button
                  type="button"
                  className="figma-nav-user-pill"
                  onClick={() => setUserMenuOpen(!userMenuOpen)}
                >
                  <div className="nav-user-avatar">
                    {currentUser?.name ? currentUser.name[0].toUpperCase() : 'A'}
                  </div>
                  <span className="nav-user-name">{currentUser?.name || 'Administrator'}</span>
                  <ChevronDown size={14} className={`nav-user-chevron ${userMenuOpen ? 'open' : ''}`} />
                </button>

                {userMenuOpen && (
                  <div className="figma-user-popover">
                    <div className="user-popover-header">
                      <strong className="user-popover-name">{currentUser?.name || 'Administrator'}</strong>
                      <span className="user-popover-role">Admin Access</span>
                    </div>

                    <div className="user-popover-menu">
                      <Link
                        to="/"
                        className="user-popover-item"
                        onClick={() => setUserMenuOpen(false)}
                      >
                        <Package size={15} />
                        <span>Marketplace Home</span>
                      </Link>

                      <Link
                        to="/my-ads"
                        className="user-popover-item"
                        onClick={() => setUserMenuOpen(false)}
                      >
                        <Package size={15} />
                        <span>My Personal Ads</span>
                      </Link>

                      <div className="user-popover-divider" />

                      <button
                        type="button"
                        className="user-popover-item logout-item"
                        onClick={() => {
                          setUserMenuOpen(false);
                          logout();
                        }}
                      >
                        <LogOut size={15} />
                        <span>Log Out</span>
                      </button>
                    </div>
                  </div>
                )}
              </div>
            )}
          </nav>
        ) : (
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

            <Link to="/admin" className="figma-nav-item">
              <ShieldCheck size={16} className="nav-item-icon" />
              <span>Admin</span>
            </Link>

            {!isLoggedIn ? (
              <button
                type="button"
                className="figma-nav-login-btn"
                onClick={openLoginModal}
              >
                Login
              </button>
            ) : (
              <div className="figma-nav-user-dropdown" ref={userMenuRef}>
                <button
                  type="button"
                  className="figma-nav-user-pill"
                  onClick={() => setUserMenuOpen(!userMenuOpen)}
                >
                  <div className="nav-user-avatar">
                    {currentUser?.name ? currentUser.name[0].toUpperCase() : 'U'}
                  </div>
                  <span className="nav-user-name">{currentUser?.name || 'My Account'}</span>
                  <ChevronDown size={14} className={`nav-user-chevron ${userMenuOpen ? 'open' : ''}`} />
                </button>

              {userMenuOpen && (
                <div className="figma-user-popover">
                  <div className="user-popover-header">
                    <strong className="user-popover-name">{currentUser?.name}</strong>
                    <span className="user-popover-role">{currentUser?.role || 'Verified User'}</span>
                  </div>

                  <div className="user-popover-menu">
                    <Link
                      to="/my-ads"
                      className="user-popover-item active-highlight"
                      onClick={() => setUserMenuOpen(false)}
                    >
                      <Package size={15} />
                      <span>My Ads (View Existing)</span>
                    </Link>

                    <Link
                      to="/post-ad"
                      className="user-popover-item"
                      onClick={() => setUserMenuOpen(false)}
                    >
                      <PlusCircle size={15} />
                      <span>Post a New Ad</span>
                    </Link>

                    <Link
                      to="/messages"
                      className="user-popover-item"
                      onClick={() => setUserMenuOpen(false)}
                    >
                      <MessageSquare size={15} />
                      <span>Messages</span>
                    </Link>

                    <Link
                      to="/admin"
                      className="user-popover-item"
                      onClick={() => setUserMenuOpen(false)}
                    >
                      <ShieldCheck size={15} />
                      <span>Admin Management</span>
                    </Link>

                    <Link
                      to="/listings?favorites=true"
                      className="user-popover-item"
                      onClick={() => setUserMenuOpen(false)}
                    >
                      <Heart size={15} />
                      <span>Saved Favorites</span>
                    </Link>

                    <div className="user-popover-divider" />

                    <button
                      type="button"
                      className="user-popover-item logout-item"
                      onClick={() => {
                        setUserMenuOpen(false);
                        logout();
                      }}
                    >
                      <LogOut size={15} />
                      <span>Log Out</span>
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}
        </nav>
      )}

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
          <Link to="/listings" onClick={() => setMobileMenuOpen(false)}>
            <Search size={16} />
            <span>Browse</span>
          </Link>
          <Link to="/shops" onClick={() => setMobileMenuOpen(false)}>
            <Building2 size={16} />
            <span>Shops</span>
          </Link>
          <Link to="/listings?favorites=true" onClick={() => setMobileMenuOpen(false)}>
            <Heart size={16} />
            <span>Favorites</span>
            {favoritesCount > 0 && <span className="nav-fav-pill" style={{ marginLeft: 'auto' }}>{favoritesCount}</span>}
          </Link>
          <Link to="/messages" onClick={() => setMobileMenuOpen(false)}>
            <MessageSquare size={16} />
            <span>Message</span>
            {unreadMessagesCount > 0 && <span className="nav-fav-pill" style={{ marginLeft: 'auto' }}>{unreadMessagesCount}</span>}
          </Link>
          {isAdminPage ? (
            <Link to="/" onClick={() => setMobileMenuOpen(false)} style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#c4b5fd', fontWeight: '600' }}>
              <ArrowLeft size={16} />
              <span>Back to Marketplace</span>
            </Link>
          ) : (
            <Link to="/admin" onClick={() => setMobileMenuOpen(false)}>
              <ShieldCheck size={16} />
              <span>Admin Management</span>
            </Link>
          )}

          {!isLoggedIn ? (
            <button
              type="button"
              className="mobile-login-btn"
              onClick={() => {
                setMobileMenuOpen(false);
                openLoginModal();
              }}
            >
              <User size={16} />
              <span>Login to Account</span>
            </button>
          ) : (
            <div className="mobile-user-actions">
              <div className="mobile-user-info">
                <div className="nav-user-avatar">
                  {currentUser?.name ? currentUser.name[0].toUpperCase() : 'U'}
                </div>
                <span>{currentUser?.name}</span>
              </div>
              <Link to="/my-ads" onClick={() => setMobileMenuOpen(false)} className="mobile-user-link">
                <Package size={16} />
                <span>My Ads (View Existing)</span>
              </Link>
              <Link to="/post-ad" onClick={() => setMobileMenuOpen(false)} className="mobile-user-link">
                <PlusCircle size={16} />
                <span>Post a New Ad</span>
              </Link>
              <button
                type="button"
                className="mobile-logout-btn"
                onClick={() => {
                  setMobileMenuOpen(false);
                  logout();
                }}
              >
                <LogOut size={16} />
                <span>Log Out</span>
              </button>
            </div>
          )}
        </div>
      )}
    </header>
  );
}
