class Quote {
  final int id;
  final String txt;
  final String author;
  final String category;

  Quote(
      {required this.id,
      required this.txt,
      required this.author,
      required this.category});

  Map<String, dynamic> toMap() {
    return {"id": id, "txt": txt, "author": author, "category": category};
  }

  @override
  String toString() {
    return 'id=$id, txt=$txt, author=$author, category=$category';
  }
}
