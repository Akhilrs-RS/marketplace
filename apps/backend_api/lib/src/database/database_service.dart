import 'dart:convert';
import 'dart:io';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_models/shared_models.dart';
import '../data/mock_database.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  MySQLConnectionPool? _pool;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    final host = Platform.environment['DB_HOST'];
    if (host == null || host.isEmpty) {
      print('ℹ️ DB_HOST not set. Using in-memory MockDatabase storage.');
      return;
    }

    final portStr = Platform.environment['DB_PORT'] ?? '3306';
    final port = int.tryParse(portStr) ?? 3306;
    final database = Platform.environment['DB_NAME'] ?? 'marketplace_db';
    final username = Platform.environment['DB_USER'] ?? 'marketplace_user';
    final password = Platform.environment['DB_PASSWORD'] ?? 'marketplace_secret_pw';

    try {
      _pool = MySQLConnectionPool(
        host: host,
        port: port,
        userName: username,
        password: password,
        maxConnections: 5,
        databaseName: database,
      );

      // Verify connection
      final res = await _pool!.execute('SELECT 1');
      if (res.rows.isNotEmpty) {
        _isConnected = true;
        print('✅ Connected to MySQL ($host:$port/$database)');
      }
    } catch (e) {
      print('⚠️ Failed to connect to MySQL ($host:$port): $e');
      print('ℹ️ Falling back to in-memory MockDatabase.');
      _isConnected = false;
    }
  }

  Future<void> close() async {
    if (_pool != null) {
      await _pool!.close();
      _pool = null;
      _isConnected = false;
    }
  }

  // ===========================================================================
  // 1. Categories
  // ===========================================================================
  Future<List<Category>> getCategories() async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.categories;
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, name, slug, icon_name, image_url FROM categories ORDER BY id ASC',
      );
      return result.rows.map((row) {
        final map = row.typedAssoc();
        return Category(
          id: map['id'].toString(),
          name: map['name'].toString(),
          slug: map['slug'].toString(),
          iconName: map['icon_name'].toString(),
          imageUrl: map['image_url'].toString(),
        );
      }).toList();
    } catch (e) {
      print('Error querying categories: $e');
      return MockDatabase.categories;
    }
  }

  // ===========================================================================
  // 2. Listings
  // ===========================================================================
  Future<List<MarketListing>> getListings({
    String? category,
    String? subcategory,
    String? q,
    String? status,
    String? sort,
  }) async {
    if (!_isConnected || _pool == null) {
      var list = List<MarketListing>.from(MockDatabase.listings);
      if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
        list = list.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
      }
      if (subcategory != null && subcategory.isNotEmpty) {
        list = list.where((e) => e.subcategory.toLowerCase() == subcategory.toLowerCase()).toList();
      }
      if (q != null && q.isNotEmpty) {
        final query = q.toLowerCase();
        list = list.where((e) =>
            e.title.toLowerCase().contains(query) ||
            e.location.toLowerCase().contains(query) ||
            e.category.toLowerCase().contains(query) ||
            e.formattedPrice.toLowerCase().contains(query)).toList();
      }
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        list = list.where((e) => e.status.toLowerCase() == status.toLowerCase()).toList();
      }
      return list;
    }

    try {
      final conditions = <String>[];
      final parameters = <String, dynamic>{};

      if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
        conditions.add('LOWER(category) = LOWER(:category)');
        parameters['category'] = category;
      }
      if (subcategory != null && subcategory.isNotEmpty) {
        conditions.add('LOWER(subcategory) = LOWER(:subcategory)');
        parameters['subcategory'] = subcategory;
      }
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        conditions.add('LOWER(status) = LOWER(:status)');
        parameters['status'] = status;
      }
      if (q != null && q.isNotEmpty) {
        conditions.add('(LOWER(title) LIKE :q OR LOWER(location) LIKE :q OR LOWER(category) LIKE :q OR LOWER(formatted_price) LIKE :q)');
        parameters['q'] = '%${q.toLowerCase()}%';
      }

      var sqlQuery = 'SELECT id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at FROM listings';
      if (conditions.isNotEmpty) {
        sqlQuery += ' WHERE ${conditions.join(' AND ')}';
      }

      if (sort == 'price_low') {
        sqlQuery += ' ORDER BY price ASC';
      } else if (sort == 'price_high') {
        sqlQuery += ' ORDER BY price DESC';
      } else {
        sqlQuery += ' ORDER BY created_at DESC';
      }

      final result = await _pool!.execute(sqlQuery, parameters);

      return result.rows.map((row) {
        final map = row.typedAssoc();
        Map<String, dynamic> specs = {};
        final specVal = map['specifications'];
        if (specVal != null) {
          if (specVal is Map) {
            specs = Map<String, dynamic>.from(specVal);
          } else if (specVal is String) {
            try {
              specs = jsonDecode(specVal) as Map<String, dynamic>;
            } catch (_) {}
          }
        }

        final isFeaturedVal = map['is_featured'];
        final isFeatured = isFeaturedVal == true || isFeaturedVal == 1 || isFeaturedVal == '1';

        final createdAtVal = map['created_at'];
        DateTime createdAt = DateTime.now();
        if (createdAtVal is DateTime) {
          createdAt = createdAtVal;
        } else if (createdAtVal is String) {
          createdAt = DateTime.tryParse(createdAtVal) ?? DateTime.now();
        }

        return MarketListing(
          id: map['id'].toString(),
          title: map['title'].toString(),
          price: _parsePrice(map['price']),
          formattedPrice: map['formatted_price'].toString(),
          location: map['location'].toString(),
          category: map['category'].toString(),
          subcategory: map['subcategory'].toString(),
          imagePath: map['image_path'].toString(),
          description: map['description']?.toString() ?? '',
          sellerId: map['seller_id'].toString(),
          sellerName: map['seller_name'].toString(),
          status: map['status']?.toString() ?? 'active',
          isFeatured: isFeatured,
          specifications: specs,
          createdAt: createdAt,
        );
      }).toList();
    } catch (e) {
      print('Error querying listings from MySQL: $e');
      return MockDatabase.listings;
    }
  }

  Future<MarketListing?> getListingById(String id) async {
    if (!_isConnected || _pool == null) {
      try {
        return MockDatabase.listings.firstWhere((e) => e.id == id);
      } catch (_) {
        return null;
      }
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at FROM listings WHERE id = :id LIMIT 1',
        {'id': id},
      );

      if (result.rows.isEmpty) return null;
      final map = result.rows.first.typedAssoc();
      Map<String, dynamic> specs = {};
      final specVal = map['specifications'];
      if (specVal != null) {
        if (specVal is Map) {
          specs = Map<String, dynamic>.from(specVal);
        } else if (specVal is String) {
          try {
            specs = jsonDecode(specVal) as Map<String, dynamic>;
          } catch (_) {}
        }
      }

      final isFeaturedVal = map['is_featured'];
      final isFeatured = isFeaturedVal == true || isFeaturedVal == 1 || isFeaturedVal == '1';

      final createdAtVal = map['created_at'];
      DateTime createdAt = DateTime.now();
      if (createdAtVal is DateTime) {
        createdAt = createdAtVal;
      } else if (createdAtVal is String) {
        createdAt = DateTime.tryParse(createdAtVal) ?? DateTime.now();
      }

      return MarketListing(
        id: map['id'].toString(),
        title: map['title'].toString(),
        price: _parsePrice(map['price']),
        formattedPrice: map['formatted_price'].toString(),
        location: map['location'].toString(),
        category: map['category'].toString(),
        subcategory: map['subcategory'].toString(),
        imagePath: map['image_path'].toString(),
        description: map['description']?.toString() ?? '',
        sellerId: map['seller_id'].toString(),
        sellerName: map['seller_name'].toString(),
        status: map['status']?.toString() ?? 'active',
        isFeatured: isFeatured,
        specifications: specs,
        createdAt: createdAt,
      );
    } catch (e) {
      print('Error querying listing by id: $e');
      return null;
    }
  }

  Future<MarketListing> createListing(MarketListing listing) async {
    // Keep in-memory updated as well
    MockDatabase.listings.insert(0, listing);

    if (!_isConnected || _pool == null) {
      return listing;
    }

    try {
      await _pool!.execute(
        '''
          INSERT INTO listings (id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at)
          VALUES (:id, :title, :price, :formatted_price, :location, :category, :subcategory, :image_path, :description, :seller_id, :seller_name, :status, :is_featured, :specifications, :created_at)
          ON DUPLICATE KEY UPDATE
            title = VALUES(title),
            price = VALUES(price),
            formatted_price = VALUES(formatted_price),
            status = VALUES(status)
        ''',
        {
          'id': listing.id,
          'title': listing.title,
          'price': listing.price,
          'formatted_price': listing.formattedPrice,
          'location': listing.location,
          'category': listing.category,
          'subcategory': listing.subcategory,
          'image_path': listing.imagePath,
          'description': listing.description,
          'seller_id': listing.sellerId,
          'seller_name': listing.sellerName,
          'status': listing.status,
          'is_featured': listing.isFeatured ? 1 : 0,
          'specifications': jsonEncode(listing.specifications),
          'created_at': listing.createdAt.toIso8601String(),
        },
      );
    } catch (e) {
      print('Error inserting listing into MySQL: $e');
    }

    return listing;
  }

  Future<MarketListing?> updateListing(String id, Map<String, dynamic> updates) async {
    final existing = await getListingById(id);
    if (existing == null) return null;

    final updated = existing.copyWith(
      title: updates['title'] as String?,
      price: updates['price'] != null ? _parsePrice(updates['price']) : null,
      formattedPrice: updates['formatted_price'] as String?,
      location: updates['location'] as String?,
      status: updates['status'] as String?,
      isFeatured: updates['is_featured'] as bool?,
      description: updates['description'] as String?,
      imagePath: (updates['image_path'] ?? updates['imagePath']) as String?,
    );

    // Update in-memory
    final idx = MockDatabase.listings.indexWhere((e) => e.id == id);
    if (idx != -1) MockDatabase.listings[idx] = updated;

    if (_isConnected && _pool != null) {
      try {
        await _pool!.execute(
          '''
            UPDATE listings
            SET title = :title, price = :price, formatted_price = :formatted_price, location = :location, status = :status, is_featured = :is_featured, description = :description, image_path = :image_path, updated_at = NOW()
            WHERE id = :id
          ''',
          {
            'id': id,
            'title': updated.title,
            'price': updated.price,
            'formatted_price': updated.formattedPrice,
            'location': updated.location,
            'status': updated.status,
            'is_featured': updated.isFeatured ? 1 : 0,
            'description': updated.description,
            'image_path': updated.imagePath,
          },
        );
      } catch (e) {
        print('Error updating listing in MySQL: $e');
      }
    }

    return updated;
  }

  Future<bool> deleteListing(String id) async {
    MockDatabase.listings.removeWhere((e) => e.id == id);

    if (!_isConnected || _pool == null) return true;

    try {
      final res = await _pool!.execute('DELETE FROM listings WHERE id = :id', {'id': id});
      return res.affectedRows.toInt() > 0;
    } catch (e) {
      print('Error deleting listing: $e');
      return false;
    }
  }

  // ===========================================================================
  // 3. Vehicles
  // ===========================================================================
  Future<VehicleDetail?> getVehicleDetail(String id) async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.vehicleDetails[id];
    }

    try {
      final result = await _pool!.execute(
        'SELECT listing_id, title, price, image_path, location, total_capacity, highest_speed, engine_output, fuel_type, transmission, owner, description, highlights FROM vehicle_details WHERE listing_id = :id LIMIT 1',
        {'id': id},
      );

      if (result.rows.isEmpty) return MockDatabase.vehicleDetails[id];
      final map = result.rows.first.typedAssoc();

      List<String> hl = [];
      final hlVal = map['highlights'];
      if (hlVal != null) {
        if (hlVal is List) {
          hl = hlVal.map((e) => e.toString()).toList();
        } else if (hlVal is String) {
          try {
            final decoded = jsonDecode(hlVal);
            if (decoded is List) {
              hl = decoded.map((e) => e.toString()).toList();
            }
          } catch (_) {}
        }
      }

      return VehicleDetail(
        listingId: map['listing_id'].toString(),
        title: map['title'].toString(),
        price: map['price'].toString(),
        imagePath: map['image_path'].toString(),
        location: map['location'].toString(),
        totalCapacity: map['total_capacity'].toString(),
        highestSpeed: map['highest_speed'].toString(),
        engineOutput: map['engine_output'].toString(),
        fuelType: map['fuel_type'].toString(),
        transmission: map['transmission'].toString(),
        owner: map['owner'].toString(),
        description: map['description']?.toString() ?? '',
        highlights: hl,
      );
    } catch (e) {
      print('Error querying vehicle details: $e');
      return MockDatabase.vehicleDetails[id];
    }
  }

  // ===========================================================================
  // 4. Seller Dashboard
  // ===========================================================================
  Future<SellerMetrics> getSellerMetrics(String sellerId) async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.sellerMetrics;
    }

    try {
      final result = await _pool!.execute(
        'SELECT active_listings, total_views, enquiries, messages, growth_percent, period FROM seller_metrics WHERE seller_id = :seller_id LIMIT 1',
        {'seller_id': sellerId},
      );

      if (result.rows.isEmpty) {
        return MockDatabase.sellerMetrics;
      }

      final map = result.rows.first.typedAssoc();
      return SellerMetrics(
        activeListings: (map['active_listings'] as num?)?.toInt() ?? 12,
        totalViews: (map['total_views'] as num?)?.toInt() ?? 2400,
        enquiries: (map['enquiries'] as num?)?.toInt() ?? 38,
        messages: (map['messages'] as num?)?.toInt() ?? 7,
        growthPercent: (map['growth_percent'] as num?)?.toInt() ?? 16,
        period: map['period']?.toString() ?? 'This Month',
      );
    } catch (e) {
      print('Error querying seller metrics: $e');
      return MockDatabase.sellerMetrics;
    }
  }

  // ===========================================================================
  // 5. Conversations & Messages
  // ===========================================================================
  Future<List<ConversationSummary>> getConversations({required bool isBuying}) async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.conversations.where((c) => c.isBuying == isBuying).toList();
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, sender_name, sender_avatar, item_tag, item_thumbnail, last_message, timestamp, is_buying, unread_count FROM conversations WHERE is_buying = :is_buying ORDER BY updated_at DESC',
        {'is_buying': isBuying ? 1 : 0},
      );

      return result.rows.map((row) {
        final map = row.typedAssoc();
        final isBuyingVal = map['is_buying'];
        final isBuyingParsed = isBuyingVal == true || isBuyingVal == 1 || isBuyingVal == '1';

        return ConversationSummary(
          id: map['id'].toString(),
          senderName: map['sender_name'].toString(),
          senderAvatar: map['sender_avatar'].toString(),
          itemTag: map['item_tag'].toString(),
          itemThumbnail: map['item_thumbnail'].toString(),
          lastMessage: map['last_message']?.toString() ?? '',
          timestamp: map['timestamp']?.toString() ?? '',
          isBuying: isBuyingParsed,
          unreadCount: (map['unread_count'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Error querying conversations: $e');
      return MockDatabase.conversations.where((c) => c.isBuying == isBuying).toList();
    }
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.messages[conversationId] ?? [];
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, conversation_id, sender_id, content, sent_at, is_from_me FROM chat_messages WHERE conversation_id = :conv_id ORDER BY sent_at ASC',
        {'conv_id': conversationId},
      );

      return result.rows.map((row) {
        final map = row.typedAssoc();
        final sentAtVal = map['sent_at'];
        DateTime sentAt = DateTime.now();
        if (sentAtVal is DateTime) {
          sentAt = sentAtVal;
        } else if (sentAtVal is String) {
          sentAt = DateTime.tryParse(sentAtVal) ?? DateTime.now();
        }

        final isFromMeVal = map['is_from_me'];
        final isFromMeParsed = isFromMeVal == true || isFromMeVal == 1 || isFromMeVal == '1';

        return ChatMessage(
          id: map['id'].toString(),
          conversationId: map['conversation_id'].toString(),
          senderId: map['sender_id'].toString(),
          content: map['content']?.toString() ?? '',
          sentAt: sentAt,
          isFromMe: isFromMeParsed,
        );
      }).toList();
    } catch (e) {
      print('Error querying chat messages: $e');
      return MockDatabase.messages[conversationId] ?? [];
    }
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String content,
    required String senderId,
    required bool isFromMe,
  }) async {
    final now = DateTime.now();
    final msg = ChatMessage(
      id: 'msg_${now.millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      sentAt: now,
      isFromMe: isFromMe,
    );

    MockDatabase.messages.putIfAbsent(conversationId, () => []).add(msg);

    if (_isConnected && _pool != null) {
      try {
        await _pool!.execute(
          '''
            INSERT INTO chat_messages (id, conversation_id, sender_id, content, sent_at, is_from_me)
            VALUES (:id, :conversation_id, :sender_id, :content, :sent_at, :is_from_me)
          ''',
          {
            'id': msg.id,
            'conversation_id': msg.conversationId,
            'sender_id': msg.senderId,
            'content': msg.content,
            'sent_at': msg.sentAt.toIso8601String(),
            'is_from_me': msg.isFromMe ? 1 : 0,
          },
        );

        // Update last message in conversation
        await _pool!.execute(
          '''
            UPDATE conversations
            SET last_message = :content, timestamp = 'Just now', updated_at = NOW()
            WHERE id = :conv_id
          ''',
          {
            'content': msg.content,
            'conv_id': conversationId,
          },
        );
      } catch (e) {
        print('Error inserting chat message: $e');
      }
    }

    return msg;
  }

  // ===========================================================================
  // 6. User Profile & Favorites
  // ===========================================================================
  Future<UserProfile> getUserProfile(String userId) async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.userProfile;
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, name, phone, email, address, avatar_url, favorites_count, saved_searches_count, recently_viewed_count, active_enquiries_count FROM user_profiles WHERE id = :id LIMIT 1',
        {'id': userId},
      );

      if (result.rows.isEmpty) {
        return MockDatabase.userProfile;
      }

      final map = result.rows.first.typedAssoc();
      return UserProfile(
        id: map['id'].toString(),
        name: map['name'].toString(),
        phone: map['phone'].toString(),
        email: map['email'].toString(),
        address: map['address'].toString(),
        avatarUrl: map['avatar_url'].toString(),
        favoritesCount: (map['favorites_count'] as num?)?.toInt() ?? 1,
        savedSearchesCount: (map['saved_searches_count'] as num?)?.toInt() ?? 1,
        recentlyViewedCount: (map['recently_viewed_count'] as num?)?.toInt() ?? 1,
        activeEnquiriesCount: (map['active_enquiries_count'] as num?)?.toInt() ?? 4,
      );
    } catch (e) {
      print('Error querying user profile: $e');
      return MockDatabase.userProfile;
    }
  }

  Future<bool> toggleFavorite({required String userId, required String listingId}) async {
    final willFavorite = !MockDatabase.favoriteListingIds.contains(listingId);
    if (willFavorite) {
      MockDatabase.favoriteListingIds.add(listingId);
    } else {
      MockDatabase.favoriteListingIds.remove(listingId);
    }

    if (_isConnected && _pool != null) {
      try {
        if (willFavorite) {
          await _pool!.execute(
            'INSERT IGNORE INTO user_favorites (user_id, listing_id, created_at) VALUES (:user_id, :listing_id, NOW())',
            {'user_id': userId, 'listing_id': listingId},
          );
        } else {
          await _pool!.execute(
            'DELETE FROM user_favorites WHERE user_id = :user_id AND listing_id = :listing_id',
            {'user_id': userId, 'listing_id': listingId},
          );
        }
      } catch (e) {
        print('Error toggling favorite in MySQL: $e');
      }
    }

    return willFavorite;
  }

  // ===========================================================================
  // 7. Dealerships & Trusted Businesses
  // ===========================================================================
  Future<List<VehicleDealershipModel>> getDealerships() async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.dealerships;
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, name, location, category, rating, badge, image_path FROM dealerships',
      );
      return result.rows.map((row) {
        final map = row.typedAssoc();
        return VehicleDealershipModel(
          id: map['id'].toString(),
          name: map['name'].toString(),
          location: map['location'].toString(),
          category: map['category'].toString(),
          rating: map['rating'].toString(),
          badge: map['badge']?.toString() ?? 'Trusted Dealer',
          imagePath: map['image_path'].toString(),
        );
      }).toList();
    } catch (e) {
      print('Error querying dealerships: $e');
      return MockDatabase.dealerships;
    }
  }

  Future<List<TrustedBusinessModel>> getTrustedBusinesses() async {
    if (!_isConnected || _pool == null) {
      return MockDatabase.trustedBusinesses;
    }

    try {
      final result = await _pool!.execute(
        'SELECT id, name, category, rating, verified_listings_count, image_path FROM trusted_businesses',
      );
      return result.rows.map((row) {
        final map = row.typedAssoc();
        return TrustedBusinessModel(
          id: map['id'].toString(),
          name: map['name'].toString(),
          category: map['category'].toString(),
          rating: map['rating'].toString(),
          verifiedListingsCount: (map['verified_listings_count'] as num?)?.toInt() ?? 0,
          imagePath: map['image_path'].toString(),
        );
      }).toList();
    } catch (e) {
      print('Error querying trusted businesses: $e');
      return MockDatabase.trustedBusinesses;
    }
  }

  static double _parsePrice(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) {
      final cleaned = val.replaceAll(',', '').replaceAll('₹', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }
}
