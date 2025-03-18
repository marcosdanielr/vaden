import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class DartVersionDropdown extends StatefulWidget {
  final bool isEnabled;
  final List<String> versions;
  final String? selectedVersion;
  final Function(String)? onVersionSelected;

  const DartVersionDropdown({
    super.key,
    this.isEnabled = true,
    required this.versions,
    this.selectedVersion,
    this.onVersionSelected,
  });

  @override
  State<DartVersionDropdown> createState() => _DartVersionDropdownState();
}

class _DartVersionDropdownState extends State<DartVersionDropdown> {
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (widget.isEnabled) {
      setState(() {
        _isDropdownOpen = !_isDropdownOpen;
      });
    }
  }

  void _selectVersion(String version) {
    if (widget.onVersionSelected != null) {
      widget.onVersionSelected!(version);
    }
    // Não fechamos o dropdown aqui para manter ele aberto
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) {
        if (_isDropdownOpen) {
          setState(() {
            _isDropdownOpen = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              'Dart Version',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          // Dropdown Header - Shows selected version or placeholder
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.txtSupport2,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedVersion ?? 'Dart version',
                    style: TextStyle(
                      color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.disabledColor,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: VadenColors.backgroundColor2,
                      border: Border.all(
                        color: VadenColors.stkSupport2,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _isDropdownOpen
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: widget.isEnabled ? VadenColors.whiteColor : VadenColors.txtSupport2,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Dropdown Options - Only shown when dropdown is open
          if (_isDropdownOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              constraints: BoxConstraints(
                // Limita a altura máxima para permitir rolagem se houver muitas opções
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: VadenColors.whiteColor,
                  width: 1,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                // Permitir rolagem se houver muitas opções
                physics: const ClampingScrollPhysics(),
                itemCount: widget.versions.length,
                itemBuilder: (context, index) {
                  final version = widget.versions[index];
                  final isSelected = version == widget.selectedVersion;

                  return InkWell(
                    onTap: () => _selectVersion(version),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            version,
                            style: const TextStyle(
                              color: VadenColors.whiteColor,
                              fontSize: 16,
                            ),
                          ),
                          isSelected
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        VadenColors.gradientStart,
                                        VadenColors.gradientEnd,
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: VadenColors.whiteColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
