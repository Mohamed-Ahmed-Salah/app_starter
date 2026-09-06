import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../flavors.dart';

/// Pretty-printed request and response logging, for the `dev` flavor only.
///
/// Returns an empty list on `prod`, so that build never formats a
/// payload, never holds one in memory, and never writes a bearer token or a
/// customer's address into the device log. The gate is the **flavor**, not
/// [kDebugMode] — a debug or profile build of a live flavor still talks to the
/// live API, and that is exactly the case worth protecting.
///
/// Add these *after* `AuthInterceptor`. Dio runs request interceptors in the
/// order they were registered, so logging last means the headers printed are
/// the ones actually sent rather than the ones set before auth ran.
///
/// To silence a noisy endpoint, give [PrettyDioLogger] a `filter`:
/// `filter: (options, _) => !options.path.contains('/settings')`.
List<Interceptor> networkLogInterceptors() {
  if (F.appFlavor != Flavor.dev) return const [];

  return [
    PrettyDioLogger(
      // `request` (on by default) prints the method + URL banner.
      requestHeader: true, // query parameters and the outgoing headers
      requestBody: true,
      responseBody: true,
      responseHeader: false, // rarely useful, and it doubles the noise
      error: true,
      compact: false, // indent the JSON instead of one very long line
      maxWidth: 120,
      // debugPrint chunks its output. A bare print() gets clipped at Android's
      // ~1 KB logcat line limit, which silently truncates large responses —
      // the exact thing you opened the logs to read.
      logPrint: (Object line) => debugPrint(line.toString()),
    ),
  ];
}
