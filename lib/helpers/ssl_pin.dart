// import 'package:flutter/material.dart';
// import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

// class PinSSL {
//   String serverUrl = "";
//   HttpMethod httpMethod = HttpMethod.Get;
//   Map<String, String> headerHttp = new Map();
//   String allowedSHAFingerprint = "";
//   int timeout = 0;
//   late SHA sha;
// }

// checkSSL(String requestURL) {
//   bool checked = false;
//   String _fingerprint =
//       "B2:32:5C:15:2A:AD:7C:86:31:7C:8D:02:21:AA:CD:2D:A8:9C:92:22";
//   List<String> allowedSha1FingerprintList = [];
//   allowedSha1FingerprintList.add(_fingerprint);

//   try {
//     SslPinningPlugin.check(
//             serverURL: requestURL,
//             sha: SHA.SHA1,
//             allowedSHAFingerprints: allowedSha1FingerprintList,
//             timeout: 60)
//         .then((value) => {
//               if (value == "CONNECTION_SECURE")
//                 {checked = true}
//               else if (value == "CONNECTION_NOT_SECURE")
//                 {checked = false}
//             });
//   } catch (e) {}
// }
