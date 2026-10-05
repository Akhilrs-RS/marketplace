import React from 'react';
import { HelpCircle, ShieldCheck, MessageSquare, PlusCircle } from 'lucide-react';
import './FaqSection.css';

export default function FaqSection() {
  const faqs = [
    {
      icon: PlusCircle,
      q: 'How do I create a listing?',
      a: 'Click the "Post an Ad" button in the top navigation or bottom banner. Enter your item details, upload photos, set your price, and your ad will be live after quick automated verification.'
    },
    {
      icon: ShieldCheck,
      q: 'Is my payment secure?',
      a: 'Yes. All verified dealers and sellers are identity-verified. For direct peer transactions, we provide escrow protection options and recommend on-site inspection before any fund transfer.'
    },
    {
      icon: MessageSquare,
      q: 'How do I contact sellers?',
      a: 'Simply tap the "Contact Seller" or "Chat with the Seller" button on any listing page. You can send direct messages, request walk-around videos, or schedule an in-person test drive.'
    }
  ];

  return (
    <section className="faq-section" id="faq">
      <div className="container">
        <div className="faq-header">
          <h2 className="section-title">Frequently asked questions</h2>
          <p className="section-subtitle">Find answers to common questions about our platform</p>
        </div>

        <div className="faq-cards-grid">
          {faqs.map((faq, index) => {
            const Icon = faq.icon;
            return (
              <div key={index} className="faq-card card-hover">
                <div className="faq-icon-circle">
                  <Icon size={20} />
                </div>
                <h3 className="faq-card-question">{faq.q}</h3>
                <p className="faq-card-answer">{faq.a}</p>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
