import 'package:flutter/material.dart';

class StandingsCardWidget extends StatelessWidget {
  const StandingsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 1. Student Info Header Box
          _buildStudentHeader('សុខ សាន្ត – ថ្នាក់ ៧ "ក"'),
          const SizedBox(height: 16),

          // 2. Dropdown Filters Row
          Row(
            children: [
              _buildSmallDropdown('មករា'),
              const SizedBox(width: 8),
              _buildSmallDropdown('ឆមាស ២'),
              const SizedBox(width: 8),
              _buildSmallDropdown('២០២៦'),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Score Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00675B), width: 1.5),
            ),
            child: Column(
              children: [
                // Table Header
                _buildTableHeader(),

                // Table Rows
                _buildScoreRow('អក្សរសាស្ត្រខ្មែរ', '៨០', 'ល្អ', Colors.green),
                _buildScoreRow('គណិតវិទ្យា', '៧០', 'ល្អ', Colors.green),
                _buildScoreRow('សិក្សាសង្គម', '៣០', 'គួរកែម្អ', Colors.red),
                _buildScoreRow(
                  'វិទ្យាសាស្ត្រ',
                  '៥០',
                  'ព្យាយាមបន្ថែម',
                  Colors.orange,
                ),
                _buildScoreRow('ភាសាអង់គ្លេស', '៩០', 'ល្អណាស់', Colors.teal),

                // Table Footer (Total)
                _buildTableFooter('សរុប', '៣២០', '១២'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildStudentHeader(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00675B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSmallDropdown(String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(fontSize: 12)),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF00675B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'មុខវិជ្ជា',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'ពិន្ទុ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'ចំណាត់ថ្នាក់',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(
    String subject,
    String score,
    String grade,
    Color gradeColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              subject,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              grade,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: gradeColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableFooter(String label, String totalScore, String rank) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF00675B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              totalScore,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              rank,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
