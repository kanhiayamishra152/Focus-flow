class UnitCategory {
  final String name;
  final String icon;
  final List<Unit> units;

  UnitCategory({
    required this.name,
    required this.icon,
    required this.units,
  });
}

class Unit {
  final String name;
  final String symbol;
  final double toBase; // Conversion factor to base unit

  Unit({
    required this.name,
    required this.symbol,
    required this.toBase,
  });
}

class CategoryData {
  static final List<UnitCategory> categories = [
    UnitCategory(
      name: 'Weight',
      icon: '⚖️',
      units: [
        Unit(name: 'Kilograms', symbol: 'kg', toBase: 1.0),
        Unit(name: 'Grams', symbol: 'g', toBase: 0.001),
        Unit(name: 'Milligrams', symbol: 'mg', toBase: 0.000001),
        Unit(name: 'Metric Tons', symbol: 't', toBase: 1000.0),
        Unit(name: 'Pounds', symbol: 'lb', toBase: 0.45359237),
        Unit(name: 'Ounces', symbol: 'oz', toBase: 0.02834952),
      ],
    ),
    UnitCategory(
      name: 'Length',
      icon: '📏',
      units: [
        Unit(name: 'Meters', symbol: 'm', toBase: 1.0),
        Unit(name: 'Kilometers', symbol: 'km', toBase: 1000.0),
        Unit(name: 'Centimeters', symbol: 'cm', toBase: 0.01),
        Unit(name: 'Millimeters', symbol: 'mm', toBase: 0.001),
        Unit(name: 'Miles', symbol: 'mi', toBase: 1609.344),
        Unit(name: 'Yards', symbol: 'yd', toBase: 0.9144),
        Unit(name: 'Feet', symbol: 'ft', toBase: 0.3048),
        Unit(name: 'Inches', symbol: 'in', toBase: 0.0254),
      ],
    ),
    UnitCategory(
      name: 'Volume',
      icon: '🧪',
      units: [
        Unit(name: 'Liters', symbol: 'L', toBase: 1.0),
        Unit(name: 'Milliliters', symbol: 'mL', toBase: 0.001),
        Unit(name: 'Cubic Meters', symbol: 'm³', toBase: 1000.0),
        Unit(name: 'Gallons (US)', symbol: 'gal', toBase: 3.785411784),
        Unit(name: 'Gallons (UK)', symbol: 'gal (UK)', toBase: 4.54609),
        Unit(name: 'Quarts (US)', symbol: 'qt', toBase: 0.946352946),
        Unit(name: 'Pints (US)', symbol: 'pt', toBase: 0.473176473),
        Unit(name: 'Cups (US)', symbol: 'cup', toBase: 0.236588236),
      ],
    ),
    UnitCategory(
      name: 'Temperature',
      icon: '🌡️',
      units: [
        Unit(name: 'Celsius', symbol: '°C', toBase: 1.0),
        Unit(name: 'Fahrenheit', symbol: '°F', toBase: 1.0),
        Unit(name: 'Kelvin', symbol: 'K', toBase: 1.0),
      ],
    ),
    UnitCategory(
      name: 'Area',
      icon: '📐',
      units: [
        Unit(name: 'Square Meters', symbol: 'm²', toBase: 1.0),
        Unit(name: 'Square Kilometers', symbol: 'km²', toBase: 1000000.0),
        Unit(name: 'Square Centimeters', symbol: 'cm²', toBase: 0.0001),
        Unit(name: 'Hectares', symbol: 'ha', toBase: 10000.0),
        Unit(name: 'Acres', symbol: 'ac', toBase: 4046.8564224),
        Unit(name: 'Square Feet', symbol: 'ft²', toBase: 0.09290304),
        Unit(name: 'Square Inches', symbol: 'in²', toBase: 0.00064516),
      ],
    ),
    UnitCategory(
      name: 'Speed',
      icon: '⚡',
      units: [
        Unit(name: 'Meters/Second', symbol: 'm/s', toBase: 1.0),
        Unit(name: 'Kilometers/Hour', symbol: 'km/h', toBase: 0.277777778),
        Unit(name: 'Miles/Hour', symbol: 'mph', toBase: 0.44704),
        Unit(name: 'Knots', symbol: 'kn', toBase: 0.514444444),
        Unit(name: 'Feet/Second', symbol: 'ft/s', toBase: 0.3048),
      ],
    ),
  ];

  static double convert(String category, double value, String fromSymbol, String toSymbol) {
    if (value.isNaN || value.isInfinite) return 0.0;
    
    final cat = categories.firstWhere((c) => c.name == category);
    final fromUnit = cat.units.firstWhere((u) => u.symbol == fromSymbol);
    final toUnit = cat.units.firstWhere((u) => u.symbol == toSymbol);

    // Special handling for Temperature
    if (category == 'Temperature') {
      return _convertTemperature(value, fromSymbol, toSymbol);
    }

    // Standard conversion: value * fromBase / toBase
    double baseValue = value * fromUnit.toBase;
    return baseValue / toUnit.toBase;
  }

  static double _convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    double celsius;

    // Convert to Celsius first
    switch (from) {
      case '°C':
        celsius = value;
        break;
      case '°F':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'K':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target
    switch (to) {
      case '°C':
        return celsius;
      case '°F':
        return (celsius * 9 / 5) + 32;
      case 'K':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }
}
