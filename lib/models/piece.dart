class Piece{
  int id;
  String piece;
  Piece.fromJson(Map<String,dynamic> json):id=json['id'],piece=json['piece'];
}