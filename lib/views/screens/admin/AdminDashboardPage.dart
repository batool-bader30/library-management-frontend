import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:library_management_web_front/core/constants/colors.dart';
import 'package:library_management_web_front/views/screens/admin/adminSideMenu.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightbackground,
      body: Row(
        children: [
          Adminsidemenu(selectedTitl: "Overview"),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  // ─── Main Content ──────────────────────────────────────
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Text(
            "Admin Dashboard",
            style: GoogleFonts.inriaSerif(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darktext,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(right: 240.0),
            child: _buildBarChartSection(),
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0x335A3E2B)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildPlatformInsights()),
              const SizedBox(width: 1),
              const VerticalDivider(color: Color.fromARGB(51, 48, 31, 19), width: 1),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: _buildTopAuthors()),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Bar Chart ─────────────────────────────────────────
  Widget _buildBarChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "1,080 borrowed books",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3B1F0E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Borrowing from 4-10, Mar 2027",
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF3B1F0E),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              backgroundColor: Colors.transparent,
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(color: Color(0xFF5A3E2B), width: 1),
                  left: BorderSide(color: Colors.transparent),
                ),
              ),
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                  ),
                ),
              ),
              barGroups: _buildBarGroups(),
              groupsSpace: 8,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _legendItem(const Color(0xFF4A1E0A), "Last 4 day"),
            const SizedBox(width: 24),
            _legendItem(const Color(0xFFB09080), "Last week"),
          ],
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final data = [
      [40.0, 55.0],
      [70.0, 45.0],
      [90.0, 60.0],
      [110.0, 75.0],
      [130.0, 95.0],
      [150.0, 110.0],
      [100.0, 80.0],
      [120.0, 90.0],
      [85.0, 70.0],
      [60.0, 85.0],
     
    ];

    return data.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value[0],
            color: const Color(0xFF4A1E0A),
            width: 14,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: entry.value[1],
            color: const Color(0xFFB09080),
            width: 14,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF5A3E2B)),
        ),
      ],
    );
  }

  // ─── Platform Insights ────────────────────────────────
  Widget _buildPlatformInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Platform Insights:",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3B1F0E),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // On-time Returns - large dark circle (bottom left)
              Positioned(
                left: 30,
                bottom: 50,
                child: _buildInsightCircle(
                  size: 160,
                  color: const Color(0xFF4A1E0A),
                  percentage: "85%",
                  label: "On-time\nReturns",
                  textColor: Colors.white,
                  fontSize: 28,
                ),
              ),
              // User Satisfaction - medium top right
              Positioned(
                left: 200,
                top: 0,
                child: _buildInsightCircle(
                  size: 130,
                  color: const Color(0xFF8B6055),
                  percentage: "79%",
                  label: "User\nSatisfaction",
                  textColor: Colors.white,
                  fontSize: 24,
                ),
              ),
              // Request Approval - small bottom right
              Positioned(
                left: 280,
                top: 80,
                child: _buildInsightCircle(
                  size: 110,
                  color: const Color(0xFFB09080),
                  percentage: "78%",
                  label: "Request\nApproval Rate",
                  textColor: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCircle({
    required double size,
    required Color color,
    required String percentage,
    required String label,
    required Color textColor,
    required double fontSize,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            percentage,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor.withOpacity(0.85),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Top Authors ──────────────────────────────────────
  Widget _buildTopAuthors() {
    final authors = [
      {"borrowed": "1,200 borrowed"},
      {"borrowed": "900 borrowed"},
      {"borrowed": "780 borrowed"},
      {"borrowed": "600 borrowed"},
      {"borrowed": "450 borrowed"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Authors:",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3B1F0E),
          ),
        ),
        const SizedBox(height: 16),
        ...authors.map((a) => _buildAuthorRow(a["borrowed"]!)),
      ],
    );
  }

  Widget _buildAuthorRow(String borrowed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF8B6055),
            child: const Icon(Icons.person, color: Colors.white70, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Text(
                  borrowed,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF3B1F0E),
                  ),
                ),
                const SizedBox(height: 6),
                const Divider(color: Color(0x335A3E2B), height: 1,endIndent:100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
