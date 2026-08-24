// Lokasi: lib/features/mushaf/widgets/mushaf_page_view.dart

import 'package:flutter/material.dart';
import '../models/mushaf_model.dart';

class MushafPageView extends StatelessWidget {
  final List<MushafLine> lines;

  const MushafPageView({
    super.key,
    required this.lines,
  });

  // ============================================================
  // PALETTE
  // ============================================================

  static const Color pageColor = Color(0xFFFFF8E7);
  static const Color goldColor = Color(0xFFB8963E);
  static const Color darkGoldColor = Color(0xFF8B4513);
  static const Color surahColor = Color(0xFF6B3A1F);
  static const Color quranTextColor = Color(0xFF1A1A1A);

  // ============================================================
  // CONSTANTS
  // ============================================================

  static const int normalLineCount = 15;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const Center(
        child: Text(
          'Data halaman tidak ditemukan di database.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageNum = lines.first.pageNumber;
        final bool isSpecialPage = pageNum <= 2;

        final bool hasSurahStart = lines.any(
              (line) => line.ayahStart == 1,
        );

        final int firstAyah1LineIdx = lines.indexWhere(
              (line) => line.ayahStart == 1,
        );

        // --------------------------------------------------------
        // RESPONSIVE DIMENSIONS
        // --------------------------------------------------------

        final double horizontalPadding = _clamp(
          constraints.maxWidth * 0.018,
          10.0,
          28.0,
        );

        final double verticalPadding = _clamp(
          constraints.maxHeight * 0.012,
          8.0,
          20.0,
        );

        final double headerFontSize = _clamp(
          constraints.maxWidth * 0.028,
          18.0,
          32.0,
        );

        final double quranFontSize = _calculateQuranFontSize(
          constraints,
          isSpecialPage,
        );

        final double footerSize = _clamp(
          constraints.maxWidth * 0.045,
          34.0,
          58.0,
        );

        // --------------------------------------------------------
        // PAGE FRAME
        // --------------------------------------------------------

        return Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: pageColor,
            border: Border.all(
              color: goldColor,
              width: 2,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: goldColor,
                width: isSpecialPage ? 4 : 2,
              ),
            ),
            child: Stack(
              children: [
                // ------------------------------------------------
                // CORNER ORNAMENT
                // ------------------------------------------------

                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: MushafCornerPainter(
                        color: goldColor,
                      ),
                    ),
                  ),
                ),

                // ------------------------------------------------
                // MAIN PAGE
                // ------------------------------------------------

                Column(
                  children: [
                    // Jarak kecil dari navigation/top bar.
                    const SizedBox(height: 4),

                    // ------------------------------------------------
                    // MUSHAF HEADER
                    // ------------------------------------------------

                    _buildTopHeader(
                      constraints,
                      headerFontSize,
                    ),

                    // ------------------------------------------------
                    // SURAH HEADER
                    // ------------------------------------------------

                    if (hasSurahStart && !isSpecialPage)
                      _buildSurahBanner(
                        lines[firstAyah1LineIdx].surahName,
                        lines[firstAyah1LineIdx].surahNumber,
                        constraints,
                      ),

                    // ------------------------------------------------
                    // QURAN TEXT AREA
                    // ------------------------------------------------

                    Expanded(
                      child: _buildQuranTextArea(
                        constraints: constraints,
                        fontSize: quranFontSize,
                        isSpecialPage: isSpecialPage,
                      ),
                    ),

                    // ------------------------------------------------
                    // FOOTER
                    // ------------------------------------------------

                    const SizedBox(height: 4),

                    _buildFooter(
                      pageNum,
                      constraints,
                      footerSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // QURAN TEXT AREA
  // ============================================================

  Widget _buildQuranTextArea({
    required BoxConstraints constraints,
    required double fontSize,
    required bool isSpecialPage,
  }) {
    final int lineCount = lines.length;

    // Untuk halaman normal, target physical line adalah 15.
    //
    // Kalau database mengirim kurang dari 15 line, kita tidak
    // memalsukan line kosong. Kita tetap render data yang tersedia.
    final double availableHeight = constraints.maxHeight;

    final double estimatedLineHeight = isSpecialPage
        ? _clamp(
      availableHeight / (lineCount.clamp(1, 10) + 1.5),
      42.0,
      92.0,
    )
        : _clamp(
      availableHeight / normalLineCount,
      28.0,
      62.0,
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: isSpecialPage
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: lines.asMap().entries.map((entry) {
          final int idx = entry.key;
          final MushafLine line = entry.value;

          // Nomor ayat hanya muncul pada physical line terakhir
          // dari ayat tersebut.
          final bool isLastLineOfAyah =
              (idx == lines.length - 1) ||
                  (lines[idx + 1].ayahStart != line.ayahStart) ||
                  (lines[idx + 1].surahNumber != line.surahNumber);

          return SizedBox(
            width: double.infinity,
            height: estimatedLineHeight,
            child: Center(
              child: _buildQuranLine(
                line: line,
                fontSize: fontSize,
                showAyahNumber: isLastLineOfAyah,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // SINGLE QURAN LINE
  // ============================================================

  Widget _buildQuranLine({
    required MushafLine line,
    required double fontSize,
    required bool showAyahNumber,
  }) {
    final richText = RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      maxLines: 1,
      overflow: TextOverflow.visible,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'UthmanicFont',
          height: 1.0,
          color: quranTextColor,
          fontWeight: FontWeight.normal,
        ),
        children: _buildTajwidText(
          line,
          fontSize,
          showAyahNumber,
        ),
      ),
    );

    // FittedBox membuat satu physical line tetap berada
    // dalam satu baris. Jika terlalu panjang, font akan
    // mengecil sedikit daripada melakukan wrapping.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: richText,
    );
  }

  // ============================================================
  // QURAN TEXT + AYAH NUMBER
  // ============================================================

  List<InlineSpan> _buildTajwidText(
      MushafLine line,
      double fontSize,
      bool showAyahNumber,
      ) {
    final double ayahNumSize = _clamp(
      fontSize * 0.68,
      10.0,
      22.0,
    );

    final double badgeSize = _clamp(
      fontSize * 1.12,
      18.0,
      32.0,
    );

    return [
      TextSpan(
        text: line.quranText,
      ),

      if (showAyahNumber)
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            margin: EdgeInsets.symmetric(
              horizontal: fontSize * 0.16,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: goldColor,
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              line.arabicAyahNumber,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ayahNumSize,
                fontFamily: 'UthmanicFont',
                fontWeight: FontWeight.normal,
                color: darkGoldColor,
                height: 1.0,
              ),
            ),
          ),
        ),
    ];
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildTopHeader(
      BoxConstraints constraints,
      double headerFontSize,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _clamp(
          constraints.maxWidth * 0.018,
          8.0,
          24.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // JUZ
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'الجزء ${lines.first.juzNumber}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'UthmanicFont',
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.normal,
                  color: darkGoldColor,
                ),
              ),
            ),
          ),

          // SURAH
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _cleanSurahName(lines.first.surahName),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'UthmanicFont',
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.normal,
                  color: darkGoldColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SURAH BANNER
  // ============================================================

  Widget _buildSurahBanner(
      String name,
      int surahNumber,
      BoxConstraints constraints,
      ) {
    final double bannerFontSize = _clamp(
      constraints.maxWidth * 0.030,
      18.0,
      30.0,
    );

    final double basmalaFontSize = _clamp(
      constraints.maxWidth * 0.027,
      17.0,
      28.0,
    );

    final double iconSize = _clamp(
      constraints.maxWidth * 0.024,
      18.0,
      30.0,
    );

    final String cleanName = _cleanSurahName(name);

    return Padding(
      padding: EdgeInsets.only(
        top: _clamp(
          constraints.maxHeight * 0.008,
          4.0,
          10.0,
        ),
        bottom: _clamp(
          constraints.maxHeight * 0.004,
          2.0,
          6.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------------------------------------------
          // SURAH NAME
          // ------------------------------------------------------

          Container(
            width: constraints.maxWidth * 0.72,
            padding: EdgeInsets.symmetric(
              horizontal: _clamp(
                constraints.maxWidth * 0.025,
                14.0,
                28.0,
              ),
              vertical: _clamp(
                constraints.maxHeight * 0.006,
                5.0,
                10.0,
              ),
            ),
            decoration: BoxDecoration(
              color: pageColor,
              border: Border.all(
                color: goldColor,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_vintage_outlined,
                  color: goldColor,
                  size: iconSize,
                ),

                const SizedBox(width: 10),

                Flexible(
                  child: Text(
                    'سُورَةُ $cleanName',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'UthmanicFont',
                      fontSize: bannerFontSize,
                      fontWeight: FontWeight.normal,
                      color: surahColor,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Icon(
                  Icons.filter_vintage_outlined,
                  color: goldColor,
                  size: iconSize,
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // BASMALA
          // ------------------------------------------------------

          if (surahNumber != 1 && surahNumber != 9)
            Padding(
              padding: EdgeInsets.only(
                top: _clamp(
                  constraints.maxHeight * 0.004,
                  3.0,
                  6.0,
                ),
                bottom: _clamp(
                  constraints.maxHeight * 0.006,
                  4.0,
                  8.0,
                ),
              ),
              child: Text(
                'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'UthmanicFont',
                  fontSize: basmalaFontSize,
                  fontWeight: FontWeight.normal,
                  color: quranTextColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter(
      int pageNum,
      BoxConstraints constraints,
      double footerSize,
      ) {
    final double numberFontSize = _clamp(
      footerSize * 0.38,
      13.0,
      22.0,
    );

    return SizedBox(
      height: footerSize,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              color: goldColor,
              size: footerSize * 0.28,
            ),

            const SizedBox(width: 7),

            Container(
              width: footerSize * 0.78,
              height: footerSize * 0.78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: goldColor,
                  width: 1.4,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                pageNum.toString(),
                style: TextStyle(
                  fontSize: numberFontSize,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(width: 7),

            Icon(
              Icons.auto_awesome,
              color: goldColor,
              size: footerSize * 0.28,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _cleanSurahName(String name) {
    return name
        .replaceAll(
      RegExp(r'^سُورَةُ\s*'),
      '',
    )
        .replaceAll(
      RegExp(
        r'^[Ss]urah\s*',
        caseSensitive: false,
      ),
      '',
    )
        .trim();
  }

  double _calculateQuranFontSize(
      BoxConstraints constraints,
      bool isSpecialPage,
      ) {
    final double widthBasedSize =
        constraints.maxWidth * (isSpecialPage ? 0.030 : 0.025);

    final double heightBasedSize =
        constraints.maxHeight * (isSpecialPage ? 0.030 : 0.026);

    final double result =
        (widthBasedSize + heightBasedSize) / 2;

    return _clamp(
      result,
      isSpecialPage ? 20.0 : 18.0,
      isSpecialPage ? 34.0 : 31.0,
    );
  }

  double _clamp(
      double value,
      double min,
      double max,
      ) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

// ================================================================
// MUSHAF CORNER PAINTER
// ================================================================

class MushafCornerPainter extends CustomPainter {
  final Color color;

  MushafCornerPainter({
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double len = 20.0;

    // ------------------------------------------------------------
    // TOP LEFT
    // ------------------------------------------------------------

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(len, 0),
      paint,
    );

    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, len),
      paint,
    );

    canvas.drawCircle(
      const Offset(0, 0),
      3,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // ------------------------------------------------------------
    // TOP RIGHT
    // ------------------------------------------------------------

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - len, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, len),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width, 0),
      3,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // ------------------------------------------------------------
    // BOTTOM LEFT
    // ------------------------------------------------------------

    canvas.drawLine(
      Offset(0, size.height),
      Offset(len, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - len),
      paint,
    );

    canvas.drawCircle(
      Offset(0, size.height),
      3,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // ------------------------------------------------------------
    // BOTTOM RIGHT
    // ------------------------------------------------------------

    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - len, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - len),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width, size.height),
      3,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}