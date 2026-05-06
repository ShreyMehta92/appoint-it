import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/models/appointment_model.dart';
import '../../data/models/queue_token_model.dart';
import '../../providers/data_providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Scheduled', 'In Progress', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final appointmentBox = ref.watch(appointmentBoxProvider);
    final queueBox = ref.watch(queueTokenBoxProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search & Filter')),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: ValueListenableBuilder<Box<Appointment>>(
              valueListenable: appointmentBox.listenable(),
              builder: (context, box, _) {
                var appointments = box.values.toList();

                // Apply Filters
                if (_selectedFilter != 'All') {
                  appointments = appointments.where((a) => a.status == _selectedFilter).toList();
                }

                // Apply Search
                if (_searchQuery.isNotEmpty) {
                  appointments = appointments
                      .where((a) => a.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }

                // Sort by newest first
                appointments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (appointments.isEmpty) {
                  return const Center(child: Text('No results found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appt = appointments[index];
                    
                    // Find associated queue token if any
                    final token = _getQueueToken(queueBox, appt.id);

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appt.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Chip(
                                  label: Text(appt.status, style: const TextStyle(fontSize: 12)),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Service: ${appt.serviceType}'),
                            Text('Date: ${DateFormat('MMM dd, yyyy').format(appt.date)}'),
                            Text('Time Slot: ${appt.timeSlot}'),
                            
                            if (token != null) ...[
                              const Divider(),
                              Row(
                                children: [
                                  const Icon(Icons.confirmation_number, size: 16, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Queue Token: #${token.queueNumber} (${token.status})',
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  QueueToken? _getQueueToken(Box<QueueToken> box, String appointmentId) {
    try {
      return box.values.firstWhere((t) => t.appointmentId == appointmentId);
    } catch (_) {
      return null;
    }
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by patient name...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
