import React from 'react';
import { ArrowRight, Sparkles } from 'lucide-react';
import './SellCtaBanner.css';

export default function SellCtaBanner({ onOpenPostAd }) {
  return (
    <section className="sell-cta-section-figma">
      <div className="container sell-cta-container">
        <div className="sell-cta-card-orange">
          <div className="cta-top-icon-wrap">
            <Sparkles size={22} className="cta-top-icon" />
          </div>

          <h2 className="cta-headline-bold">Have something to sell?</h2>
          <p className="cta-subheadline-clean">
            Create your listing and reach people looking for it.
          </p>

          <div className="cta-actions-row">
            <button 
              type="button"
              onClick={onOpenPostAd}
              className="cta-pill-btn-white"
            >
              <span>Post a listing</span>
              <ArrowRight size={14} />
            </button>

            <a 
              href="#how-it-works"
              className="cta-text-link-white"
            >
              Learn How It Works
            </a>
          </div>
        </div>
      </div>
    </section>
  );
}
