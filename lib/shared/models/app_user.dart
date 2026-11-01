enum UserRole { investor, businessOwner }

class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    this.email,
    this.businessName,
  });

  final String id;
  final String fullName;
  final String phone;
  final UserRole role;
  final String? email;
  final String? businessName;

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'B';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'fullName': fullName,
    'phone': phone,
    'email': email,
    'role': role.name,
    'businessName': businessName,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? 'user',
      fullName: json['fullName'] as String? ?? 'Investor',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] == 'businessOwner'
          ? UserRole.businessOwner
          : UserRole.investor,
      businessName: json['businessName'] as String?,
    );
  }
}

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.busy = false,
    this.error,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  const AuthState.unauthenticated({String? error})
    : this(status: AuthStatus.unauthenticated, error: error);

  const AuthState.authenticated(AppUser user)
    : this(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final AppUser? user;
  final bool busy;
  final String? error;

  bool get isAuthenticated => status == AuthStatus.authenticated;
}
