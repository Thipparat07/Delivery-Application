// To parse this JSON data, do
//
//     final searchphoneDataGetResponse = searchphoneDataGetResponseFromJson(jsonString);

import 'dart:convert';

List<SearchphoneDataGetResponse> searchphoneDataGetResponseFromJson(String str) => List<SearchphoneDataGetResponse>.from(json.decode(str).map((x) => SearchphoneDataGetResponse.fromJson(x)));

String searchphoneDataGetResponseToJson(List<SearchphoneDataGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchphoneDataGetResponse {
    int userId;
    String phoneNumber;
    String email;
    String password;
    String name;
    String profilePicture;
    String address;
    String gpsLocation;
    dynamic vehicleRegistration;
    String userType;
    String createdAt;

    SearchphoneDataGetResponse({
        required this.userId,
        required this.phoneNumber,
        required this.email,
        required this.password,
        required this.name,
        required this.profilePicture,
        required this.address,
        required this.gpsLocation,
        required this.vehicleRegistration,
        required this.userType,
        required this.createdAt,
    });

    factory SearchphoneDataGetResponse.fromJson(Map<String, dynamic> json) => SearchphoneDataGetResponse(
        userId: json["UserID"],
        phoneNumber: json["PhoneNumber"],
        email: json["Email"],
        password: json["Password"],
        name: json["Name"],
        profilePicture: json["ProfilePicture"],
        address: json["Address"],
        gpsLocation: json["GPSLocation"],
        vehicleRegistration: json["VehicleRegistration"],
        userType: json["UserType"],
        createdAt: json["CreatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "PhoneNumber": phoneNumber,
        "Email": email,
        "Password": password,
        "Name": name,
        "ProfilePicture": profilePicture,
        "Address": address,
        "GPSLocation": gpsLocation,
        "VehicleRegistration": vehicleRegistration,
        "UserType": userType,
        "CreatedAt": createdAt,
    };
}
