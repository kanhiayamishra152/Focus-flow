import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/unit_models.dart';

class ConverterProvider with ChangeNotifier {
  String _selectedCategory = 'Weight';
  String _fromUnit = 'kg';
  String _toUnit = 'g';
  String _inputValue = '';
  bool _isDarkMode = false;

  String get selectedCategory => _selectedCategory;
  String get fromUnit => _fromUnit;
  String get toUnit => _toUnit;
  String get inputValue => _inputValue;
  bool get isDarkMode => _isDarkMode;

  List<Unit> get currentUnits {
    final category = CategoryData.categories
        .firstWhere((c) => c.name == _selectedCategory);
    return category.units;
  }

  UnitCategory get currentCategory {
    return CategoryData.categories.firstWhere((c) => c.name == _selectedCategory);
  }

  double get convertedValue {
    if (_inputValue.isEmpty) return 0.0;
    final value = double.tryParse(_inputValue);
    if (value == null) return 0.0;
    return CategoryData.convert(_selectedCategory, value, _fromUnit, _toUnit);
  }

  String get formattedResult {
    final result = convertedValue;
    if (result == 0.0 && _inputValue.isEmpty) return '';
    
    // Handle very small or very large numbers
    if (result.abs() < 0.000001 || result.abs() > 999999999) {
      return result.toExponential(8);
    }
    
    // Format with up to 10 decimal places, removing trailing zeros
    String formatted = result.toStringAsFixed(10);
    formatted = formatted.replaceAll(RegExp(r'\.?0*$'), '');
    
    // Add commas for readability
    final parts = formatted.split('.');
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    
    return parts.length > 1 ? '${parts[0]}.${parts[1]}' : parts[0];
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      final cat = CategoryData.categories.firstWhere((c) => c.name == category);
      _fromUnit = cat.units[0].symbol;
      _toUnit = cat.units[1].symbol;
      _inputValue = '';
      notifyListeners();
    }
  }

  void setFromUnit(String unit) {
    if (_fromUnit != unit) {
      _fromUnit = unit;
      notifyListeners();
    }
  }

  void setToUnit(String unit) {
    if (_toUnit != unit) {
      _toUnit = unit;
      notifyListeners();
    }
  }

  void setInputValue(String value) {
    _inputValue = value;
    notifyListeners();
  }

  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
