import 'package:auto_injector/auto_injector.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/data/repositories/generate_repository.dart';
import 'package:frontend/data/repositories/remote_generate_repository.dart';
import 'package:frontend/data/services/client_http.dart';
import 'package:frontend/data/services/url_launcher_service.dart';
import 'package:frontend/ui/generate/viewmodels/generate_viewmodel.dart';

final injector = AutoInjector();

void setupInjection() {
  injector.addInstance(Constants);
  injector.add(dioFactory);
  injector.addSingleton(ClientHttp.new);
  injector.addSingleton(UrlLauncherService.new);
  injector.addSingleton<GenerateRepository>(RemoteGenerateRepository.new);
  injector.addSingleton(GenerateViewmodel.new);

  injector.commit();
}
