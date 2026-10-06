import 'enums.dart';

class Investor {
  const Investor({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.kycStatus,
  });

  final String id;
  final String name;
  final String phone;
  final UserRole role;
  final KycStatus kycStatus;

  String get firstName => name.split(' ').first;

  Investor copyWith({
    String? id,
    String? name,
    String? phone,
    UserRole? role,
    KycStatus? kycStatus,
  }) {
    return Investor(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }
}
