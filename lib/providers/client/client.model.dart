class Client {
    int id;
    User user;
    String image;

    Client({
        required this.id,
        required this.user,
        required this.image,
    });

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        user: User.fromJson(json["user"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "image": image,
    };
}

class User {
    String username;
    String firstName;
    String lastName;
    String password;

    User({
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.password,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
    };
}
