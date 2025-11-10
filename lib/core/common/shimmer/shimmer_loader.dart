import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final bool animate;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.animate = true,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  ShimmerLoaderState createState() => ShimmerLoaderState();
}

class ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(vsync: this, duration: widget.duration)
        ..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShimmerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.animate && _controller == null) {
      _controller = AnimationController(vsync: this, duration: widget.duration)
        ..repeat();
    } else if (widget.animate && oldWidget.animate != widget.animate) {
      if (!_controller!.isAnimating) {
        _controller!.repeat();
      }
    } else if (!widget.animate && oldWidget.animate && _controller != null) {
      _controller!.stop();
      _controller!.value = 0;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }
    
    if (!widget.animate) {
      return ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback:  (bounds) {
          return LinearGradient(
            colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
            stops: const [0.0, 0.5, 1.0],
            begin: const Alignment(-1.0, 0.0),
            end: const Alignment(1.0, 0.0),
          ).createShader(bounds);
        },
        child: widget.child,
      );
    }

    final controller = _controller;
    if (controller == null) {
      // Fallback: render static if controller missing (shouldn't happen)
      return ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
            stops: const [0.0, 0.5, 1.0],
            begin: const Alignment(-1.0, 0.0),
            end: const Alignment( 1.0, 0.0),
          ).createShader(bounds);
        },
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (controller.value * 2), 0.0),
              end: Alignment(1.0 + (controller.value * 2), 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}