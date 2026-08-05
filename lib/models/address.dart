class Address {
  final String id;
  final String label;
  final String fullAddress;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.isDefault = false,
  });
}