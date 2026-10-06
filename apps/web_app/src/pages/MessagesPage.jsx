import React, { useState, useEffect, useRef } from 'react';
import { useSearchParams, Link, useNavigate } from 'react-router-dom';
import { 
  Search, 
  Send, 
  Paperclip, 
  Phone, 
  ExternalLink, 
  ShieldCheck, 
  CheckCheck, 
  Check, 
  Calendar, 
  ChevronLeft, 
  Sparkles, 
  Car, 
  Building2, 
  MoreVertical,
  MessageSquare,
  Clock,
  ArrowRight
} from 'lucide-react';
import { 
  getSavedConversations, 
  persistConversations 
} from '../data/messagesData';
import './MessagesPage.css';

export default function MessagesPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const navigate = useNavigate();

  const [conversations, setConversations] = useState(() => getSavedConversations());
  const [activeTab, setActiveTab] = useState('all'); // 'all' | 'buying' | 'selling'
  const [searchTerm, setSearchTerm] = useState('');
  const [inputMessage, setInputMessage] = useState('');
  const [showMobileChat, setShowMobileChat] = useState(false);

  const chatStreamRef = useRef(null);
  const inputRef = useRef(null);

  // Check URL params for convId or listingId
  const paramConv = searchParams.get('conv');
  const paramListing = searchParams.get('listing');

  // Determine active conversation ID
  const [activeConvId, setActiveConvId] = useState(() => {
    const list = getSavedConversations();
    if (paramConv && list.some(c => c.id === paramConv)) {
      return paramConv;
    }
    if (paramListing) {
      const match = list.find(c => c.listing?.id === paramListing);
      if (match) return match.id;
    }
    return list[0]?.id || 'conv_hyundai_tucson';
  });

  // Handle URL param changes
  useEffect(() => {
    if (paramConv) {
      setActiveConvId(paramConv);
      setShowMobileChat(true);
    } else if (paramListing) {
      const match = conversations.find(c => c.listing?.id === paramListing);
      if (match) {
        setActiveConvId(match.id);
        setShowMobileChat(true);
      }
    }
  }, [paramConv, paramListing]);

  // Mark active conversation as read
  useEffect(() => {
    if (!activeConvId) return;
    setConversations((prev) => {
      const updated = prev.map((c) => {
        if (c.id === activeConvId && c.unreadCount > 0) {
          return { ...c, unreadCount: 0 };
        }
        return c;
      });
      persistConversations(updated);
      return updated;
    });
  }, [activeConvId]);

  // Scroll to bottom of message stream container only (never scrolling the window)
  useEffect(() => {
    if (chatStreamRef.current) {
      chatStreamRef.current.scrollTop = chatStreamRef.current.scrollHeight;
    }
  }, [activeConvId, conversations]);

  const activeConversation = conversations.find(c => c.id === activeConvId) || conversations[0];

  // Filtering conversations
  const filteredConversations = conversations.filter((c) => {
    // Tab filter
    if (activeTab === 'buying' && !c.isBuying) return false;
    if (activeTab === 'selling' && c.isBuying) return false;

    // Search query
    if (searchTerm.trim()) {
      const q = searchTerm.toLowerCase();
      const matchName = c.senderName.toLowerCase().includes(q);
      const matchTag = c.listing?.title?.toLowerCase().includes(q);
      const matchMsg = c.messages.some(m => m.text.toLowerCase().includes(q));
      return matchName || matchTag || matchMsg;
    }
    return true;
  });

  const handleSelectConversation = (convId) => {
    setActiveConvId(convId);
    setShowMobileChat(true);
    setSearchParams({ conv: convId });
  };

  const handleSendMessage = (textToSend) => {
    const text = (textToSend || inputMessage).trim();
    if (!text || !activeConversation) return;

    const newMessage = {
      id: 'msg_' + Date.now(),
      text,
      time: 'Just now',
      isFromMe: true,
      status: 'sent',
    };

    setConversations((prev) => {
      const updated = prev.map((c) => {
        if (c.id === activeConversation.id) {
          return {
            ...c,
            messages: [...c.messages, newMessage],
          };
        }
        return c;
      });
      // Move this conversation to top
      const targetIndex = updated.findIndex(c => c.id === activeConversation.id);
      if (targetIndex > 0) {
        const [moved] = updated.splice(targetIndex, 1);
        updated.unshift(moved);
      }
      persistConversations(updated);
      return updated;
    });

    setInputMessage('');

    // Optional automated seller acknowledgment
    if (activeConversation.id === 'conv_hyundai_tucson') {
      setTimeout(() => {
        const replyMessage = {
          id: 'reply_' + Date.now(),
          text: 'Thank you for your response! Advisor Rahul has been notified and will call you shortly if required.',
          time: 'Just now',
          isFromMe: false,
        };
        setConversations((latest) => {
          const withReply = latest.map((c) => {
            if (c.id === 'conv_hyundai_tucson') {
              return {
                ...c,
                messages: [...c.messages, replyMessage],
              };
            }
            return c;
          });
          persistConversations(withReply);
          return withReply;
        });
      }, 1500);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  // Quick suggestion prompts
  const suggestionPills = [
    'Is this available for a test drive?',
    'What is your best negotiable price?',
    'Can I schedule an inspection tomorrow?',
    'Are full periodic service records available?'
  ];

  return (
    <div className="messages-page-root">
      {/* 1. Header Bar Container */}
      <div className="container messages-container">
        {/* Top Control Bar with Back button and Title */}
        <div className="messages-top-bar">
          <div className="messages-title-group">
            <button 
              type="button" 
              onClick={() => navigate(-1)} 
              className="messages-back-btn"
            >
              <ChevronLeft size={16} />
              <span>Back</span>
            </button>
            <div className="messages-heading-wrap">
              <h1 className="messages-main-title">Messages & Inquiries</h1>
              <span className="messages-verified-chip">
                <ShieldCheck size={13} />
                <span>Verified End-to-End Chat</span>
              </span>
            </div>
          </div>

          <div className="messages-meta-stats">
            <span className="meta-stat-pill">
              <strong>{conversations.length}</strong> Conversations
            </span>
          </div>
        </div>

        {/* 2. Main Split-Pane Inbox Layout */}
        <div className="messages-inbox-card">
          {/* ── LEFT PANE: Conversation Master List ── */}
          <aside className={`messages-sidebar ${showMobileChat ? 'mobile-hidden' : ''}`}>
            {/* Sidebar Search Bar */}
            <div className="sidebar-search-box">
              <Search size={16} className="sidebar-search-icon" />
              <input
                type="text"
                placeholder="Search sellers, items, or chats..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="sidebar-search-input"
              />
            </div>

            {/* Segmented Filter Tabs */}
            <div className="sidebar-filter-tabs">
              <button
                type="button"
                onClick={() => setActiveTab('all')}
                className={`filter-tab-btn ${activeTab === 'all' ? 'active' : ''}`}
              >
                All
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('buying')}
                className={`filter-tab-btn ${activeTab === 'buying' ? 'active' : ''}`}
              >
                Buying
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('selling')}
                className={`filter-tab-btn ${activeTab === 'selling' ? 'active' : ''}`}
              >
                Selling
              </button>
            </div>

            {/* Conversation Cards List */}
            <div className="conversations-scroll-list">
              {filteredConversations.map((conv) => {
                const isActive = conv.id === activeConvId;
                const lastMsg = conv.messages[conv.messages.length - 1];
                return (
                  <div
                    key={conv.id}
                    onClick={() => handleSelectConversation(conv.id)}
                    className={`conversation-card-item ${isActive ? 'active-card' : ''} ${conv.unreadCount > 0 ? 'has-unread' : ''}`}
                  >
                    {/* Item Thumbnail */}
                    <div className="conv-item-thumb-wrap">
                      <img
                        src={conv.listing?.image || '/images/h1.png'}
                        alt={conv.listing?.title}
                        className="conv-item-thumb-img"
                      />
                      {conv.isOnline && <span className="conv-online-dot" title="Online" />}
                    </div>

                    {/* Middle Info */}
                    <div className="conv-middle-info">
                      <div className="conv-header-row">
                        <span className="conv-sender-name">{conv.senderName}</span>
                        <span className="conv-time-tag">{lastMsg?.time || ''}</span>
                      </div>

                      {/* Tag / Product Subhead */}
                      <div className="conv-listing-tag">
                        <span>{conv.listing?.title}</span>
                      </div>

                      {/* Last message preview */}
                      <p className="conv-preview-text">
                        {lastMsg?.isFromMe && <span className="preview-prefix">You: </span>}
                        {lastMsg?.text || 'No messages yet'}
                      </p>
                    </div>

                    {/* Unread Pill */}
                    {conv.unreadCount > 0 && (
                      <span className="conv-unread-pill">{conv.unreadCount}</span>
                    )}
                  </div>
                );
              })}

              {filteredConversations.length === 0 && (
                <div className="sidebar-empty-state">
                  <MessageSquare size={32} className="empty-state-icon" />
                  <p>No conversations found</p>
                </div>
              )}
            </div>
          </aside>

          {/* ── RIGHT PANE: Active Conversation & Chat Stream ── */}
          <main className={`messages-chat-pane ${!showMobileChat ? 'mobile-hidden' : ''}`}>
            {activeConversation ? (
              <>
                {/* 1. Chat Header */}
                <header className="chat-header-bar">
                  <div className="chat-header-contact">
                    <button
                      type="button"
                      onClick={() => setShowMobileChat(false)}
                      className="chat-mobile-back-btn"
                    >
                      <ChevronLeft size={20} />
                    </button>

                    <div className="contact-avatar-box">
                      <span>{activeConversation.senderInitial || 'S'}</span>
                      {activeConversation.isOnline && <span className="avatar-online-dot" />}
                    </div>

                    <div className="contact-meta-col">
                      <div className="contact-name-row">
                        <h2 className="contact-name">{activeConversation.senderName}</h2>
                        <span className="contact-role-badge">
                          <ShieldCheck size={12} />
                          <span>{activeConversation.senderRole}</span>
                        </span>
                      </div>
                      <span className="contact-status-p">{activeConversation.statusText}</span>
                    </div>
                  </div>

                  {/* Header Actions */}
                  <div className="chat-header-actions">
                    <a
                      href={`tel:${activeConversation.phone}`}
                      className="chat-action-btn"
                      title="Call dealer"
                    >
                      <Phone size={14} />
                      <span className="btn-label-desktop">Call</span>
                    </a>

                    {activeConversation.listing && (
                      <Link
                        to={`/listings/${activeConversation.listing.id}`}
                        className="chat-action-btn primary"
                        title="View listing details"
                      >
                        <ExternalLink size={14} />
                        <span className="btn-label-desktop">View Ad</span>
                      </Link>
                    )}
                  </div>
                </header>

                {/* 2. Pinned Listing Context Card */}
                {activeConversation.listing && (
                  <div className="chat-pinned-listing-strip">
                    <div className="pinned-img-wrap">
                      <img
                        src={activeConversation.listing.image}
                        alt={activeConversation.listing.title}
                        className="pinned-img"
                      />
                    </div>
                    <div className="pinned-info-wrap">
                      <div className="pinned-title-row">
                        <strong className="pinned-title">{activeConversation.listing.title}</strong>
                        <span className="pinned-badge">{activeConversation.listing.badge}</span>
                      </div>
                      <div className="pinned-price-location-row">
                        <span className="pinned-price">{activeConversation.listing.price}</span>
                        <span className="pinned-sep">•</span>
                        <span className="pinned-location">{activeConversation.listing.location}</span>
                      </div>
                    </div>
                    <Link
                      to={`/listings/${activeConversation.listing.id}`}
                      className="pinned-view-link"
                    >
                      <span>Explore</span>
                      <ArrowRight size={13} />
                    </Link>
                  </div>
                )}

                {/* 3. Messages Stream */}
                <div className="chat-messages-stream" ref={chatStreamRef}>
                  <div className="chat-date-divider">
                    <span>Verified Conversation Started</span>
                  </div>

                  {activeConversation.messages.map((m) => {
                    const isMe = m.isFromMe;
                    return (
                      <div
                        key={m.id}
                        className={`chat-bubble-row ${isMe ? 'row-outgoing' : 'row-incoming'}`}
                      >
                        {!isMe && (
                          <div className="bubble-avatar-mini">
                            {activeConversation.senderInitial}
                          </div>
                        )}
                        <div className={`chat-bubble ${isMe ? 'bubble-outgoing' : 'bubble-incoming'}`}>
                          <p className="bubble-text">{m.text}</p>
                          <div className="bubble-meta">
                            <span className="bubble-time">{m.time}</span>
                            {isMe && (
                              <span className="bubble-ticks">
                                <CheckCheck size={13} />
                              </span>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* 4. Quick Suggestion Chips */}
                <div className="chat-suggestion-chips-bar">
                  <span className="chips-hint">
                    <Sparkles size={12} />
                    <span>Suggestions:</span>
                  </span>
                  <div className="chips-scroll-wrap">
                    {suggestionPills.map((pill, idx) => (
                      <button
                        key={idx}
                        type="button"
                        onClick={() => handleSendMessage(pill)}
                        className="suggestion-chip-btn"
                      >
                        {pill}
                      </button>
                    ))}
                  </div>
                </div>

                {/* 5. Message Composer Bar */}
                <div className="chat-composer-bar">
                  <button
                    type="button"
                    onClick={() => alert('Attachments: Document, photo, or inspection receipt upload')}
                    className="composer-attach-btn"
                    title="Attach file"
                  >
                    <Paperclip size={18} />
                  </button>

                  <textarea
                    ref={inputRef}
                    rows="1"
                    placeholder={`Message ${activeConversation.senderName}... (Press Enter to send)`}
                    value={inputMessage}
                    onChange={(e) => setInputMessage(e.target.value)}
                    onKeyDown={handleKeyDown}
                    className="composer-textarea"
                  />

                  <button
                    type="button"
                    onClick={() => handleSendMessage()}
                    disabled={!inputMessage.trim()}
                    className="composer-send-btn"
                    title="Send message"
                  >
                    <Send size={16} />
                  </button>
                </div>
              </>
            ) : (
              <div className="chat-no-selection-state">
                <MessageSquare size={48} className="empty-chat-icon" />
                <h3>Select a conversation</h3>
                <p>Choose an inquiry from the left to view negotiation details.</p>
              </div>
            )}
          </main>
        </div>
      </div>
    </div>
  );
}
