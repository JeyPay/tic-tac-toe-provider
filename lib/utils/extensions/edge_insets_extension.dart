part of 'extensions.dart';

extension DoubleEdgeInsetsExtension on double {
  EdgeInsets allInsets() => EdgeInsets.all(this);

  EdgeInsets horizontalInsets() => EdgeInsets.symmetric(horizontal: this);

  EdgeInsets verticalInsets() => EdgeInsets.symmetric(vertical: this);
}
