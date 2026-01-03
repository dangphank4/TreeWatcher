import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp & Phản hồi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== APP INFO =====
            _buildAppInfo(),

            const SizedBox(height: 24),

            // ===== FAQ =====
            const Text(
              'Câu hỏi thường gặp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildFaqItem(
              title: 'Ứng dụng này dùng để làm gì?',
              content:
              'Ứng dụng giúp bạn theo dõi, chăm sóc và nhắc nhở tưới nước cho cây trồng một cách hiệu quả.',
            ),
            _buildFaqItem(
              title: 'Làm sao biết khi nào cần tưới cây?',
              content:
              'Ứng dụng sẽ dựa vào lịch chăm sóc hoặc dữ liệu bạn nhập để nhắc thời điểm tưới cây.',
            ),
            _buildFaqItem(
              title: 'Cây bị vàng lá thì nên làm gì?',
              content:
              'Hãy kiểm tra lượng nước, ánh sáng và dinh dưỡng. Bạn cũng có thể gửi phản hồi để được hỗ trợ.',
            ),

            const SizedBox(height: 24),

            // ===== FEEDBACK =====
            const Text(
              'Gửi phản hồi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung phản hồi',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                onPressed: _submitFeedback,
                label: const Text(
                  'Gửi phản hồi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== APP INFO WIDGET =====
  Widget _buildAppInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.eco, size: 40, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ứng dụng Chăm sóc Cây trồng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Giúp bạn quản lý, theo dõi và chăm sóc cây trồng mỗi ngày một cách dễ dàng.',
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 6),
                  Text(
                    '👨‍💻 Phát triển bởi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Hai Đăng Phan Lê'),
                  SizedBox(height: 4),
                  Text('📧 Email: haidang.dev@example.com'),
                  SizedBox(height: 4),
                  Text('🌐 Phiên bản: 1.0.0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FAQ ITEM =====
  Widget _buildFaqItem({
    required String title,
    required String content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline),
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  // ===== SUBMIT FEEDBACK =====
  void _submitFeedback() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    // TODO: Gửi API / Firebase / Email
    debugPrint('Feedback title: $title');
    debugPrint('Feedback content: $content');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cảm ơn bạn đã gửi phản hồi 🌱')),
    );

    _titleController.clear();
    _contentController.clear();
  }
}
