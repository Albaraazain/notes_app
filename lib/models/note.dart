class Note {
  // the final keyword is used to make the variables immutable (i.e. they cannot be changed once they are initialized)
  final int id;
  final String title;
  final String content;

  // the required keyword is used to make the parameters required
  // the {} brackets are used to make the parameters optional
  // the @required annotation is used to make the parameters required
  // this is a constructor
  Note({
    required this.id,
    required this.title,
    required this.content,
  });
}
