class Group {
  String id;
  List<Member> members;

  Group({required this.id, required this.members});
}

class Member {
  String id;
  String name;

  Member({required this.id, required this.name});
}
