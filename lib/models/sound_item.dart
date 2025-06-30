class SoundItem {
  final int id;
  final String name;
  final String previewUrl;

  SoundItem({required this.id, required this.name, required this.previewUrl});

  factory SoundItem.fromJson(Map<String, dynamic> json) {
    final originalName = json['name'] as String;
    final cleanedName = originalName.replaceAll(
      RegExp(r'\.(mp3|wav|ogg)$'),
      '',
    );
    return SoundItem(
      id: json['id'],
      name: cleanedName,
      previewUrl: json['previews']['preview-hq-mp3'],
    );
  }
}
