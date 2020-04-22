import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final int id;
  String name;
  String telephone;
  int gender;
  String description;
  DateTime birthday;
  String avatar;

  Contact({this.name, this.telephone, this.gender , this.description , this.birthday , this.avatar , this.id});
  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
