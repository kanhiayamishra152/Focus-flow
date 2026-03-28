import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/converter_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/conversion_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/theme_toggle.dart';
import '../models/unit_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConverterProvider>(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF1A1A1A) : Color(0xFFF5F7FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              _buildHeader(provider, isDark),
              
              // Category Selection
              _buildCategorySection(isDark),
              
              // Conversion Area
              Expanded(
                child: _buildConversionArea(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ConverterProvider provider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unit Converter',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Convert anything, anywhere',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
          ThemeToggle(),
        ],
      ),
    );
  }

  Widget _buildCategorySection(bool isDark) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: CategoryData.categories.length,
        itemBuilder: (context, index) {
          final category = CategoryData.categories[index];
          final provider = Provider.of<ConverterProvider>(context, listen: false);
          
          return CategoryCard(
            name: category.name,
            icon: category.icon,
            isSelected: provider.selectedCategory == category.name,
            onTap: () {
              HapticFeedback.mediumImpact();
              provider.setCategory(category.name);
            },
          );
        },
      ),
    );
  }

  Widget _buildConversionArea() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // From Card
          ConversionCard(isFrom: true),
          
          const SizedBox(height: 16),
          
          // Swap Button (centered)
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Provider.of<ConverterProvider>(context, listen: false).swapUnits();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3D5AFE), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3D5AFE).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.swap_vert_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // To Card
          ConversionCard(isFrom: false),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          ActionButtons(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
