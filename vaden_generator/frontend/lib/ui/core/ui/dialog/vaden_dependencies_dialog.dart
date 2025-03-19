import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../themes/colors.dart';
import '../cards/vaden_card.dart';

// Modelo para representar uma dependência
class DependencyItem {
  final String name;
  final String description;
  final String tag;
  bool isSelected;

  DependencyItem({
    required this.name,
    required this.description,
    required this.tag,
    this.isSelected = false,
  });

  // Factory para criar a partir do JSON
  factory DependencyItem.fromJson(Map<String, dynamic> json) {
    return DependencyItem(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      tag: json['tag'] ?? '',
      isSelected: json['isDefault'] ?? false,
    );
  }
}

class DependenciesDialog extends StatefulWidget {
  final Function(List<DependencyItem>) onSave;
  final VoidCallback onCancel;
  final String apiUrl;

  const DependenciesDialog({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.apiUrl,
  });

  static Future<List<DependencyItem>?> show(
    BuildContext context,
    String apiUrl,
  ) async {
    return await showDialog<List<DependencyItem>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DependenciesDialog(
        apiUrl: apiUrl,
        onSave: (selectedDeps) {
          Navigator.of(context).pop(selectedDeps);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  State<DependenciesDialog> createState() => _DependenciesDialogState();
}

class _DependenciesDialogState extends State<DependenciesDialog> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<DependencyItem> _dependencies = [];
  String _currentCategory = 'Dev tools'; // Categoria atual exibida

  @override
  void initState() {
    super.initState();
    _fetchDependencies();
  }

  Future<void> _fetchDependencies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Chamada real para a API
      final response = await http.get(
        Uri.parse(widget.apiUrl),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Processar os dados da API - ajuste conforme a estrutura real da resposta
        if (data is List) {
          _dependencies = data.map((item) => DependencyItem.fromJson(item)).toList();
        } else if (data is Map && data.containsKey('dependencies')) {
          _dependencies =
              (data['dependencies'] as List).map((item) => DependencyItem.fromJson(item)).toList();
        } else {
          throw Exception('Formato de resposta da API inesperado');
        }

        // Obter a categoria da primeira dependência, se disponível
        if (_dependencies.isNotEmpty) {
          _currentCategory = _dependencies.first.tag;
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao carregar dependências: Status ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dependências: $e';
        _isLoading = false;
      });
    }
  }

  void _retryFetch() {
    _fetchDependencies();
  }

  void _toggleDependency(int index) {
    setState(() {
      _dependencies[index].isSelected = !_dependencies[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: 580,
        decoration: BoxDecoration(
          color: VadenColors.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: VadenColors.stkDisabled.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dependências',
                    style: GoogleFonts.anekBangla(
                      color: VadenColors.txtSecondary,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: VadenColors.backgroundColor2,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _currentCategory,
                      style: GoogleFonts.anekBangla(
                        color: VadenColors.txtSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: VadenColors.stkDisabled,
            ),
            if (_isLoading)
              Container(
                height: 300,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: VadenColors.errorColor,
                ),
              )
            else if (_errorMessage.isNotEmpty)
              Container(
                height: 300,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage,
                      style: GoogleFonts.anekBangla(
                        color: VadenColors.errorColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _retryFetch,
                      icon: const Icon(Icons.refresh, color: VadenColors.errorColor),
                      label: Text(
                        'Tentar novamente',
                        style: GoogleFonts.anekBangla(
                          color: VadenColors.errorColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_dependencies.isEmpty)
              Container(
                height: 300,
                alignment: Alignment.center,
                child: Text(
                  'Nenhuma dependência disponível',
                  style: GoogleFonts.anekBangla(
                    color: VadenColors.txtSupport,
                    fontSize: 16,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  minHeight: 50,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: _dependencies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _dependencies[index];
                    return VadenCard(
                      title: item.name,
                      subtitle: item.description,
                      tag: item.tag,
                      isSelected: item.isSelected,
                      onTap: () => _toggleDependency(index),
                      height: 80,
                    );
                  },
                ),
              ),
            const Divider(
              height: 1,
              thickness: 1,
              color: VadenColors.stkDisabled,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: VadenColors.txtSupport,
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.anekBangla(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final selectedDeps = _dependencies.where((dep) => dep.isSelected).toList();
                      widget.onSave(selectedDeps);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VadenColors.errorColor,
                      foregroundColor: VadenColors.txtSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.anekBangla(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
