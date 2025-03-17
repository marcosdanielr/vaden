import 'package:auto_injector/auto_injector.dart';
import '../ui/generate/viewmodels/generate_viewmodel.dart';

final injector = AutoInjector();

void setupInjection() {
  injector.addSingleton(GenerateViewmodel.new);

  injector.commit();
}
