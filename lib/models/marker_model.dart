
class MarkerModel {
  final int? id;
  final String title;
  final double lat;
  final double lng;
  final String? imagePath;

  //Creación del objeto MarkerModel
  MarkerModel({
    this.id,
    required this.title,
    required this.lat,
    required this.lng,
    this.imagePath,
  });

  //Convertimos el objeto en un mapa par guardarlo en la BD 
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'lat': lat,
        'lng': lng,
        'imagePath': imagePath,
      };

  //Creamos el objeto que permita dibujar el mapa con los marcadores almacenado en la BD
  factory MarkerModel.fromMap(Map<String, dynamic> map) => MarkerModel(
        id: map['id'] as int?,
        title: map['title'] as String,
        lat: (map['lat'] as num).toDouble(),
        lng: (map['lng'] as num).toDouble(),
        imagePath: map['imagePath'] as String?,
      );
}
