-- ============================================================================
-- Galletrix Marketplace Database Schema & Seed Data
-- ============================================================================

-- 1. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    slug VARCHAR(64) NOT NULL UNIQUE,
    icon_name VARCHAR(64) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 2. Listings Table
CREATE TABLE IF NOT EXISTS listings (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price NUMERIC(14, 2) NOT NULL,
    formatted_price VARCHAR(64) NOT NULL,
    location VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    subcategory VARCHAR(64) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    seller_id VARCHAR(64) NOT NULL,
    seller_name VARCHAR(128) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    specifications JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_listings_category ON listings(category);
CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status);
CREATE INDEX IF NOT EXISTS idx_listings_created_at ON listings(created_at DESC);

-- 3. Vehicle Details Table
CREATE TABLE IF NOT EXISTS vehicle_details (
    listing_id VARCHAR(64) PRIMARY KEY REFERENCES listings(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    price VARCHAR(64) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    location VARCHAR(128) NOT NULL,
    total_capacity VARCHAR(64) NOT NULL,
    highest_speed VARCHAR(64) NOT NULL,
    engine_output VARCHAR(64) NOT NULL,
    fuel_type VARCHAR(64) NOT NULL,
    transmission VARCHAR(64) NOT NULL,
    owner VARCHAR(128) NOT NULL,
    description TEXT NOT NULL,
    highlights TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[]
);

-- 4. Seller Metrics Table
CREATE TABLE IF NOT EXISTS seller_metrics (
    seller_id VARCHAR(64) PRIMARY KEY,
    active_listings INT NOT NULL DEFAULT 0,
    total_views INT NOT NULL DEFAULT 0,
    enquiries INT NOT NULL DEFAULT 0,
    messages INT NOT NULL DEFAULT 0,
    growth_percent INT NOT NULL DEFAULT 0,
    period VARCHAR(64) NOT NULL DEFAULT 'This Month',
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Conversations Table
CREATE TABLE IF NOT EXISTS conversations (
    id VARCHAR(64) PRIMARY KEY,
    sender_name VARCHAR(128) NOT NULL,
    sender_avatar VARCHAR(255) NOT NULL,
    item_tag VARCHAR(128) NOT NULL,
    item_thumbnail VARCHAR(255) NOT NULL,
    last_message TEXT NOT NULL,
    timestamp VARCHAR(64) NOT NULL,
    is_buying BOOLEAN NOT NULL DEFAULT TRUE,
    unread_count INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Chat Messages Table
CREATE TABLE IF NOT EXISTS chat_messages (
    id VARCHAR(64) PRIMARY KEY,
    conversation_id VARCHAR(64) NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id VARCHAR(64) NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_from_me BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_chat_messages_conv ON chat_messages(conversation_id, sent_at ASC);

-- 7. User Profiles Table
CREATE TABLE IF NOT EXISTS user_profiles (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    phone VARCHAR(64) NOT NULL,
    email VARCHAR(128) NOT NULL,
    address VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255) NOT NULL,
    favorites_count INT NOT NULL DEFAULT 0,
    saved_searches_count INT NOT NULL DEFAULT 0,
    recently_viewed_count INT NOT NULL DEFAULT 0,
    active_enquiries_count INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. User Favorites Table
CREATE TABLE IF NOT EXISTS user_favorites (
    user_id VARCHAR(64) NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    listing_id VARCHAR(64) NOT NULL REFERENCES listings(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, listing_id)
);

-- 9. Dealerships Table
CREATE TABLE IF NOT EXISTS dealerships (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    location VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    rating VARCHAR(16) NOT NULL,
    badge VARCHAR(64) NOT NULL DEFAULT 'Trusted Dealer',
    image_path VARCHAR(255) NOT NULL
);

-- 10. Trusted Businesses Table
CREATE TABLE IF NOT EXISTS trusted_businesses (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    rating VARCHAR(16) NOT NULL,
    verified_listings_count INT NOT NULL DEFAULT 0,
    image_path VARCHAR(255) NOT NULL
);

-- ============================================================================
-- SEED DATA (Idempotent Insertion with ON CONFLICT DO NOTHING)
-- ============================================================================

-- 1. Categories
INSERT INTO categories (id, name, slug, icon_name, image_url) VALUES
('cat_vehicles', 'Vehicles', 'vehicles', 'directions_car', 'assets/images/h1.png'),
('cat_property', 'Property', 'property', 'home_work', 'assets/images/h2.png'),
('cat_jobs', 'Jobs', 'jobs', 'work', 'assets/images/h3.png'),
('cat_groceries', 'Groceries', 'groceries', 'local_grocery_store', 'assets/images/h4.png'),
('cat_electronics', 'Electronics', 'electronics', 'devices', 'assets/images/h5.png'),
('cat_mobiles', 'Mobiles', 'mobiles', 'phone_android', 'assets/images/h6.png'),
('cat_services', 'Services', 'services', 'handyman', 'assets/images/h7.png'),
('cat_furniture', 'Furniture', 'furniture', 'chair', 'assets/images/h8.png')
ON CONFLICT (id) DO NOTHING;

-- 2. Listings
INSERT INTO listings (id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at) VALUES
('list_creta_2022', '2022 Hyundai Creta EX', 725000, '₹ 7,25,000', 'Thiruvananthapuram', 'Vehicles', 'Car', 'assets/images/h1.png', 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience.', 'ven_hyundai_hub', 'Hyundai Auto Hub', 'active', TRUE, '{"total_capacity": "6 Seats", "highest_speed": "200 KM/H", "engine_output": "500 HP", "fuel_type": "Petrol", "transmission": "Automatic", "owner": "1st Owner • Verified"}'::jsonb, NOW() - INTERVAL '4 hours'),
('list_apt_kowdiar', '3BHK Apartment - Kowdiar', 9500000, '₹ 95,00,000', 'Thiruvananthapuram', 'Property', 'Apartment', 'assets/images/h2.png', 'Luxury 3BHK premium apartment with scenic balcony view, high-end fittings, and covered parking.', 'ven_skyline', 'Skyline Prime Realty', 'active', TRUE, '{"bedrooms": "3 BHK", "super_area": "1,850 sqft", "furnishing": "Semi-Furnished"}'::jsonb, NOW() - INTERVAL '8 hours'),
('list_apt_sushil', 'Sushil 2BHK Apartment', 42000, '₹ 42,000 /mo', 'HSR Layout, Bengaluru', 'Property', 'Rent', 'assets/images/h8.png', 'Spacious 2BHK ready-to-move apartment located in prime HSR Layout Sector 2.', 'ven_sushil_props', 'Sushil Properties', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '12 hours'),
('list_oak_dining_1', 'Solid Oak Dining Table', 725000, '₹ 7,25,000', 'HSR Layout, Bengaluru', 'Furniture', 'Dining Sets', 'assets/images/h.png', 'Handcrafted solid European oak dining table with seating for up to 8 guests.', 'ven_woodcraft', 'Heritage Woodcraft', 'active', FALSE, '{}'::jsonb, NOW() - INTERVAL '1 day'),
('list_phone_flagship', 'Flagship Phone - 256GB', 62900, '₹ 62,900', 'Thiruvananthapuram', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Brand new condition, 100% battery health, original bill, box and complete accessories.', 'ven_tech_zone', 'TechZone Retail', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '1 day 2 hours'),
('list_job_frontend', 'Senior Frontend Engineer', 2400000, '₹ 18 - 24 LPA', 'Bengaluru', 'Jobs', 'Engineering', 'assets/images/h3.png', 'Join a hyper-growth venture building cross-platform Flutter and Next.js applications.', 'ven_galletrix_hr', 'Galletrix Talent', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '2 days'),
('list_apt_kakkanad', '3BHK Apartment in Kakkanad', 12500000, '₹ 1.25 Crore', 'Bengaluru', 'Property', 'Apartment', 'assets/images/h2.png', 'Overlooking Infopark with premium clubhouse amenities, swimming pool, and 24x7 security.', 'ven_urban_nest', 'Urban Nest Realty', 'active', FALSE, '{}'::jsonb, NOW() - INTERVAL '2 days 5 hours'),
('list_veg_combo', 'Organic Vegetables Combo Pack', 499, '₹ 499', 'Kakkanad', 'Groceries', 'Vegetables', 'assets/images/h4.png', 'Fresh organic farm-picked daily essential vegetables box (5kg assortment).', 'ven_green_harvest', 'Green Harvest Farms', 'active', FALSE, '{}'::jsonb, NOW() - INTERVAL '3 days'),
('list_clean_service', 'Home Deep Cleaning Service', 2500, '₹ 2,500', 'Kakkanad', 'Services', 'Cleaning', 'assets/images/h7.png', 'Comprehensive 4-hour home sanitization and deep cleaning by verified professionals.', 'ven_clean_pros', 'Urban Clean Pros', 'active', FALSE, '{}'::jsonb, NOW() - INTERVAL '3 days 4 hours'),
('list_macbook_m2', 'MacBook Air M2 13"', 98000, '₹ 98,000', 'Kochi', 'Mobiles', 'Laptops', 'assets/images/h5.png', 'Apple M2 chip, 8GB unified memory, 256GB SSD, Midnight finish with AppleCare+ warranty.', 'ven_alex_m', 'Alex Morgan', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '4 days'),
('list_iphone_15_pro', 'iPhone 15 Pro Max 256GB', 134900, '₹ 1,34,900', 'Indiranagar, Bengaluru', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Natural Titanium, immaculate condition with Apple warranty till December.', 'ven_premium_tech', 'Premium Tech Hub', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '4 days 2 hours'),
('list_s24_ultra', 'Samsung Galaxy S24 Ultra 5G', 109999, '₹ 1,09,999', 'HSR Layout, Bengaluru', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Titanium Gray 12GB/512GB, Galaxy AI unlocked with S-Pen.', 'ven_galaxy_hub', 'Galaxy Official Reseller', 'active', TRUE, '{}'::jsonb, NOW() - INTERVAL '4 days 6 hours')
ON CONFLICT (id) DO NOTHING;

-- 3. Vehicle Details
INSERT INTO vehicle_details (listing_id, title, price, image_path, location, total_capacity, highest_speed, engine_output, fuel_type, transmission, owner, description, highlights) VALUES
('list_creta_2022', 'Hyundai Creta SX', '₹ 7,25,000', 'assets/images/h1.png', 'Thiruvananthapuram', '6 Seats', '200 KM/H', '500 HP', 'Petrol', 'Automatic', '1st Owner • Verified', 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience featuring a panoramic sunroof, premium upholstery, and wireless connectivity.', ARRAY['Panoramic Sunroof', 'Bose 8-Speaker Audio', 'Wireless Phone Charger', 'Full Service Record Available'])
ON CONFLICT (listing_id) DO NOTHING;

-- 4. Seller Metrics
INSERT INTO seller_metrics (seller_id, active_listings, total_views, enquiries, messages, growth_percent, period) VALUES
('ven_alex_m', 12, 2400, 38, 7, 16, 'This Month'),
('ven_default', 12, 2400, 38, 7, 16, 'This Month')
ON CONFLICT (seller_id) DO NOTHING;

-- 5. Conversations
INSERT INTO conversations (id, sender_name, sender_avatar, item_tag, item_thumbnail, last_message, timestamp, is_buying, unread_count) VALUES
('conv_1', 'Rohan Sharma', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 'Hyundai Creta 2022', 'assets/images/h1.png', 'Yes, You can inspect it tomorrow', '10:41', TRUE, 1),
('conv_2', 'Urban Nest Realty', 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150', '3BHK Kakkanad Apartment', 'assets/images/h2.png', 'The viewing is confirmed for 4 PM', 'Yesterday', TRUE, 0),
('conv_3', 'Priya Varma', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150', 'MacBook Air M2 13"', 'assets/images/h5.png', 'Is the price negotiable?', 'Sep 27', FALSE, 2)
ON CONFLICT (id) DO NOTHING;

-- 6. Chat Messages
INSERT INTO chat_messages (id, conversation_id, sender_id, content, sent_at, is_from_me) VALUES
('msg_1', 'conv_1', 'usr_rohan', 'Hello! Are you interested in the 2022 Hyundai Creta?', NOW() - INTERVAL '3 hours', FALSE),
('msg_2', 'conv_1', 'usr_me', 'Hi Rohan, yes! Can I inspect it tomorrow morning around 11?', NOW() - INTERVAL '2 hours', TRUE),
('msg_3', 'conv_1', 'usr_rohan', 'Yes, You can inspect it tomorrow', NOW() - INTERVAL '30 minutes', FALSE),
('msg_4', 'conv_2', 'usr_urbannest', 'Hello! Your viewing request for 3BHK Kakkanad has been received.', NOW() - INTERVAL '1 day', FALSE),
('msg_5', 'conv_2', 'usr_urbannest', 'The viewing is confirmed for 4 PM', NOW() - INTERVAL '22 hours', FALSE),
('msg_6', 'conv_3', 'usr_priya', 'Is the price negotiable?', NOW() - INTERVAL '2 days', FALSE)
ON CONFLICT (id) DO NOTHING;

-- 7. User Profiles
INSERT INTO user_profiles (id, name, phone, email, address, avatar_url, favorites_count, saved_searches_count, recently_viewed_count, active_enquiries_count) VALUES
('usr_alex_m', 'Alex Morgan', '+7 904 599 xxx 11', 'alexg@gamil.com', 'St. Petersburg, Vos....', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300', 1, 1, 1, 4),
('usr_default', 'Alex Morgan', '+7 904 599 xxx 11', 'alexg@gamil.com', 'St. Petersburg, Vos....', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300', 1, 1, 1, 4)
ON CONFLICT (id) DO NOTHING;

-- 8. User Favorites
INSERT INTO user_favorites (user_id, listing_id) VALUES
('usr_alex_m', 'list_creta_2022'),
('usr_default', 'list_creta_2022')
ON CONFLICT (user_id, listing_id) DO NOTHING;

-- 9. Dealerships
INSERT INTO dealerships (id, name, location, category, rating, badge, image_path) VALUES
('deal_1', 'Apex Motor Hub', 'Kowdiar, Thiruvananthapuram', 'Car Dealership', '4.8', 'Trusted Dealer', 'assets/images/h1.png'),
('deal_2', 'Velocity Pre-Owned Cars', 'HSR Layout, Bengaluru', 'Used Cars', '4.9', 'Verified Dealer', 'assets/images/h1.png')
ON CONFLICT (id) DO NOTHING;

-- 10. Trusted Businesses
INSERT INTO trusted_businesses (id, name, category, rating, verified_listings_count, image_path) VALUES
('biz_1', 'Skyline Prime Realty', 'Property', '4.9', 14, 'assets/images/h2.png'),
('biz_2', 'TechZone Retail', 'Mobiles', '4.7', 28, 'assets/images/h6.png')
ON CONFLICT (id) DO NOTHING;
