import React, { useState } from 'react';
import { X, Sparkles, User, Mail, Lock, Phone, ArrowRight, ShieldCheck, CheckCircle2 } from 'lucide-react';
import { useAuth, DEMO_USER } from '../../context/AuthContext';
import './LoginModal.css';

export default function LoginModal({ isOpen, onClose, onLoginSuccess }) {
  const { login } = useAuth();
  const [tab, setTab] = useState('login'); // 'login' | 'signup'
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [successMsg, setSuccessMsg] = useState(false);

  if (!isOpen) return null;

  const handleQuickDemoLogin = () => {
    login(DEMO_USER);
    setSuccessMsg(true);
    setTimeout(() => {
      setSuccessMsg(false);
      if (onLoginSuccess) onLoginSuccess(DEMO_USER);
      if (onClose) onClose();
    }, 700);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!identifier) {
      alert('Please enter your email or phone number.');
      return;
    }

    const customUser = {
      id: `usr_${Date.now()}`,
      name: name.trim() || identifier.split('@')[0] || 'Marketplace User',
      email: identifier.includes('@') ? identifier.trim() : `${identifier}@galletrix.com`,
      phone: phone || '+91 98470 54321',
      role: 'Verified Seller',
      avatar: '/images/h3.png',
      memberSince: 'October 2024',
      activeAdsCount: 1,
    };

    login(customUser);
    setSuccessMsg(true);
    setTimeout(() => {
      setSuccessMsg(false);
      if (onLoginSuccess) onLoginSuccess(customUser);
      if (onClose) onClose();
    }, 700);
  };

  return (
    <div className="login-modal-backdrop" onClick={(e) => {
      if (e.target === e.currentTarget) onClose();
    }}>
      <div className="login-modal-card">
        {/* Close Button */}
        <button type="button" className="login-modal-close" onClick={onClose}>
          <X size={18} />
        </button>

        {successMsg ? (
          <div className="login-success-state">
            <div className="login-success-icon-wrap">
              <CheckCircle2 size={54} color="#10B981" />
            </div>
            <h3 className="login-success-title">Welcome Back!</h3>
            <p className="login-success-sub">Logged in successfully. Loading your existing listings...</p>
          </div>
        ) : (
          <>
            {/* Header */}
            <div className="login-modal-header">
              <span className="login-brand-title">All in One Today</span>
              <h2 className="login-heading">
                {tab === 'login' ? 'Sign in to Your Account' : 'Create an Account'}
              </h2>
              <p className="login-subheading">
                {tab === 'login'
                  ? 'Access your existing ads, active chats, and favorite listings.'
                  : 'Join thousands of buyers and sellers across your city.'}
              </p>
            </div>

            {/* Quick 1-Click Demo Login Banner */}
            <div className="login-demo-box">
              <div className="login-demo-info">
                <span className="login-demo-badge">
                  <Sparkles size={12} /> Instant Access
                </span>
                <strong className="login-demo-name">Alex Morgan (Verified Seller)</strong>
                <span className="login-demo-desc">Includes existing "apple iphone" and tech listings</span>
              </div>
              <button 
                type="button" 
                className="btn-demo-quick-login"
                onClick={handleQuickDemoLogin}
              >
                <span>1-Click Sign In</span>
                <ArrowRight size={14} />
              </button>
            </div>

            <div className="login-divider">
              <span>Or sign in with email</span>
            </div>

            {/* Auth Form */}
            <form onSubmit={handleSubmit} className="login-form">
              {tab === 'signup' && (
                <div className="login-field-group">
                  <label>Full Name</label>
                  <div className="login-input-wrap">
                    <User size={16} className="login-input-icon" />
                    <input 
                      type="text" 
                      placeholder="e.g. Alex Morgan"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      required
                    />
                  </div>
                </div>
              )}

              <div className="login-field-group">
                <label>Email Address or Phone</label>
                <div className="login-input-wrap">
                  <Mail size={16} className="login-input-icon" />
                  <input 
                    type="text" 
                    placeholder="name@example.com or phone"
                    value={identifier}
                    onChange={(e) => setIdentifier(e.target.value)}
                    required
                  />
                </div>
              </div>

              <div className="login-field-group">
                <label>Password</label>
                <div className="login-input-wrap">
                  <Lock size={16} className="login-input-icon" />
                  <input 
                    type="password" 
                    placeholder="••••••••"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
              </div>

              <button type="submit" className="login-submit-btn">
                <span>{tab === 'login' ? 'Sign In' : 'Create Account'}</span>
                <ArrowRight size={15} />
              </button>
            </form>

            {/* Footer switcher */}
            <div className="login-footer">
              {tab === 'login' ? (
                <p>
                  Don't have an account?{' '}
                  <button type="button" className="login-link-btn" onClick={() => setTab('signup')}>
                    Register here
                  </button>
                </p>
              ) : (
                <p>
                  Already registered?{' '}
                  <button type="button" className="login-link-btn" onClick={() => setTab('login')}>
                    Sign In
                  </button>
                </p>
              )}
            </div>
          </>
        )}
      </div>
    </div>
  );
}
