
class Client {
  final String id;
  final String name;
  final String email;
  final String address;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }
}
