// Encryption layer was removed when the API switched to plain JSON over
// Bearer JWT. This file is intentionally empty — the Dio interceptor in
// `service_locator.dart` now reads the token from Hive and stamps the
// `Authorization: Bearer …` header on every outgoing request.
