/**
 * @see https://github.com/thibauts/node-castv2-client/wiki/How-to-use-subtitles-with-the-DefaultMediaReceiver-app
 */
class CastMediaTextTrackStyle {
  /**
   * See http://dev.w3.org/csswg/css-color/#hex-notation
   */
  String backgroundColor;

  /**
   * See http://dev.w3.org/csswg/css-color/#hex-notation
   */
  String foregroundColor;

  /**
   * Can be: "NONE", "OUTLINE", "DROP_SHADOW", "RAISED", "DEPRESSED"
   */
  String edgeType;

  /**
   * See http://dev.w3.org/csswg/css-color/#hex-notation
   */
  String edgeColor;

  /**
   *  Transforms into "font-size: " + (fontScale*100) +"%"
   */
  int fontScale;

  /**
   * Can be: "NORMAL", "BOLD", "BOLD_ITALIC", "ITALIC",
   */
  String fontStyle;

  /**
   * Specific font family
   */
  String fontFamily;

  /**
   * Can be: "SANS_SERIF", "MONOSPACED_SANS_SERIF", "SERIF", "MONOSPACED_SERIF", "CASUAL", "CURSIVE", "SMALL_CAPITALS"
   */
  String fontGenericFamily;

  /**
   * See http://dev.w3.org/csswg/css-color/#hex-notation
   */
  String windowColor;

  /**
   * Radius in px
   */
  int windowRoundedCornerRadius;

  /**
   * Can be: "NONE", "NORMAL", "ROUNDED_CORNERS"
   */
  String windowType;

  CastMediaTextTrackStyle({
    this.backgroundColor = '#0',
    this.foregroundColor = '#0',
    this.edgeType = 'NONE',
    this.edgeColor = '#0',
    this.fontScale = 1,
    this.fontStyle = 'NORMAL',
    this.fontFamily = 'Droid Sans',
    this.fontGenericFamily = 'SERIF',
    this.windowColor = '#0',
    this.windowRoundedCornerRadius = 0,
    this.windowType = 'NONE',
  }) {}

  Map toChromeCastMap() {
    return {
      'backgroundColor': backgroundColor,
      'foregroundColor': foregroundColor,
      'edgeType': edgeType,
      'edgeColor': edgeColor,
      'fontScale': fontScale,
      'fontStyle': fontStyle,
      'fontFamily': fontFamily,
      'fontGenericFamily': fontGenericFamily,
      'windowColor': windowColor,
      'windowRoundedCornerRadius': windowRoundedCornerRadius,
      'windowType': windowType
    };
  }
}
