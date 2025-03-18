import 'dart:developer';

import 'package:flutter/material.dart';

import '../ui/core/ui/ui.dart';
import '../ui/core/ui/cards/vaden_dependencies_selector.dart' as dependencies;

class UiExamples extends StatefulWidget {
  const UiExamples({super.key});

  @override
  State<UiExamples> createState() => _UiExamplesState();
}

class _UiExamplesState extends State<UiExamples> {
  String? _selectedVersion;
  bool _isLoading = false;

  String? _selectedCard;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _selectCard(String cardId) {
    setState(() {
      if (_selectedCard == cardId) {
        _selectedCard = null;
      } else {
        _selectedCard = cardId;
      }
    });
  }

  // Mock de versões
  final List<String> _dartVersions = [
    '3.8.0-70.1.beta',
    '3.7.1 (ref dcddfab)',
    '3.7.0',
    '3.3.1',
    '3.2.1',
    '3.1.0',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VadenColors.backgroundColor2,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VadenTextInput(
                label: 'Project Name',
                hint: 'Enter project name',
              ),
              const SizedBox(height: 8),
              DartVersionDropdown(
                versions: _dartVersions,
                selectedVersion: _selectedVersion,
                onVersionSelected: (version) {
                  setState(() {
                    _selectedVersion = version;
                  });
                },
              ),
              const SizedBox(height: 24),
              VadenButtonExtension.primary(
                title: 'Primary Button',
                onPressed: _toggleLoading,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.outlined(
                title: 'Outlined Button',
                onPressed: _toggleLoading,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.text(
                title: 'Text Button',
                onPressed: _toggleLoading,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.disabled(
                title: 'Disabled Button',
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.custom(
                title: 'Borda Verde',
                onPressed: () {},
                style: VadenButtonStyle.outlined,
                borderColor: Colors.green,
                textColor: Colors.yellow,
                borderWidth: 2,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.gradientText(
                title: 'Fundo Branco + Texto Gradiente',
                onPressed: () {},
                style: VadenButtonStyle.filled,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.custom(
                title: 'Gradiente Azul',
                onPressed: () {},
                backgroundGradient: const LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                textColor: Colors.white,
                icon: Icons.star,
                iconColor: Colors.yellow,
              ),
              const SizedBox(height: 16),
              VadenButtonExtension.custom(
                title: 'Super Personalizado',
                onPressed: () {},
                textStyle: VadenTextStyle.gradient,
                textGradient: const LinearGradient(
                  colors: [Colors.pink, Colors.yellow],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderColor: const Color.fromARGB(255, 147, 85, 255),
                borderWidth: 1,
                style: VadenButtonStyle.outlined,
                icon: Icons.favorite,
                iconColor: Colors.pink,
              ),
              const SizedBox(height: 16),
              VadenCard(
                title: 'Card',
                subtitle: 'Subtitle',
                tag: 'Dev tools',
                isSelected: _selectedCard == 'card',
                onTap: () => _selectCard('card'),
              ),
              const SizedBox(height: 16),
              VadenProjectCard(
                title: 'Gradle - Groovy',
                variant: ProjectVariant.gradle,
                onTap: () => _selectCard('gradle-groovy'),
                isSelected: _selectedCard == 'gradle-groovy',
              ),
              const SizedBox(height: 16),
              VadenProjectCard(
                title: 'Gradle - Kotlin',
                variant: ProjectVariant.gradle,
                onTap: () => _selectCard('gradle-kotlin'),
                isSelected: _selectedCard == 'gradle-kotlin',
              ),
              const SizedBox(height: 16),
              VadenProjectCard(
                title: 'Marven - Groovy',
                variant: ProjectVariant.marven,
                onTap: () => _selectCard('marven-groovy'),
                isSelected: _selectedCard == 'marven-groovy',
              ),
              const SizedBox(height: 16),
              VadenLanguageSelector(
                initialLanguage: Language.portuguese,
                onLanguageChanged: (language) {
                  // Faça algo com a seleção de idioma
                  log('Idioma alterado para: $language');
                },
              ),
              const SizedBox(height: 16),
              VadenDependenciesSelector(
                initialLanguage: dependencies.Language.devTools,
                onLanguageChanged: (language) {
                  // Faça algo com a seleção de dependência
                  log('Dependência alterada para: $language');
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
