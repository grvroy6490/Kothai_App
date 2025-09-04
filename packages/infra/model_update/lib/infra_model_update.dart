library infra_model_update;

abstract class ModelUpdateClient {
  Future<void> checkAndUpdate();
}
