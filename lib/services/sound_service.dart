import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sound_item.dart';

class SoundService {
  final String _token = 'FDnuIMS9CsxJkDaUVLlW0yMf5TFpClD2VJMmQuYL';

  Future<List<SoundItem>> fetchSounds(String query) async {
    final res = await http.get(
      Uri.parse(
        'https://freesound.org/apiv2/search/text/?query=$query&fields=id,name,previews&token=$_token',
      ),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['results'] as List)
          .map((e) => SoundItem.fromJson(e))
          .toList();
    } else {
      throw Exception('Error al obtener sonidos');
    }
  }
}
