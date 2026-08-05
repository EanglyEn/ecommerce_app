import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class AppShare {
  const AppShare._();
  static Future<void> text({
    required String text,
    String? subject,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('SHARE ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  static Future<void> image({
    required String imageUrl,
    required String text,
    String? subject,
    String? fileName,
  }) async {
    try {
      final response = await NetworkAssetBundle(
        Uri.parse(imageUrl),
      ).load(imageUrl);

      final imageBytes = response.buffer.asUint8List();

      final file = XFile.fromData(
        imageBytes,
        name: fileName ?? 'shared_image.jpg',
        mimeType: 'image/jpeg',
      );

      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
          files: [file],
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('SHARE IMAGE ERROR: $e');
      debugPrint('$stackTrace');
    }
  }

  static Future<void> imageWithDetails({
    required String imageUrl,
    required String title,
    String? description,
    String? subject,
    String? fileName,
  }) async {
    final message = [
      title,
      if (description != null && description.trim().isNotEmpty)
        description,
    ].join('\n\n');

    await image(
      imageUrl: imageUrl,
      text: message,
      subject: subject ?? title,
      fileName: fileName,
    );
  }
}