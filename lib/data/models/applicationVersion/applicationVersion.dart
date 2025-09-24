class ApplicationVersion {
  String? version;
  bool? isForceUpdate;

  ApplicationVersion({this.version, this.isForceUpdate});

  ApplicationVersion.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    isForceUpdate = json['isForceUpdate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (version != null) {
      data['version'] = version;
    }
    if (isForceUpdate != null) {
      data['isForceUpdate'] = isForceUpdate;
    }
    return data;
  }
}
