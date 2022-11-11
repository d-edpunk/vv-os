import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getProportionalyFactor(BuildContext context) {
  var width = getWidth(context), height = getHeight(context);
  return width < height ? width : height;
}
