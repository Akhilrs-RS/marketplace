import React from 'react';
import { 
  UserCheck, 
  ShieldCheck, 
  Flag, 
  CheckCircle2, 
  Lock, 
  Headphones 
} from 'lucide-react';
import './TrustSection.css';

export default function TrustSection() {
  const trustCards = [
    {
      icon: UserCheck,
      title: 'Verified sellers',
      desc: 'Identity checks and phone verification for trustworthy transactions.',
    },
    {
      icon: ShieldCheck,
      title: 'Secure communication',
      desc: 'Chat and negotiate happen safely within the platform.',
    },
    {
      icon: Flag,
      title: 'Report suspicious listings',
      desc: 'Flag anything that looks off — our team reviews every report.',
    },
    {
      icon: CheckCircle2,
      title: 'Moderated content',
      desc: 'Listings are reviewed to follow guidelines to keep quality high.',
    },
    {
      icon: Lock,
      title: 'Protected account access',
      desc: 'Your account and data stay private and secured.',
    },
    {
      icon: Headphones,
      title: 'Help desk support',
      desc: 'Responsive team ready to help when you need it.',
    },
  ];

  return (
    <section className="trust-section-figma">
      <div className="container trust-container">
        <div className="trust-header-figma">
          <h2 className="trust-title-serif">Marketplace built around trust.</h2>
          <p className="trust-subtitle-clean">
            Feel secure in the systems that keep buying and selling safe.
          </p>
        </div>

        <div className="trust-cards-grid">
          {trustCards.map((card, idx) => {
            const Icon = card.icon;
            return (
              <div key={idx} className="trust-card-figma">
                <div className="trust-icon-bubble">
                  <Icon size={16} strokeWidth={2.2} />
                </div>
                <h3 className="trust-card-title">{card.title}</h3>
                <p className="trust-card-desc">{card.desc}</p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
