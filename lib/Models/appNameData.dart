// To parse this JSON data, do
//
//     final appNameData = appNameDataFromJson(jsonString);

import 'dart:convert';

AppNameData appNameDataFromJson(String str) => AppNameData.fromJson(json.decode(str));

String appNameDataToJson(AppNameData data) => json.encode(data.toJson());

class AppNameData {
    Response response;
    Body body;

    AppNameData({
        required this.response,
        required this.body,
    });

    factory AppNameData.fromJson(Map<String, dynamic> json) => AppNameData(
        response: Response.fromJson(json["response"]),
        body: Body.fromJson(json["body"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "body": body.toJson(),
    };
}

class Body {
    List<App> app;

    Body({
        required this.app,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        app: List<App>.from(json["app"].map((x) => App.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "app": List<dynamic>.from(app.map((x) => x.toJson())),
    };
}

class App {
    String name;

    App({
        required this.name,
    });

    factory App.fromJson(Map<String, dynamic> json) => App(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}

class Response {
    String status;
    String message;

    Response({
        required this.status,
        required this.message,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
