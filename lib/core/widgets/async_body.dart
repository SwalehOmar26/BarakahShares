import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'states.dart';

class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const LoadingState(),
      error: (error, _) =>
          ErrorState(message: error.toString(), onRetry: onRetry),
      data: data,
    );
  }
}
