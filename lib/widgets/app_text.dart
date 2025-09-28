import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final bool softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final double textScaleFactor;
  final Color? selectionColor;
  final Color? color;
  final GestureTapCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AppText(
      {super.key,
      required this.text,
      this.style,
      this.textAlign = TextAlign.start,
      this.overflow = TextOverflow.clip,
      this.maxLines,
      this.softWrap = true,
      this.textDirection,
      this.locale,
      this.strutStyle,
      this.textScaleFactor = 1.0,
      this.selectionColor,
      this.onTap,
      this.fontSize,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style ??
            style ??
            GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight),
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        softWrap: softWrap,
        textDirection: textDirection,
        locale: locale,
        strutStyle: strutStyle,
        selectionColor: selectionColor,
      ),
    );
  }
}
