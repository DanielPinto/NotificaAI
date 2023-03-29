class NotifyModel {
  String title;
  String body;
  List<dynamic> zones;

  NotifyModel(this.title, this.body, this.zones);

  Map<String, dynamic> toJson() => {'title': title, 'body': body};

  static NotifyModel fromJson(Map<String, dynamic> json) =>
      NotifyModel(json['title'], json['body'], json['zones']);

  setValues(NotifyModel notifyModel) {
    title = notifyModel.title;
    body = notifyModel.body;
    zones = notifyModel.zones;
  }
}
