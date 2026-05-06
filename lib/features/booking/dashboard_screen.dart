import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../providers/auth_providers.dart';
import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueBox = ref.watch(queueTokenBoxProvider);
    final auth = ref.watch(authServiceProvider);
    final user = ref.watch(authStateProvider).value;
    final roleAsync = user != null
        ? ref.watch(userRoleProvider(user.uid))
        : const AsyncValue<String?>.data(null);

    final isAdmin = roleAsync.value == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isAdmin ? 'Admin Panel' : 'Hello, Patient 👋',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const Text(
                        'Appointment Manager',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.shield_outlined),
                  tooltip: 'Admin Area',
                  onPressed: () => context.push('/admin'),
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () => auth.signOut(),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Card
                ValueListenableBuilder<Box<QueueToken>>(
                  valueListenable: queueBox.listenable(),
                  builder: (context, box, _) {
                    final tokens = box.values;
                    final waiting = tokens.where((t) => t.status == 'Waiting').length;
                    final serving = tokens.where((t) => t.status == 'Serving').length;
                    final completed = tokens.where((t) => t.status == 'Completed').length;

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Waiting', waiting, Colors.orange),
                          _buildStatDivider(),
                          _buildStat('Serving', serving, const Color(0xFF2563EB)),
                          _buildStatDivider(),
                          _buildStat('Done', completed, Colors.green),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),
                const Text(
                  'Actions',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
                const SizedBox(height: 14),

                // Action Cards
                _buildActionRow(context, [
                  _ActionItem(title: 'Book', subtitle: 'New appointment', icon: Icons.add_circle_outline, color: const Color(0xFF2563EB), route: '/booking'),
                  _ActionItem(title: 'Queue', subtitle: 'Live status', icon: Icons.people_outline, color: Colors.orange, route: '/queue'),
                ]),
                const SizedBox(height: 12),
                _buildActionRow(context, [
                  _ActionItem(title: 'Search', subtitle: 'Find records', icon: Icons.search, color: Colors.teal, route: '/search'),
                  if (isAdmin)
                    _ActionItem(title: 'Manage', subtitle: 'Admin controls', icon: Icons.admin_panel_settings_outlined, color: Colors.deepPurple, route: '/admin'),
                ]),

                const SizedBox(height: 28),
                // Info banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF2563EB)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isAdmin
                              ? 'You have admin access. Manage the queue from the Manage section.'
                              : 'Book an appointment to get your queue token. You\'ll be notified when it\'s your turn.',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1D4ED8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: Colors.black.withOpacity(0.08));
  }

  Widget _buildActionRow(BuildContext context, List<_ActionItem> items) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: items.last == item ? 0 : 12),
            child: _buildActionCard(context, item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionItem item) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(item.subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
  const _ActionItem({required this.title, required this.subtitle, required this.icon, required this.color, required this.route});
}
