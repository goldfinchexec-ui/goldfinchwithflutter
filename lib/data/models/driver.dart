
class Driver {
  final String id;
  final String name;
  final String code;
  final String email;
  final String vehicleReg;

  Driver({
    required this.id,
    required this.name,
    required this.code,
    required this.email,
    required this.vehicleReg,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      email: json['email'],
      vehicleReg: json['vehicle_reg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'email': email,
      'vehicle_reg': vehicleReg,
    };
  }
}
