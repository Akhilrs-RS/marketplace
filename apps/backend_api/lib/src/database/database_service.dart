import 'dart:convert';
import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:shared_models/shared_models.dart';
import '../data/mock_database.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Pool? _pool;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    final host = Platform.environment['DB_HOST'];
    if (host == null || host.isEmpty) {
      print('ℹ️ DB_HOST not set. Using in-memory MockDatabase storage.');
      return;
    }

    final portStr = Platform.environment['DB_PORT'] ?? '5432';
    final port = int.tryParse(portStr) ?? 5432;
    final database = Platform.environment['DB_NAME'] ?? 'marketplace_db';
    final username = Platform.environment['DB_USER'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? 'marketplace_secret_pw';

    try {
      final endpoint = Endpoint(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
      );

      _pool = Pool.withEndpoints(
        [endpoint],
        settings: const PoolSettings(
          sslMode: SslMode.disable,
          maxConnectionCount: 5,
        ),
      );

      // Verify connection
      final res = await _pool!.execute(Sql('SELECT 1'));
      if (res.isNotEmpty) {
        _isConnected = true;
        print('✅ Connected to PostgreSQL ($host:$port/$database)');
      }
    } catch (e) {
      print('⚠️ Failed to connect to PostgreSQL ($host:$port): $e');
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
        Sql('SELECT id, name, slug, icon_name, image_url FROM categories ORDER BY id ASC'),
      );
      return result.map((row) {
        final map = row.toColumnMap();
        return Category(
          id: map['id'] as String,
          name: map['name'] as String,
          slug: map['slug'] as String,
          iconName: map['icon_name'] as String,
          imageUrl: map['image_url'] as String,
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
        conditions.add('LOWER(category) = LOWER(@category)');
        parameters['category'] = category;
      }
      if (subcategory != null && subcategory.isNotEmpty) {
        conditions.add('LOWER(subcategory) = LOWER(@subcategory)');
        parameters['subcategory'] = subcategory;
      }
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
        conditions.add('LOWER(status) = LOWER(@status)');
        parameters['status'] = status;
      }
      if (q != null && q.isNotEmpty) {
        conditions.add('(LOWER(title) LIKE @q OR LOWER(location) LIKE @q OR LOWER(category) LIKE @q OR LOWER(formatted_price) LIKE @q)');
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

      final result = await _pool!.execute(
        Sql.named(sqlQuery),
        parameters: parameters,
      );

      return result.map((row) {
        final map = row.toColumnMap();
        Map<String, dynamic> specs = {};
        if (map['specifications'] != null) {
          if (map['specifications'] is Map) {
            specs = Map<String, dynamic>.from(map['specifications'] as Map);
          } else if (map['specifications'] is String) {
            specs = jsonDecode(map['specifications'] as String) as Map<String, dynamic>;
          }
        }

        return MarketListing(
          id: map['id'] as String,
          title: map['title'] as String,
          price: _parsePrice(map['price']),
          formattedPrice: map['formatted_price'] as String,
          location: map['location'] as String,
          category: map['category'] as String,
          subcategory: map['subcategory'] as String,
          imagePath: map['image_path'] as String,
          description: map['description'] as String,
          sellerId: map['seller_id'] as String,
          sellerName: map['seller_name'] as String,
          status: map['status'] as String,
          isFeatured: map['is_featured'] as bool? ?? false,
          specifications: specs,
          createdAt: map['created_at'] is DateTime ? map['created_at'] as DateTime : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error querying listings from Postgres: $e');
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
        Sql.named('SELECT id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at FROM listings WHERE id = @id LIMIT 1'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return null;
      final map = result.first.toColumnMap();
      Map<String, dynamic> specs = {};
      if (map['specifications'] != null) {
        if (map['specifications'] is Map) {
          specs = Map<String, dynamic>.from(map['specifications'] as Map);
        } else if (map['specifications'] is String) {
          specs = jsonDecode(map['specifications'] as String) as Map<String, dynamic>;
        }
      }

      return MarketListing(
        id: map['id'] as String,
        title: map['title'] as String,
        price: _parsePrice(map['price']),
        formattedPrice: map['formatted_price'] as String,
        location: map['location'] as String,
        category: map['category'] as String,
        subcategory: map['subcategory'] as String,
        imagePath: map['image_path'] as String,
        description: map['description'] as String,
        sellerId: map['seller_id'] as String,
        sellerName: map['seller_name'] as String,
        status: map['status'] as String,
        isFeatured: map['is_featured'] as bool? ?? false,
        specifications: specs,
        createdAt: map['created_at'] is DateTime ? map['created_at'] as DateTime : DateTime.now(),
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
        Sql.named('''
          INSERT INTO listings (id, title, price, formatted_price, location, category, subcategory, image_path, description, seller_id, seller_name, status, is_featured, specifications, created_at)
          VALUES (@id, @title, @price, @formatted_price, @location, @category, @subcategory, @image_path, @description, @seller_id, @seller_name, @status, @is_featured, @specifications::jsonb, @created_at)
          ON CONFLICT (id) DO UPDATE SET
            title = EXCLUDED.title,
            price = EXCLUDED.price,
            formatted_price = EXCLUDED.formatted_price,
            status = EXCLUDED.status
        '''),
        parameters: {
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
          'is_featured': listing.isFeatured,
          'specifications': jsonEncode(listing.specifications),
          'created_at': listing.createdAt,
        },
      );
    } catch (e) {
      print('Error inserting listing into Postgres: $e');
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
    );

    // Update in-memory
    final idx = MockDatabase.listings.indexWhere((e) => e.id == id);
    if (idx != -1) MockDatabase.listings[idx] = updated;

    if (_isConnected && _pool != null) {
      try {
        await _pool!.execute(
          Sql.named('''
            UPDATE listings
            SET title = @title, price = @price, formatted_price = @formatted_price, location = @location, status = @status, is_featured = @is_featured, description = @description, updated_at = NOW()
            WHERE id = @id
          '''),
          parameters: {
            'id': id,
            'title': updated.title,
            'price': updated.price,
            'formatted_price': updated.formattedPrice,
            'location': updated.location,
            'status': updated.status,
            'is_featured': updated.isFeatured,
            'description': updated.description,
          },
        );
      } catch (e) {
        print('Error updating listing in Postgres: $e');
      }
    }

    return updated;
  }

  Future<bool> deleteListing(String id) async {
    MockDatabase.listings.removeWhere((e) => e.id == id);

    if (!_isConnected || _pool == null) return true;

    try {
      final res = await _pool!.execute(
        Sql.named('DELETE FROM listings WHERE id = @id'),
        parameters: {'id': id},
      );
      return res.affectedRows > 0;
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
        Sql.named('SELECT listing_id, title, price, image_path, location, total_capacity, highest_speed, engine_output, fuel_type, transmission, owner, description, highlights FROM vehicle_details WHERE listing_id = @id LIMIT 1'),
        parameters: {'id': id},
      );

      if (result.isEmpty) return MockDatabase.vehicleDetails[id];
      final map = result.first.toColumnMap();

      List<String> hl = [];
      if (map['highlights'] != null) {
        if (map['highlights'] is List) {
          hl = (map['highlights'] as List).map((e) => e.toString()).toList();
        }
      }

      return VehicleDetail(
        listingId: map['listing_id'] as String,
        title: map['title'] as String,
        price: map['price'] as String,
        imagePath: map['image_path'] as String,
        location: map['location'] as String,
        totalCapacity: map['total_capacity'] as String,
        highestSpeed: map['highest_speed'] as String,
        engineOutput: map['engine_output'] as String,
        fuelType: map['fuel_type'] as String,
        transmission: map['transmission'] as String,
        owner: map['owner'] as String,
        description: map['description'] as String,
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
        Sql.named('SELECT active_listings, total_views, enquiries, messages, growth_percent, period FROM seller_metrics WHERE seller_id = @seller_id LIMIT 1'),
        parameters: {'seller_id': sellerId},
      );

      if (result.isEmpty) {
        return MockDatabase.sellerMetrics;
      }

      final map = result.first.toColumnMap();
      return SellerMetrics(
        activeListings: map['active_listings'] as int? ?? 12,
        totalViews: map['total_views'] as int? ?? 2400,
        enquiries: map['enquiries'] as int? ?? 38,
        messages: map['messages'] as int? ?? 7,
        growthPercent: map['growth_percent'] as int? ?? 16,
        period: map['period'] as String? ?? 'This Month',
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
        Sql.named('SELECT id, sender_name, sender_avatar, item_tag, item_thumbnail, last_message, timestamp, is_buying, unread_count FROM conversations WHERE is_buying = @is_buying ORDER BY updated_at DESC'),
        parameters: {'is_buying': isBuying},
      );

      return result.map((row) {
        final map = row.toColumnMap();
        return ConversationSummary(
          id: map['id'] as String,
          senderName: map['sender_name'] as String,
          senderAvatar: map['sender_avatar'] as String,
          itemTag: map['item_tag'] as String,
          itemThumbnail: map['item_thumbnail'] as String,
          lastMessage: map['last_message'] as String,
          timestamp: map['timestamp'] as String,
          isBuying: map['is_buying'] as bool? ?? true,
          unreadCount: map['unread_count'] as int? ?? 0,
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
        Sql.named('SELECT id, conversation_id, sender_id, content, sent_at, is_from_me FROM chat_messages WHERE conversation_id = @conv_id ORDER BY sent_at ASC'),
        parameters: {'conv_id': conversationId},
      );

      return result.map((row) {
        final map = row.toColumnMap();
        return ChatMessage(
          id: map['id'] as String,
          conversationId: map['conversation_id'] as String,
          senderId: map['sender_id'] as String,
          content: map['content'] as String,
          sentAt: map['sent_at'] is DateTime ? map['sent_at'] as DateTime : DateTime.now(),
          isFromMe: map['is_from_me'] as bool? ?? false,
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
    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      sentAt: DateTime.now(),
      isFromMe: isFromMe,
    );

    MockDatabase.messages.putIfAbsent(conversationId, () => []).add(msg);

    if (_isConnected && _pool != null) {
      try {
        await _pool!.execute(
          Sql.named('''
            INSERT INTO chat_messages (id, conversation_id, sender_id, content, sent_at, is_from_me)
            VALUES (@id, @conversation_id, @sender_id, @content, @sent_at, @is_from_me)
          '''),
          parameters: {
            'id': msg.id,
            'conversation_id': msg.conversationId,
            'sender_id': msg.senderId,
            'content': msg.content,
            'sent_at': msg.sentAt,
            'is_from_me': msg.isFromMe,
          },
        );

        // Update last message in conversation
        await _pool!.execute(
          Sql.named('''
            UPDATE conversations
            SET last_message = @content, timestamp = 'Just now', updated_at = NOW()
            WHERE id = @conv_id
          '''),
          parameters: {
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
        Sql.named('SELECT id, name, phone, email, address, avatar_url, favorites_count, saved_searches_count, recently_viewed_count, active_enquiries_count FROM user_profiles WHERE id = @id LIMIT 1'),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        return MockDatabase.userProfile;
      }

      final map = result.first.toColumnMap();
      return UserProfile(
        id: map['id'] as String,
        name: map['name'] as String,
        phone: map['phone'] as String,
        email: map['email'] as String,
        address: map['address'] as String,
        avatarUrl: map['avatar_url'] as String,
        favoritesCount: map['favorites_count'] as int? ?? 1,
        savedSearchesCount: map['saved_searches_count'] as int? ?? 1,
        recentlyViewedCount: map['recently_viewed_count'] as int? ?? 1,
        activeEnquiriesCount: map['active_enquiries_count'] as int? ?? 4,
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
            Sql.named('INSERT INTO user_favorites (user_id, listing_id) VALUES (@user_id, @listing_id) ON CONFLICT DO NOTHING'),
            parameters: {'user_id': userId, 'listing_id': listingId},
          );
        } else {
          await _pool!.execute(
            Sql.named('DELETE FROM user_favorites WHERE user_id = @user_id AND listing_id = @listing_id'),
            parameters: {'user_id': userId, 'listing_id': listingId},
          );
        }
      } catch (e) {
        print('Error toggling favorite in Postgres: $e');
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
        Sql('SELECT id, name, location, category, rating, badge, image_path FROM dealerships'),
      );
      return result.map((row) {
        final map = row.toColumnMap();
        return VehicleDealershipModel(
          id: map['id'] as String,
          name: map['name'] as String,
          location: map['location'] as String,
          category: map['category'] as String,
          rating: map['rating'] as String,
          badge: map['badge'] as String? ?? 'Trusted Dealer',
          imagePath: map['image_path'] as String,
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
        Sql('SELECT id, name, category, rating, verified_listings_count, image_path FROM trusted_businesses'),
      );
      return result.map((row) {
        final map = row.toColumnMap();
        return TrustedBusinessModel(
          id: map['id'] as String,
          name: map['name'] as String,
          category: map['category'] as String,
          rating: map['rating'] as String,
          verifiedListingsCount: map['verified_listings_count'] as int? ?? 0,
          imagePath: map['image_path'] as String,
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
