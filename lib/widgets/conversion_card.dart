import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/converter_provider.dart';

class ConversionCard extends StatelessWidget {
  final bool isFrom;

  const ConversionCard({
    Key? key,
    required this.isFrom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConverterProvider>(context);
    final isDark = provider.isDarkMode;
    final units = provider.currentUnits;
    final selectedUnit = isFrom ? provider.fromUnit : provider.toUnit;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isFrom ? 'From' : 'To',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: isFrom
                    ? TextFormField(
                        initialValue: provider.inputValue,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*\.?\d*'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark 
                                ? Colors.grey[600] 
                                : Colors.grey[300],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          provider.setInputValue(value);
                        },
                      )
                    : Text(
                        provider.formattedResult.isEmpty 
                            ? '0' 
                            : provider.formattedResult,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D5AFE),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark 
                      ? Color(0xFF3D3D3D) 
                      : Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedUnit,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  dropdownColor: isDark ? Color(0xFF2D2D2D) : Colors.white,
                  items: units.map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit.symbol,
                      child: Text(
                        unit.symbol,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      HapticFeedback.selectionClick();
                      if (isFrom) {
                        provider.setFromUnit(value);
                      } else {
                        provider.setToUnit(value);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            units.firstWhere((u) => u.symbol == selectedUnit).name,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
