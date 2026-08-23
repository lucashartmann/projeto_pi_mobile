import 'package:flutter/material.dart';
import 'widgets/bottom-nav.dart';
import '../utils/app_theme.dart';

class Atendimento extends StatefulWidget {
  const Atendimento({super.key});

  @override
  State<Atendimento> createState() => _AtendimentoState();
}

class _AtendimentoState extends State<Atendimento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atendimentos'), elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.hoverColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.support_agent_outlined,
                size: 60,
                color: AppColors.hoverColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Atendimentos',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum atendimento no momento',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}
