class UserInfo {
  UserInfo._init();
  static UserInfo? instance;
  static UserInfo createInstance() {
    instance ??= UserInfo._init();
    return instance!;
  }

  void setData([String? id, String? phone, String? name, String? type]) {
    instance?.phone = phone;
    instance?.name = name;
    instance?.type = type;
  }

  String? id, phone, name, type;
}