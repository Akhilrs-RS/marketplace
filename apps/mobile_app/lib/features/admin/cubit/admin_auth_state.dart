enum UserRole { customer, admin }

class AdminAuthState {
  final UserRole role;
  final String userName;
  final String userEmail;
  final String shopName;
  final String avatarUrl;

  const AdminAuthState({
    required this.role,
    required this.userName,
    required this.userEmail,
    required this.shopName,
    required this.avatarUrl,
  });

  bool get isAdmin => role == UserRole.admin;

  factory AdminAuthState.customer() {
    return const AdminAuthState(
      role: UserRole.customer,
      userName: 'Alex Morgan',
      userEmail: 'alex.morgan@galletrix.com',
      shopName: 'Alex Auto Hub',
      avatarUrl: 'assets/images/user_avatar.jpg',
    );
  }

  factory AdminAuthState.admin() {
    return const AdminAuthState(
      role: UserRole.admin,
      userName: 'Zara Philip',
      userEmail: 'zara.philip@marketplace.com',
      shopName: 'Zara Official Motors',
      avatarUrl: 'assets/images/user_avatar.jpg',
    );
  }

  AdminAuthState copyWith({
    UserRole? role,
    String? userName,
    String? userEmail,
    String? shopName,
    String? avatarUrl,
  }) {
    return AdminAuthState(
      role: role ?? this.role,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      shopName: shopName ?? this.shopName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
