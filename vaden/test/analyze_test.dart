// import 'package:analyzer/dart/analysis/results.dart';
// import 'package:analyzer/dart/analysis/utilities.dart';

// Future<void> main() async {
//   // Analisa um arquivo Dart
//   final result = await resolveFile(path: 'lib/foo_controller.dart');
//   if (result is ResolvedUnitResult) {
//     // Percorre as declarações
//     final unit = result.unit;
//     for (var declaration in unit.declarations) {
//       // Se for uma classe:
//       if (declaration is ClassDeclaration) {
//         // Olha as anotações dessa classe
//         for (var meta in declaration.metadata) {
//           final annotation = meta.name.name;
//           // Ex.: se a classe tiver @Controller, "annotation" == "Controller"
//           if (annotation == 'Controller') {
//             print('Found a controller: ${declaration.name.name}');
//             // Você pode inspecionar parâmetros da annotation, métodos da classe, etc.
//           }
//         }
//       }
//     }
//   }
// }
