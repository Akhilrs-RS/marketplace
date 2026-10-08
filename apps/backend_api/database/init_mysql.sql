-- ============================================================================
-- Galletrix Marketplace MySQL 8.0 Database Schema & Live Data
-- Generated during PostgreSQL -> MySQL Migration
-- ============================================================================
CREATE DATABASE IF NOT EXISTS marketplace_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE marketplace_db;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- 1. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    slug VARCHAR(64) NOT NULL UNIQUE,
    icon_name VARCHAR(64) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Listings Table
CREATE TABLE IF NOT EXISTS listings (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(14, 2) NOT NULL,
    formatted_price VARCHAR(64) NOT NULL,
    location VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    subcategory VARCHAR(64) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    seller_id VARCHAR(64) NOT NULL,
    seller_name VARCHAR(128) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'active',
    is_featured BOOLEAN NOT NULL DEFAULT 0,
    specifications JSON NOT NULL,
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    INDEX idx_listings_category (category),
    INDEX idx_listings_status (status),
    INDEX idx_listings_created_at (created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Vehicle Details Table
CREATE TABLE IF NOT EXISTS vehicle_details (
    listing_id VARCHAR(64) PRIMARY KEY,
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
    highlights JSON NOT NULL,
    CONSTRAINT fk_vehicle_listing FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Seller Metrics Table
CREATE TABLE IF NOT EXISTS seller_metrics (
    seller_id VARCHAR(64) PRIMARY KEY,
    active_listings INT NOT NULL DEFAULT 0,
    total_views INT NOT NULL DEFAULT 0,
    enquiries INT NOT NULL DEFAULT 0,
    messages INT NOT NULL DEFAULT 0,
    growth_percent INT NOT NULL DEFAULT 0,
    period VARCHAR(64) NOT NULL DEFAULT 'This Month',
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Conversations Table
CREATE TABLE IF NOT EXISTS conversations (
    id VARCHAR(64) PRIMARY KEY,
    sender_name VARCHAR(128) NOT NULL,
    sender_avatar VARCHAR(255) NOT NULL,
    item_tag VARCHAR(128) NOT NULL,
    item_thumbnail VARCHAR(255) NOT NULL,
    last_message TEXT NOT NULL,
    timestamp VARCHAR(64) NOT NULL,
    is_buying BOOLEAN NOT NULL DEFAULT 1,
    unread_count INT NOT NULL DEFAULT 0,
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Chat Messages Table
CREATE TABLE IF NOT EXISTS chat_messages (
    id VARCHAR(64) PRIMARY KEY,
    conversation_id VARCHAR(64) NOT NULL,
    sender_id VARCHAR(64) NOT NULL,
    content TEXT NOT NULL,
    sent_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    is_from_me BOOLEAN NOT NULL DEFAULT 0,
    INDEX idx_chat_messages_conv (conversation_id, sent_at ASC),
    CONSTRAINT fk_chat_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. User Favorites Table
CREATE TABLE IF NOT EXISTS user_favorites (
    user_id VARCHAR(64) NOT NULL,
    listing_id VARCHAR(64) NOT NULL,
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (user_id, listing_id),
    CONSTRAINT fk_fav_user FOREIGN KEY (user_id) REFERENCES user_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_fav_listing FOREIGN KEY (listing_id) REFERENCES listings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Dealerships Table
CREATE TABLE IF NOT EXISTS dealerships (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    location VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    rating VARCHAR(16) NOT NULL,
    badge VARCHAR(64) NOT NULL DEFAULT 'Trusted Dealer',
    image_path VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. Trusted Businesses Table
CREATE TABLE IF NOT EXISTS trusted_businesses (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    rating VARCHAR(16) NOT NULL,
    verified_listings_count INT NOT NULL DEFAULT 0,
    image_path VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data for categories (8 rows)
INSERT IGNORE INTO `categories` (`id`, `name`, `slug`, `icon_name`, `image_url`, `created_at`) VALUES
('cat_vehicles', 'Vehicles', 'vehicles', 'directions_car', 'assets/images/h1.png', '2026-09-30 04:39:53.026438'),
('cat_property', 'Property', 'property', 'home_work', 'assets/images/h2.png', '2026-09-30 04:39:53.026438'),
('cat_jobs', 'Jobs', 'jobs', 'work', 'assets/images/h3.png', '2026-09-30 04:39:53.026438'),
('cat_groceries', 'Groceries', 'groceries', 'local_grocery_store', 'assets/images/h4.png', '2026-09-30 04:39:53.026438'),
('cat_electronics', 'Electronics', 'electronics', 'devices', 'assets/images/h5.png', '2026-09-30 04:39:53.026438'),
('cat_mobiles', 'Mobiles', 'mobiles', 'phone_android', 'assets/images/h6.png', '2026-09-30 04:39:53.026438'),
('cat_services', 'Services', 'services', 'handyman', 'assets/images/h7.png', '2026-09-30 04:39:53.026438'),
('cat_furniture', 'Furniture', 'furniture', 'chair', 'assets/images/h8.png', '2026-09-30 04:39:53.026438')
;

-- Data for listings (25 rows)
INSERT IGNORE INTO `listings` (`id`, `title`, `price`, `formatted_price`, `location`, `category`, `subcategory`, `image_path`, `description`, `seller_id`, `seller_name`, `status`, `is_featured`, `specifications`, `created_at`, `updated_at`) VALUES
('list_creta_2022', '2022 Hyundai Creta EX', 725000.0, '₹ 7,25,000', 'Thiruvananthapuram', 'Vehicles', 'Car', 'assets/images/h1.png', 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience.', 'ven_hyundai_hub', 'Hyundai Auto Hub', 'active', 1, '{"owner": "1st Owner • Verified", "fuel_type": "Petrol", "transmission": "Automatic", "engine_output": "500 HP", "highest_speed": "200 KM/H", "total_capacity": "6 Seats"}', '2026-09-30 00:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_apt_kowdiar', '3BHK Apartment - Kowdiar', 9500000.0, '₹ 95,00,000', 'Thiruvananthapuram', 'Property', 'Apartment', 'assets/images/h2.png', 'Luxury 3BHK premium apartment with scenic balcony view, high-end fittings, and covered parking.', 'ven_skyline', 'Skyline Prime Realty', 'active', 1, '{"bedrooms": "3 BHK", "furnishing": "Semi-Furnished", "super_area": "1,850 sqft"}', '2026-09-29 20:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_apt_sushil', 'Sushil 2BHK Apartment', 42000.0, '₹ 42,000 /mo', 'HSR Layout, Bengaluru', 'Property', 'Rent', 'assets/images/h8.png', 'Spacious 2BHK ready-to-move apartment located in prime HSR Layout Sector 2.', 'ven_sushil_props', 'Sushil Properties', 'active', 1, '{}', '2026-09-29 16:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_oak_dining_1', 'Solid Oak Dining Table', 725000.0, '₹ 7,25,000', 'HSR Layout, Bengaluru', 'Furniture', 'Dining Sets', 'assets/images/h.png', 'Handcrafted solid European oak dining table with seating for up to 8 guests.', 'ven_woodcraft', 'Heritage Woodcraft', 'active', 0, '{}', '2026-09-29 04:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_phone_flagship', 'Flagship Phone - 256GB', 62900.0, '₹ 62,900', 'Thiruvananthapuram', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Brand new condition, 100% battery health, original bill, box and complete accessories.', 'ven_tech_zone', 'TechZone Retail', 'active', 1, '{}', '2026-09-29 02:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_job_frontend', 'Senior Frontend Engineer', 2400000.0, '₹ 18 - 24 LPA', 'Bengaluru', 'Jobs', 'Engineering', 'assets/images/h3.png', 'Join a hyper-growth venture building cross-platform Flutter and Next.js applications.', 'ven_galletrix_hr', 'Galletrix Talent', 'active', 1, '{}', '2026-09-28 04:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_apt_kakkanad', '3BHK Apartment in Kakkanad', 12500000.0, '₹ 1.25 Crore', 'Bengaluru', 'Property', 'Apartment', 'assets/images/h2.png', 'Overlooking Infopark with premium clubhouse amenities, swimming pool, and 24x7 security.', 'ven_urban_nest', 'Urban Nest Realty', 'active', 0, '{}', '2026-09-27 23:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_veg_combo', 'Organic Vegetables Combo Pack', 499.0, '₹ 499', 'Kakkanad', 'Groceries', 'Vegetables', 'assets/images/h4.png', 'Fresh organic farm-picked daily essential vegetables box (5kg assortment).', 'ven_green_harvest', 'Green Harvest Farms', 'active', 0, '{}', '2026-09-27 04:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_clean_service', 'Home Deep Cleaning Service', 2500.0, '₹ 2,500', 'Kakkanad', 'Services', 'Cleaning', 'assets/images/h7.png', 'Comprehensive 4-hour home sanitization and deep cleaning by verified professionals.', 'ven_clean_pros', 'Urban Clean Pros', 'active', 0, '{}', '2026-09-27 00:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_macbook_m2', 'MacBook Air M2 13"', 98000.0, '₹ 98,000', 'Kochi', 'Mobiles', 'Laptops', 'assets/images/h5.png', 'Apple M2 chip, 8GB unified memory, 256GB SSD, Midnight finish with AppleCare+ warranty.', 'ven_alex_m', 'Alex Morgan', 'active', 1, '{}', '2026-09-26 04:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_iphone_15_pro', 'iPhone 15 Pro Max 256GB', 134900.0, '₹ 1,34,900', 'Indiranagar, Bengaluru', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Natural Titanium, immaculate condition with Apple warranty till December.', 'ven_premium_tech', 'Premium Tech Hub', 'active', 1, '{}', '2026-09-26 02:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_s24_ultra', 'Samsung Galaxy S24 Ultra 5G', 109999.0, '₹ 1,09,999', 'HSR Layout, Bengaluru', 'Mobiles', 'Smartphones', 'assets/images/h6.png', 'Titanium Gray 12GB/512GB, Galaxy AI unlocked with S-Pen.', 'ven_galaxy_hub', 'Galaxy Official Reseller', 'active', 1, '{}', '2026-09-25 22:39:53.026965', '2026-09-30 04:39:53.026965'),
('list_test_permanent_persistence', '2024 BMW M4 Competition (Permanent Storage Test)', 9500000.0, '₹ 95,00,000', 'Bengaluru', 'Vehicles', 'Car', 'assets/images/h1.png', 'Permanently stored in PostgreSQL Docker volume', 'ven_test', 'Premium Cars', 'active', 0, '{"drive": "AWD", "power": "503 HP"}', '2026-09-30 04:41:25.683903', '2026-09-30 04:41:25.687917'),
('list_1790743504350', '2023 Porsche 911 GT3', 27500000.0, '₹ 2,75,00,000', 'Mumbai', 'Vehicles', 'Car', 'assets/images/h1.png', 'Track-focused masterpiece', 'usr_porsche', 'Porsche Centre', 'active', 0, '{}', '2026-09-30 04:45:04.350651', '2026-09-30 04:45:04.351794'),
('list_car_1790745986200', '2023 Tata Harrier XZ+', 1820000.0, '₹ 18,20,000', 'Kochi', 'Vehicles', 'Car', 'assets/images/h1.png', 'Top end diesel automatic with panoramic sunroof.', 'ven_user', 'Alex Morgan', 'Active', 0, '{}', '2026-09-30 05:26:26.259426', '2026-09-30 05:26:26.270701'),
('list_tech_1790756781897', 'iPad Pro 11" M2 256GB', 79900.0, '₹ 79,900', 'Bengaluru', 'Mobiles', 'Tablets', 'assets/images/h6.png', 'Space Gray, mint condition with Apple Pencil 2.', 'ven_user', 'Alex Morgan', 'Active', 0, '{}', '2026-09-30 08:26:21.947535', '2026-09-30 08:26:21.949131'),
('lst_1790758076180', 'iPhone 15 Pro Max 256GB Natural Titanium', 98000.0, '₹ 98,000', 'Kochi, Kerala', 'Mobiles & Tablets', 'Smartphones', 'assets/images/h6.png', 'Battery health 99%, flawless condition with tempered glass applied since day one. Includes original box and bill.', 'user_alex', 'Alex Morgan', 'Active', 0, '{"Brand": "Apple", "Storage": "256GB", "Warranty": "Brand Warranty Active", "Condition": "Like New", "Subcategory": "Smartphones"}', '2026-09-30 08:47:57.944654', '2026-09-30 08:47:57.945986'),
('list_1791278572649', 'Iphone', 34000.0, '₹ 34,000', 'Thiruvananthapuram', 'Electronics', 'General', 'assets/images/h2.png', 'iPhone 13', 'usr_default', 'Alex Morgan', 'active', 0, '{"owner": "1st Owner • Verified", "fuel_type": "Petrol", "transmission": "Automatic", "total_capacity": "5 Seats"}', '2026-10-06 09:22:52.701059', '2026-10-06 09:22:52.70221'),
('list_1791284658623', 'Iphone', 34000.0, '₹ 34,000', 'Thiruvananthapuram', 'Electronics', 'General', 'assets/images/h2.png', 'iPhone 13', 'usr_default', 'Alex Morgan', 'active', 0, '{"owner": "1st Owner • Verified", "fuel_type": "Petrol", "transmission": "Automatic", "total_capacity": "5 Seats"}', '2026-10-06 11:04:18.661534', '2026-10-06 11:04:18.663949'),
('list_test_post_ad_123', '2023 Hyundai Tucson Signature AWD', 1450000.0, '₹ 14,50,000', 'Kochi', 'Vehicles', 'Car', 'assets/images/h1.png', 'Test listing from curl', 'usr_default', 'Alex Morgan', 'active', 0, '{}', '2026-10-06 11:06:42.093956', '2026-10-06 11:06:42.094512'),
('list_test_ping_456', 'Ping Test Listing', 450000.0, '₹ 4,50,000', 'Kochi', 'Vehicles', '', 'assets/images/h.png', 'Test Ping Ad', 'ven_alex_m', 'Alex Morgan', 'active', 0, '{}', '2026-10-06 11:18:03.114943', '2026-10-06 11:18:03.115832'),
('list_1791286498202', '2023 Hyundai Tucson AWD', 2850000.0, '₹ 28,50,000', 'Kochi', 'Vehicles', 'Car', '/images/h1.png', 'Top-end AWD variant, single owner, panoramic sunroof, verified service history.', 'usr_current_user', 'You (Alex Morgan)', 'active', 1, '{"owner": "1st Owner • Verified", "fuel_type": "Diesel", "transmission": "Automatic", "total_capacity": "5 Seats"}', '2026-10-06 11:34:58.279262', '2026-10-06 11:34:58.280479'),
('list_1791349637271', 'hyndai', 34000.0, '₹ 34,000', 'Kochi', 'Vehicles', 'Car', '/images/h1.png', 'mkgki', 'usr_current_user', 'You (Alex Morgan)', 'active', 1, '{"owner": "1st Owner • Verified", "fuel_type": "Petrol", "transmission": "Automatic", "total_capacity": "5 Seats"}', '2026-10-07 05:07:17.293714', '2026-10-07 05:07:17.29432'),
('list_test_mobile_101', 'Apple iPhone 15 Pro Max 256GB', 128000.0, '₹ 1,28,000', 'Kochi', 'Mobiles', 'Smartphones', 'assets/images/h.png', 'Natural Titanium, flawless with box', 'ven_alex_m', 'Alex Morgan', 'active', 0, '{"brand": "Apple", "storage": "256 GB", "battery_health": "98%"}', '2026-10-07 05:40:30.929743', '2026-10-07 05:40:30.932805'),
('list_1791357264921', 'apple iphone', 72000.0, '₹ 72,000', 'Kakkanad, Kochi', 'Mobiles', 'Mobile Phones', 'blob:http://localhost:5173/9ca6798f-0e1a-4b7b-a432-8ef60a1b5176', 'good', 'usr_current_user', 'Alex Morgan', 'active', 1, '{"ram": "4 GB", "brand": "Apple", "model": "15 pro max", "storage": "64 GB", "condition": "Gently Used • Excellent", "inclusions": "Device Only", "battery_health": "98"}', '2026-10-07 07:14:24.956877', '2026-10-07 07:14:24.957576')
;

-- Data for vehicle_details (1 rows)
INSERT IGNORE INTO `vehicle_details` (`listing_id`, `title`, `price`, `image_path`, `location`, `total_capacity`, `highest_speed`, `engine_output`, `fuel_type`, `transmission`, `owner`, `description`, `highlights`) VALUES
('list_creta_2022', 'Hyundai Creta SX', '₹ 7,25,000', 'assets/images/h1.png', 'Thiruvananthapuram', '6 Seats', '200 KM/H', '500 HP', 'Petrol', 'Automatic', '1st Owner • Verified', 'The Hyundai Creta SX combines bold styling, advanced technology, and a comfortable driving experience featuring a panoramic sunroof, premium upholstery, and wireless connectivity.', '["Panoramic Sunroof", "Bose 8-Speaker Audio", "Wireless Phone Charger", "Full Service Record Available"]')
;

-- Data for seller_metrics (2 rows)
INSERT IGNORE INTO `seller_metrics` (`seller_id`, `active_listings`, `total_views`, `enquiries`, `messages`, `growth_percent`, `period`, `updated_at`) VALUES
('ven_alex_m', 12, 2400, 38, 7, 16, 'This Month', '2026-09-30 04:39:53.028396'),
('ven_default', 12, 2400, 38, 7, 16, 'This Month', '2026-09-30 04:39:53.028396')
;

-- Data for conversations (3 rows)
INSERT IGNORE INTO `conversations` (`id`, `sender_name`, `sender_avatar`, `item_tag`, `item_thumbnail`, `last_message`, `timestamp`, `is_buying`, `unread_count`, `updated_at`) VALUES
('conv_2', 'Urban Nest Realty', 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150', '3BHK Kakkanad Apartment', 'assets/images/h2.png', 'The viewing is confirmed for 4 PM', 'Yesterday', 1, 0, '2026-09-30 04:39:53.028688'),
('conv_3', 'Priya Varma', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150', 'MacBook Air M2 13"', 'assets/images/h5.png', 'Is the price negotiable?', 'Sep 27', 0, 2, '2026-09-30 04:39:53.028688'),
('conv_1', 'Rohan Sharma', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', 'Hyundai Creta 2022', 'assets/images/h1.png', 'rwrtrwsy', 'Just now', 1, 1, '2026-09-30 09:27:29.240584')
;

-- Data for chat_messages (7 rows)
INSERT IGNORE INTO `chat_messages` (`id`, `conversation_id`, `sender_id`, `content`, `sent_at`, `is_from_me`) VALUES
('msg_1', 'conv_1', 'usr_rohan', 'Hello! Are you interested in the 2022 Hyundai Creta?', '2026-09-30 01:39:53.028976', 0),
('msg_2', 'conv_1', 'usr_me', 'Hi Rohan, yes! Can I inspect it tomorrow morning around 11?', '2026-09-30 02:39:53.028976', 1),
('msg_3', 'conv_1', 'usr_rohan', 'Yes, You can inspect it tomorrow', '2026-09-30 04:09:53.028976', 0),
('msg_4', 'conv_2', 'usr_urbannest', 'Hello! Your viewing request for 3BHK Kakkanad has been received.', '2026-09-29 04:39:53.028976', 0),
('msg_5', 'conv_2', 'usr_urbannest', 'The viewing is confirmed for 4 PM', '2026-09-29 06:39:53.028976', 0),
('msg_6', 'conv_3', 'usr_priya', 'Is the price negotiable?', '2026-09-28 04:39:53.028976', 0),
('msg_1790760449223', 'conv_1', 'usr_me', 'rwrtrwsy', '2026-09-30 09:27:29.223978', 1)
;

-- Data for user_profiles (2 rows)
INSERT IGNORE INTO `user_profiles` (`id`, `name`, `phone`, `email`, `address`, `avatar_url`, `favorites_count`, `saved_searches_count`, `recently_viewed_count`, `active_enquiries_count`, `updated_at`) VALUES
('usr_alex_m', 'Alex Morgan', '+7 904 599 xxx 11', 'alexg@gamil.com', 'St. Petersburg, Vos....', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300', 1, 1, 1, 4, '2026-09-30 04:39:53.029492'),
('usr_default', 'Alex Morgan', '+7 904 599 xxx 11', 'alexg@gamil.com', 'St. Petersburg, Vos....', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300', 1, 1, 1, 4, '2026-09-30 04:39:53.029492')
;

-- Data for user_favorites (2 rows)
INSERT IGNORE INTO `user_favorites` (`user_id`, `listing_id`, `created_at`) VALUES
('usr_alex_m', 'list_creta_2022', '2026-09-30 04:39:53.029789'),
('usr_default', 'list_creta_2022', '2026-09-30 04:39:53.029789')
;

-- Data for dealerships (2 rows)
INSERT IGNORE INTO `dealerships` (`id`, `name`, `location`, `category`, `rating`, `badge`, `image_path`) VALUES
('deal_1', 'Apex Motor Hub', 'Kowdiar, Thiruvananthapuram', 'Car Dealership', '4.8', 'Trusted Dealer', 'assets/images/h1.png'),
('deal_2', 'Velocity Pre-Owned Cars', 'HSR Layout, Bengaluru', 'Used Cars', '4.9', 'Verified Dealer', 'assets/images/h1.png')
;

-- Data for trusted_businesses (2 rows)
INSERT IGNORE INTO `trusted_businesses` (`id`, `name`, `category`, `rating`, `verified_listings_count`, `image_path`) VALUES
('biz_1', 'Skyline Prime Realty', 'Property', '4.9', 14, 'assets/images/h2.png'),
('biz_2', 'TechZone Retail', 'Mobiles', '4.7', 28, 'assets/images/h6.png')
;

SET FOREIGN_KEY_CHECKS = 1;
