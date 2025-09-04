library infra_telemetry;

abstract class TelemetryClient {
  Future<void> recordCounter(String name, {Map<String, String>? tags});
}
