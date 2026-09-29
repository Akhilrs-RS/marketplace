class ConversationSummary {
  final String id;
  final String senderName;
  final String senderAvatar;
  final String itemTag;
  final String itemThumbnail;
  final String lastMessage;
  final String timestamp;
  final bool isBuying;
  final int unreadCount;

  const ConversationSummary({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.itemTag,
    required this.itemThumbnail,
    required this.lastMessage,
    required this.timestamp,
    required this.isBuying,
    this.unreadCount = 0,
  });

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      id: json['id'] as String? ?? '',
      senderName: json['sender_name'] as String? ?? '',
      senderAvatar: json['sender_avatar'] as String? ?? '',
      itemTag: json['item_tag'] as String? ?? '',
      itemThumbnail: json['item_thumbnail'] as String? ?? 'assets/images/h.png',
      lastMessage: json['last_message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      isBuying: json['is_buying'] as bool? ?? true,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'item_tag': itemTag,
      'item_thumbnail': itemThumbnail,
      'last_message': lastMessage,
      'timestamp': timestamp,
      'is_buying': isBuying,
      'unread_count': unreadCount,
    };
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isFromMe;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.isFromMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      conversationId: json['conversation_id'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      sentAt: json['sent_at'] != null
          ? DateTime.tryParse(json['sent_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      isFromMe: json['is_from_me'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'sent_at': sentAt.toIso8601String(),
      'is_from_me': isFromMe,
    };
  }
}
