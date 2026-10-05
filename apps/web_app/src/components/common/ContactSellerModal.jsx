import React, { useState } from 'react';
import { X, Send, Calendar, Phone, CheckCircle, ShieldCheck } from 'lucide-react';
import { sendInquiry } from '../../api/client';
import './ContactSellerModal.css';

export default function ContactSellerModal({ isOpen, onClose, listing }) {
  const [name, setName] = useState('Alex Morgan');
  const [phone, setPhone] = useState('+91 98470 12345');
  const [message, setMessage] = useState(
    listing ? `Hi, I am interested in your ${listing.title}. Is it available for an inspection/test drive?` : ''
  );
  const [preferredDate, setPreferredDate] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [sent, setSent] = useState(false);

  if (!isOpen || !listing) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    await sendInquiry({
      listing_id: listing.id,
      item_tag: listing.title,
      sender_name: name,
      phone,
      message,
      preferred_date: preferredDate
    });
    setSubmitting(false);
    setSent(true);

    setTimeout(() => {
      setSent(false);
      onClose();
    }, 1800);
  };

  return (
    <div className="modal-backdrop">
      <div className="modal-card">
        <div className="modal-header">
          <div>
            <h3 className="modal-title">Contact Seller & Book Drive</h3>
            <p className="modal-sub">Direct message to {listing.seller_name || 'Hyundai Auto Hub'}</p>
          </div>
          <button onClick={onClose} className="modal-close-btn" aria-label="Close modal">
            <X size={20} />
          </button>
        </div>

        {sent ? (
          <div className="modal-success-state">
            <CheckCircle size={48} className="success-icon" />
            <h4>Message Sent to Seller!</h4>
            <p>The dealer will call or message you back shortly.</p>
          </div>
        ) : (
          <form onSubmit={handleSubmit} className="modal-form">
            <div className="target-listing-preview">
              <span className="preview-label">Inquiring about:</span>
              <span className="preview-title">{listing.title} ({listing.formatted_price || listing.price})</span>
            </div>

            <div className="form-row">
              <div className="form-group">
                <label>Your Name *</label>
                <input 
                  type="text" 
                  value={name} 
                  onChange={(e) => setName(e.target.value)} 
                  required 
                />
              </div>

              <div className="form-group">
                <label>Your Phone *</label>
                <input 
                  type="tel" 
                  value={phone} 
                  onChange={(e) => setPhone(e.target.value)} 
                  required 
                />
              </div>
            </div>

            <div className="form-group">
              <label>Preferred Test Drive Date (Optional)</label>
              <input 
                type="date" 
                value={preferredDate} 
                onChange={(e) => setPreferredDate(e.target.value)} 
              />
            </div>

            <div className="form-group">
              <label>Message *</label>
              <textarea 
                rows="3" 
                value={message} 
                onChange={(e) => setMessage(e.target.value)} 
                required 
              />
            </div>

            <div className="verified-buyer-guarantee">
              <ShieldCheck size={16} className="guarantee-icon" />
              <span>Your phone number is shared only with verified dealers. Zero spam.</span>
            </div>

            <div className="modal-actions">
              <button type="button" onClick={onClose} className="btn-secondary">
                Cancel
              </button>
              <button type="submit" disabled={submitting} className="btn-primary">
                <Send size={16} />
                <span>{submitting ? 'Sending...' : 'Send Inquiry'}</span>
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}
