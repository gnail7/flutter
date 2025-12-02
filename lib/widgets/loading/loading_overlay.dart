import 'package:flutter/material.dart';
import 'package:op_flutter/widgets/loading/spin_loader.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loader;
  final double opacity;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loader,
    this.opacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(opacity),
              child: Center(
                child: loader ?? const SpinningDotsLoader(),
              ),
            ),
          ),
      ],
    );
  }
}
