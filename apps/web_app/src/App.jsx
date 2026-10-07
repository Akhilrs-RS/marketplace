import React, { useState, useEffect } from 'react';
import { BrowserRouter, Routes, Route, useLocation } from 'react-router-dom';
import Navbar from './components/common/Navbar';
import Footer from './components/common/Footer';
import PostAdModal from './components/common/PostAdModal';
import ContactSellerModal from './components/common/ContactSellerModal';
import HomePage from './pages/HomePage';
import ShopsPage from './pages/ShopsPage';
import ListingsPage from './pages/ListingsPage';
import ListingDetailPage from './pages/ListingDetailPage';
import ShopVehiclesPage from './pages/ShopVehiclesPage';
import MessagesPage from './pages/MessagesPage';
import PostAdPage from './pages/PostAdPage';

// Scroll to top helper
function ScrollToTop() {
  const { pathname } = useLocation();
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);
  return null;
}

export default function App() {
  const [postAdOpen, setPostAdOpen] = useState(false);
  const [contactModalData, setContactModalData] = useState(null);
  
  // Persistent Favorites
  const [favorites, setFavorites] = useState(() => {
    try {
      const saved = localStorage.getItem('galletrix_favorites');
      return saved ? JSON.parse(saved) : ['list_creta_2022'];
    } catch {
      return ['list_creta_2022'];
    }
  });

  const handleToggleFavorite = (id) => {
    setFavorites((prev) => {
      let updated;
      if (prev.includes(id)) {
        updated = prev.filter((favId) => favId !== id);
      } else {
        updated = [...prev, id];
      }
      try {
        localStorage.setItem('galletrix_favorites', JSON.stringify(updated));
      } catch (err) {
        console.error(err);
      }
      return updated;
    });
  };

  return (
    <BrowserRouter>
      <ScrollToTop />
      
      {/* Top Navbar */}
      <Navbar 
        onOpenPostAd={() => setPostAdOpen(true)} 
        favoritesCount={favorites.length}
      />

      {/* Main Pages */}
      <main style={{ flex: 1 }}>
        <Routes>
          <Route 
            path="/" 
            element={
              <HomePage 
                onOpenPostAd={() => setPostAdOpen(true)} 
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/shops" 
            element={
              <ShopsPage 
                onOpenContact={(shopData) => setContactModalData(shopData)}
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/shops/:id" 
            element={
              <ShopVehiclesPage 
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/shop-listings" 
            element={
              <ShopVehiclesPage 
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/listings" 
            element={
              <ListingsPage 
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/listings/:id" 
            element={
              <ListingDetailPage 
                onOpenContact={(item) => setContactModalData(item)}
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
          <Route 
            path="/messages" 
            element={<MessagesPage />} 
          />
          <Route 
            path="/post-ad" 
            element={<PostAdPage />} 
          />
          <Route 
            path="*" 
            element={
              <HomePage 
                onOpenPostAd={() => setPostAdOpen(true)} 
                favorites={favorites}
                onToggleFavorite={handleToggleFavorite}
              />
            } 
          />
        </Routes>
      </main>

      {/* Multi-column Footer */}
      <Footer />

      {/* Global Interactive Modals */}
      <PostAdModal 
        isOpen={postAdOpen} 
        onClose={() => setPostAdOpen(false)}
        onListingCreated={(newListing) => {
          console.log('Listing created:', newListing);
        }}
      />

      <ContactSellerModal 
        isOpen={Boolean(contactModalData)}
        listing={contactModalData}
        onClose={() => setContactModalData(null)}
      />
    </BrowserRouter>
  );
}
