import React, { useState, useEffect } from 'react';
import { 
  Plus, 
  Trash2, 
  Image as ImageIcon, 
  Edit3, 
  Search, 
  RefreshCw, 
  Layers, 
  DollarSign, 
  CheckCircle, 
  AlertCircle, 
  X, 
  Upload, 
  ExternalLink,
  ShieldCheck
} from 'lucide-react';
import { 
  fetchListings, 
  fetchCategories, 
  updateListing, 
  updateListingImage, 
  deleteListing, 
  createListing, 
  resolveImageUrl 
} from '../api/client';
import './AdminManagement.css';

const PRESET_IMAGES = [
  { name: 'Vehicle / SUV', path: '/images/h1.png' },
  { name: 'Apartment', path: '/images/h2.png' },
  { name: 'Job / Career', path: '/images/h3.png' },
  { name: 'Groceries', path: '/images/h4.png' },
  { name: 'Laptop / Tech', path: '/images/h5.png' },
  { name: 'Smartphone', path: '/images/h6.png' },
  { name: 'Cleaning Service', path: '/images/h7.png' },
  { name: 'Dining Furniture', path: '/images/h8.png' },
];

export default function AdminManagementPage() {
  const [listings, setListings] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [selectedStatus, setSelectedStatus] = useState('All');
  const [notification, setNotification] = useState(null);

  // Modals state
  const [imageModalItem, setImageModalItem] = useState(null);
  const [newImagePath, setNewImagePath] = useState('');
  
  const [deleteModalItem, setDeleteModalItem] = useState(null);
  const [editModalItem, setEditModalItem] = useState(null);
  const [addModalOpen, setAddModalOpen] = useState(false);

  // New Ad Form State
  const [newAdForm, setNewAdForm] = useState({
    title: '',
    price: '',
    category: 'Vehicles',
    subcategory: '',
    location: 'Bengaluru',
    seller_name: 'Admin Sponsored',
    seller_id: 'user_admin',
    image_path: '/images/h1.png',
    description: '',
  });

  const loadData = async () => {
    setLoading(true);
    try {
      const [listData, catData] = await Promise.all([
        fetchListings(),
        fetchCategories(),
      ]);
      setListings(listData);
      setCategories(catData);
    } catch (err) {
      console.error('Failed to load admin data:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const showToast = (message, type = 'success') => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 4000);
  };

  // ── 1. Image Editing ──
  const handleOpenImageModal = (item) => {
    setImageModalItem(item);
    setNewImagePath(item.image_path || '');
  };

  const handleSaveImage = async () => {
    if (!imageModalItem || !newImagePath.trim()) return;
    try {
      const res = await updateListingImage(imageModalItem.id, newImagePath);
      if (res && res.success !== false) {
        setListings((prev) =>
          prev.map((l) => (l.id === imageModalItem.id ? { ...l, image_path: newImagePath } : l))
        );
        showToast(`Image updated for "${imageModalItem.title}"`);
        setImageModalItem(null);
      } else {
        showToast(res.message || 'Failed to update image', 'error');
      }
    } catch (err) {
      showToast('Error saving image', 'error');
    }
  };

  const handleFileUpload = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = () => {
        setNewImagePath(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  // ── 2. Removing User Ad ──
  const handleConfirmDelete = async () => {
    if (!deleteModalItem) return;
    try {
      const res = await deleteListing(deleteModalItem.id);
      if (res && res.success !== false) {
        setListings((prev) => prev.filter((l) => l.id !== deleteModalItem.id));
        showToast(`Ad "${deleteModalItem.title}" removed successfully`);
        setDeleteModalItem(null);
      } else {
        showToast(res.message || 'Failed to delete ad', 'error');
      }
    } catch (err) {
      showToast('Error removing ad', 'error');
    }
  };

  // ── 3. Edit Ad Details ──
  const handleSaveEdit = async () => {
    if (!editModalItem) return;
    try {
      const updates = {
        title: editModalItem.title,
        price: Number(editModalItem.price),
        location: editModalItem.location,
        status: editModalItem.status,
        description: editModalItem.description,
      };
      const res = await updateListing(editModalItem.id, updates);
      if (res && res.success !== false) {
        setListings((prev) =>
          prev.map((l) => (l.id === editModalItem.id ? { ...l, ...updates } : l))
        );
        showToast(`Ad details updated for "${editModalItem.title}"`);
        setEditModalItem(null);
      } else {
        showToast(res.message || 'Failed to update ad', 'error');
      }
    } catch (err) {
      showToast('Error updating ad', 'error');
    }
  };

  // ── 4. Create New Ad ──
  const handleCreateAd = async (e) => {
    e.preventDefault();
    if (!newAdForm.title || !newAdForm.price) return;
    try {
      const payload = {
        ...newAdForm,
        price: Number(newAdForm.price),
        formatted_price: `₹ ${Number(newAdForm.price).toLocaleString('en-IN')}`,
        status: 'Active',
      };
      const res = await createListing(payload);
      if (res && res.data) {
        setListings((prev) => [res.data, ...prev]);
        showToast(`New ad "${newAdForm.title}" published!`);
        setAddModalOpen(false);
        setNewAdForm({
          title: '',
          price: '',
          category: 'Vehicles',
          subcategory: '',
          location: 'Bengaluru',
          seller_name: 'Admin Sponsored',
          seller_id: 'user_admin',
          image_path: '/images/h1.png',
          description: '',
        });
      } else {
        showToast(res.message || 'Failed to create ad', 'error');
      }
    } catch (err) {
      showToast('Error creating ad', 'error');
    }
  };

  // ── Filtered Listings ──
  const filteredListings = listings.filter((item) => {
    if (selectedCategory !== 'All' && item.category?.toLowerCase() !== selectedCategory.toLowerCase()) {
      return false;
    }
    if (selectedStatus !== 'All' && item.status?.toLowerCase() !== selectedStatus.toLowerCase()) {
      return false;
    }
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchTitle = item.title?.toLowerCase().includes(q);
      const matchSeller = item.seller_name?.toLowerCase().includes(q);
      const matchLoc = item.location?.toLowerCase().includes(q);
      const matchId = item.id?.toLowerCase().includes(q);
      return matchTitle || matchSeller || matchLoc || matchId;
    }
    return true;
  });

  const activeCount = listings.filter((l) => (l.status || 'Active').toLowerCase() === 'active').length;

  return (
    <div className="admin-page">
      {/* Toast Notification */}
      {notification && (
        <div style={{
          position: 'fixed',
          top: 24,
          right: 24,
          zIndex: 10000,
          background: notification.type === 'error' ? '#ef4444' : '#10b981',
          color: '#ffffff',
          padding: '12px 20px',
          borderRadius: '10px',
          boxShadow: '0 8px 24px rgba(0,0,0,0.15)',
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          fontWeight: '600',
          fontSize: '14px',
        }}>
          {notification.type === 'error' ? <AlertCircle size={18} /> : <CheckCircle size={18} />}
          {notification.message}
        </div>
      )}

      {/* Header */}
      <div className="admin-header">
        <div>
          <div className="admin-header-badge">
            <ShieldCheck size={14} />
            Marketplace Admin Portal
          </div>
          <h1 className="admin-title">Ads & Product Management</h1>
          <p className="admin-subtitle">
            Manage all user ads, replace product images, add new sponsored listings, and moderate marketplace content.
          </p>
        </div>
        <div className="admin-header-actions">
          <button className="btn-admin-secondary" onClick={loadData}>
            <RefreshCw size={16} />
            Refresh
          </button>
          <button className="btn-admin-primary" onClick={() => setAddModalOpen(true)}>
            <Plus size={16} />
            Add User Ad
          </button>
        </div>
      </div>

      {/* KPI Summary Cards */}
      <div className="admin-kpis">
        <div className="admin-kpi-card">
          <div className="admin-kpi-icon kpi-purple">
            <Layers size={22} />
          </div>
          <div>
            <div className="admin-kpi-label">Total Listings</div>
            <div className="admin-kpi-val">{listings.length}</div>
          </div>
        </div>
        <div className="admin-kpi-card">
          <div className="admin-kpi-icon kpi-green">
            <CheckCircle size={22} />
          </div>
          <div>
            <div className="admin-kpi-label">Active Listings</div>
            <div className="admin-kpi-val">{activeCount}</div>
          </div>
        </div>
        <div className="admin-kpi-card">
          <div className="admin-kpi-icon kpi-blue">
            <Layers size={22} />
          </div>
          <div>
            <div className="admin-kpi-label">Categories</div>
            <div className="admin-kpi-val">{categories.length || 8}</div>
          </div>
        </div>
        <div className="admin-kpi-card">
          <div className="admin-kpi-icon kpi-amber">
            <DollarSign size={22} />
          </div>
          <div>
            <div className="admin-kpi-label">Pending Review</div>
            <div className="admin-kpi-val">{listings.length - activeCount}</div>
          </div>
        </div>
      </div>

      {/* Toolbar & Filters */}
      <div className="admin-toolbar">
        <div className="admin-search-row">
          <div className="admin-search-box">
            <Search size={16} className="admin-search-icon" />
            <input
              type="text"
              className="admin-search-input"
              placeholder="Search by title, seller name, location, or ID..."
              value={searchQuery}
              onInput={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <div style={{ display: 'flex', gap: '8px' }}>
            <select
              className="admin-form-select"
              style={{ width: 'auto', padding: '9px 12px' }}
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value)}
            >
              <option value="All">All Statuses</option>
              <option value="Active">Active</option>
              <option value="Pending">Pending</option>
              <option value="Suspended">Suspended</option>
            </select>
          </div>
        </div>

        {/* Category Filter Chips */}
        <div className="admin-filter-chips">
          <button
            className={`admin-chip ${selectedCategory === 'All' ? 'active' : ''}`}
            onClick={() => setSelectedCategory('All')}
          >
            All Categories ({listings.length})
          </button>
          {categories.map((cat) => {
            const count = listings.filter((l) => l.category?.toLowerCase() === cat.name?.toLowerCase()).length;
            return (
              <button
                key={cat.id || cat.name}
                className={`admin-chip ${selectedCategory === cat.name ? 'active' : ''}`}
                onClick={() => setSelectedCategory(cat.name)}
              >
                {cat.name} ({count})
              </button>
            );
          })}
        </div>
      </div>

      {/* Listings Management Table */}
      <div className="admin-table-container">
        {loading ? (
          <div style={{ padding: '40px', textAlign: 'center', color: '#64748b' }}>
            Loading marketplace ads...
          </div>
        ) : filteredListings.length === 0 ? (
          <div style={{ padding: '40px', textAlign: 'center', color: '#64748b' }}>
            No listings found matching your search.
          </div>
        ) : (
          <table className="admin-table">
            <thead>
              <tr>
                <th>Image</th>
                <th>Title & ID</th>
                <th>Category</th>
                <th>Price</th>
                <th>Seller / User</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredListings.map((item) => {
                const imgUrl = resolveImageUrl(item.image_path, item.category);
                const isAct = (item.status || 'Active').toLowerCase() === 'active';

                return (
                  <tr key={item.id}>
                    <td>
                      {/* Image Thumbnail with Hover Edit Overlay */}
                      <div 
                        className="admin-prod-thumb-container"
                        onClick={() => handleOpenImageModal(item)}
                        title="Click to change product image"
                      >
                        <img 
                          src={imgUrl} 
                          alt={item.title} 
                          className="admin-prod-thumb" 
                          onError={(e) => { e.target.src = '/images/h1.png'; }}
                        />
                        <div className="admin-thumb-edit-overlay">
                          <ImageIcon size={16} />
                        </div>
                      </div>
                    </td>
                    <td>
                      <div className="admin-item-title">{item.title}</div>
                      <div className="admin-item-id">{item.id}</div>
                    </td>
                    <td>
                      <span style={{ fontWeight: '600', color: '#334155' }}>{item.category}</span>
                      {item.subcategory && (
                        <span style={{ fontSize: '11.5px', color: '#64748b', display: 'block' }}>
                          {item.subcategory}
                        </span>
                      )}
                    </td>
                    <td>
                      <strong style={{ color: '#0f172a' }}>{item.formatted_price || `₹ ${item.price}`}</strong>
                    </td>
                    <td>
                      <div style={{ fontWeight: '500' }}>{item.seller_name || 'Anonymous User'}</div>
                      <div style={{ fontSize: '11px', color: '#94a3b8' }}>{item.location || 'India'}</div>
                    </td>
                    <td>
                      <span className={`admin-status-badge ${isAct ? 'status-active' : 'status-pending'}`}>
                        {item.status || 'Active'}
                      </span>
                    </td>
                    <td>
                      <div className="admin-actions-cell">
                        <button
                          className="btn-action-icon"
                          onClick={() => handleOpenImageModal(item)}
                          title="Change Product Image"
                        >
                          <ImageIcon size={16} />
                        </button>
                        <button
                          className="btn-action-icon"
                          onClick={() => setEditModalItem(item)}
                          title="Edit Ad Details"
                        >
                          <Edit3 size={16} />
                        </button>
                        <button
                          className="btn-action-icon btn-action-danger"
                          onClick={() => setDeleteModalItem(item)}
                          title="Remove User Ad"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
      </div>

      {/* ── MODAL 1: Edit Image Modal ── */}
      {imageModalItem && (
        <div className="admin-modal-overlay" onClick={() => setImageModalItem(null)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <h3 className="admin-modal-title">Edit Product Image</h3>
              <button className="admin-modal-close" onClick={() => setImageModalItem(null)}>
                <X size={20} />
              </button>
            </div>

            <p style={{ fontSize: '13px', color: '#64748b', marginTop: 0 }}>
              Updating image for: <strong>{imageModalItem.title}</strong>
            </p>

            {/* Live Preview */}
            <div className="image-preview-box">
              <img
                src={resolveImageUrl(newImagePath, imageModalItem.category)}
                alt="New Preview"
                className="image-preview-img"
                onError={(e) => { e.target.src = '/images/h1.png'; }}
              />
            </div>

            {/* Direct Image Path / URL Input */}
            <div className="admin-form-group">
              <label className="admin-form-label">Image URL or Asset Path</label>
              <input
                type="text"
                className="admin-form-input"
                placeholder="e.g. /images/h5.png or https://example.com/item.jpg"
                value={newImagePath}
                onInput={(e) => setNewImagePath(e.target.value)}
              />
            </div>

            {/* File Upload Option */}
            <div className="admin-form-group">
              <label className="admin-form-label">Or Upload Image File</label>
              <label style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                padding: '10px 14px',
                border: '1px solid #cbd5e1',
                borderRadius: '10px',
                background: '#f8fafc',
                cursor: 'pointer',
                fontSize: '13px',
                color: '#475569',
              }}>
                <Upload size={16} />
                <span>Choose local file...</span>
                <input type="file" accept="image/*" style={{ display: 'none' }} onChange={handleFileUpload} />
              </label>
            </div>

            {/* Preset Gallery */}
            <div className="admin-form-group">
              <label className="admin-form-label">Or Pick From Catalog Presets</label>
              <div className="preset-gallery">
                {PRESET_IMAGES.map((p) => (
                  <button
                    key={p.path}
                    type="button"
                    className={`preset-thumb-btn ${newImagePath === p.path ? 'selected' : ''}`}
                    onClick={() => setNewImagePath(p.path)}
                    title={p.name}
                  >
                    <img src={p.path} alt={p.name} />
                  </button>
                ))}
              </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '24px' }}>
              <button className="btn-admin-secondary" onClick={() => setImageModalItem(null)}>
                Cancel
              </button>
              <button className="btn-admin-primary" onClick={handleSaveImage}>
                Save Image
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── MODAL 2: Delete Ad Confirmation ── */}
      {deleteModalItem && (
        <div className="admin-modal-overlay" onClick={() => setDeleteModalItem(null)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()} style={{ maxWidth: '440px' }}>
            <div className="admin-modal-header">
              <h3 className="admin-modal-title" style={{ color: '#dc2626' }}>Remove User Ad</h3>
              <button className="admin-modal-close" onClick={() => setDeleteModalItem(null)}>
                <X size={20} />
              </button>
            </div>
            <p style={{ fontSize: '14px', color: '#475569', lineHeight: '1.5', margin: '0 0 20px 0' }}>
              Are you sure you want to permanently delete <strong>"{deleteModalItem.title}"</strong> posted by <strong>{deleteModalItem.seller_name}</strong>?
              <br /><br />
              This action will remove the listing from the MySQL database and marketplace catalog.
            </p>
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px' }}>
              <button className="btn-admin-secondary" onClick={() => setDeleteModalItem(null)}>
                Cancel
              </button>
              <button 
                className="btn-admin-primary" 
                style={{ background: '#dc2626', boxShadow: '0 4px 12px rgba(220, 38, 38, 0.25)' }}
                onClick={handleConfirmDelete}
              >
                Delete Ad
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── MODAL 3: Edit Ad Details ── */}
      {editModalItem && (
        <div className="admin-modal-overlay" onClick={() => setEditModalItem(null)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <h3 className="admin-modal-title">Edit Listing Details</h3>
              <button className="admin-modal-close" onClick={() => setEditModalItem(null)}>
                <X size={20} />
              </button>
            </div>

            <div className="admin-form-group">
              <label className="admin-form-label">Title</label>
              <input
                type="text"
                className="admin-form-input"
                value={editModalItem.title}
                onInput={(e) => setEditModalItem({ ...editModalItem, title: e.target.value })}
              />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
              <div className="admin-form-group">
                <label className="admin-form-label">Price (₹)</label>
                <input
                  type="number"
                  className="admin-form-input"
                  value={editModalItem.price}
                  onInput={(e) => setEditModalItem({ ...editModalItem, price: e.target.value })}
                />
              </div>

              <div className="admin-form-group">
                <label className="admin-form-label">Status</label>
                <select
                  className="admin-form-select"
                  value={editModalItem.status || 'Active'}
                  onChange={(e) => setEditModalItem({ ...editModalItem, status: e.target.value })}
                >
                  <option value="Active">Active</option>
                  <option value="Pending">Pending</option>
                  <option value="Suspended">Suspended</option>
                </select>
              </div>
            </div>

            <div className="admin-form-group">
              <label className="admin-form-label">Location</label>
              <input
                type="text"
                className="admin-form-input"
                value={editModalItem.location || ''}
                onInput={(e) => setEditModalItem({ ...editModalItem, location: e.target.value })}
              />
            </div>

            <div className="admin-form-group">
              <label className="admin-form-label">Description</label>
              <textarea
                className="admin-form-textarea"
                rows={3}
                value={editModalItem.description || ''}
                onInput={(e) => setEditModalItem({ ...editModalItem, description: e.target.value })}
              />
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '20px' }}>
              <button className="btn-admin-secondary" onClick={() => setEditModalItem(null)}>
                Cancel
              </button>
              <button className="btn-admin-primary" onClick={handleSaveEdit}>
                Save Details
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── MODAL 4: Add User Ad ── */}
      {addModalOpen && (
        <div className="admin-modal-overlay" onClick={() => setAddModalOpen(false)}>
          <div className="admin-modal" onClick={(e) => e.stopPropagation()}>
            <div className="admin-modal-header">
              <h3 className="admin-modal-title">Publish New User / Sponsored Ad</h3>
              <button className="admin-modal-close" onClick={() => setAddModalOpen(false)}>
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleCreateAd}>
              <div className="admin-form-group">
                <label className="admin-form-label">Ad Title *</label>
                <input
                  type="text"
                  required
                  className="admin-form-input"
                  placeholder="e.g. 2024 Apple MacBook Pro M3"
                  value={newAdForm.title}
                  onInput={(e) => setNewAdForm({ ...newAdForm, title: e.target.value })}
                />
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <div className="admin-form-group">
                  <label className="admin-form-label">Category *</label>
                  <select
                    className="admin-form-select"
                    value={newAdForm.category}
                    onChange={(e) => setNewAdForm({ ...newAdForm, category: e.target.value })}
                  >
                    {categories.length > 0 ? (
                      categories.map((c) => (
                        <option key={c.id || c.name} value={c.name}>{c.name}</option>
                      ))
                    ) : (
                      <>
                        <option value="Vehicles">Vehicles</option>
                        <option value="Mobiles">Mobiles</option>
                        <option value="Property">Property</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Furniture">Furniture</option>
                      </>
                    )}
                  </select>
                </div>

                <div className="admin-form-group">
                  <label className="admin-form-label">Price (₹) *</label>
                  <input
                    type="number"
                    required
                    className="admin-form-input"
                    placeholder="e.g. 85000"
                    value={newAdForm.price}
                    onInput={(e) => setNewAdForm({ ...newAdForm, price: e.target.value })}
                  />
                </div>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                <div className="admin-form-group">
                  <label className="admin-form-label">Seller Name</label>
                  <input
                    type="text"
                    className="admin-form-input"
                    placeholder="e.g. Rahul Sharma"
                    value={newAdForm.seller_name}
                    onInput={(e) => setNewAdForm({ ...newAdForm, seller_name: e.target.value })}
                  />
                </div>

                <div className="admin-form-group">
                  <label className="admin-form-label">Location</label>
                  <input
                    type="text"
                    className="admin-form-input"
                    placeholder="e.g. Bengaluru"
                    value={newAdForm.location}
                    onInput={(e) => setNewAdForm({ ...newAdForm, location: e.target.value })}
                  />
                </div>
              </div>

              {/* Image Preset Selector */}
              <div className="admin-form-group">
                <label className="admin-form-label">Product Image</label>
                <input
                  type="text"
                  className="admin-form-input"
                  placeholder="/images/h1.png"
                  value={newAdForm.image_path}
                  onInput={(e) => setNewAdForm({ ...newAdForm, image_path: e.target.value })}
                />
                <div className="preset-gallery" style={{ marginTop: '8px' }}>
                  {PRESET_IMAGES.map((p) => (
                    <button
                      key={p.path}
                      type="button"
                      className={`preset-thumb-btn ${newAdForm.image_path === p.path ? 'selected' : ''}`}
                      onClick={() => setNewAdForm({ ...newAdForm, image_path: p.path })}
                      title={p.name}
                    >
                      <img src={p.path} alt={p.name} />
                    </button>
                  ))}
                </div>
              </div>

              <div className="admin-form-group">
                <label className="admin-form-label">Description</label>
                <textarea
                  className="admin-form-textarea"
                  rows={2}
                  placeholder="Describe the product or ad details..."
                  value={newAdForm.description}
                  onInput={(e) => setNewAdForm({ ...newAdForm, description: e.target.value })}
                />
              </div>

              <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '10px', marginTop: '20px' }}>
                <button type="button" className="btn-admin-secondary" onClick={() => setAddModalOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-admin-primary">
                  Publish Ad
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
