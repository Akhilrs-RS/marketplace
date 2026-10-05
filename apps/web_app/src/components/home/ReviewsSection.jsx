import React from 'react';
import { Star, ShieldCheck, Quote } from 'lucide-react';
import './ReviewsSection.css';

export default function ReviewsSection() {
  const reviews = [
    {
      id: 1,
      name: 'Dr. Arjun Nair',
      role: 'Verified Buyer • Hyundai Creta 2022',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      rating: 5,
      comment: 'Found my certified Creta through Apex Motor Hub on Galletrix. Complete transparency on vehicle inspection and zero hassle during RC transfer!',
      location: 'Thiruvananthapuram',
    },
    {
      id: 2,
      name: 'Meera Krishnan',
      role: 'Property Owner • Sold 3BHK',
      avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
      rating: 5,
      comment: 'Posted my apartment in Kowdiar and got 4 genuine site-visit enquiries within 48 hours. The chat and verification features made all the difference.',
      location: 'Kowdiar',
    },
    {
      id: 3,
      name: 'Sandeep Varma',
      role: 'Tech Enthusiast • MacBook M2',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      rating: 5,
      comment: 'Super fast communication and deal closure. The escrow-like verification assured me before meeting the seller in Indiranagar.',
      location: 'Bengaluru',
    },
  ];

  return (
    <section className="reviews-section">
      <div className="container">
        <div className="section-header">
          <div>
            <div className="section-pill">Customer Stories</div>
            <h2 className="section-title">Discover Verified Reviews</h2>
            <p className="section-subtitle">Real stories and feedback from verified buyers and sellers</p>
          </div>
          <div className="rating-overview-badge">
            <Star size={16} fill="#F59E0B" color="#F59E0B" />
            <span className="rating-num">4.9 / 5.0</span>
            <span className="rating-count">(3,400+ Verified Ratings)</span>
          </div>
        </div>

        <div className="reviews-grid">
          {reviews.map((rev) => (
            <div key={rev.id} className="review-card card-hover">
              <div className="review-top-row">
                <div className="stars-row">
                  {[...Array(rev.rating)].map((_, i) => (
                    <Star key={i} size={15} fill="#F59E0B" color="#F59E0B" />
                  ))}
                </div>
                <Quote size={20} className="quote-icon" />
              </div>

              <p className="review-comment">"{rev.comment}"</p>

              <div className="review-user-row">
                <img src={rev.avatar} alt={rev.name} className="review-avatar" />
                <div className="review-meta">
                  <div className="user-name-badge">
                    <span className="user-name">{rev.name}</span>
                    <ShieldCheck size={14} className="verified-icon" />
                  </div>
                  <span className="user-role">{rev.role}</span>
                  <span className="user-loc">{rev.location}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
