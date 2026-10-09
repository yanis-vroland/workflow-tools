import 'package:flutter/material.dart';

import '../db/local_db.dart';
import '../models/intervention.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'intervention_detail_screen.dart';

/// Planning du jour du technicien, avec repli sur le cache local hors réseau.
class InterventionListScreen extends StatefulWidget {
  const InterventionListScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<InterventionListScreen> createState() => _InterventionListScreenState();
}

class _InterventionListScreenState extends State<InterventionListScreen> {
  final _localDb = LocalDb();
  late final ApiClient _api = ApiClient(widget.authService);
  List<Intervention> _interventions = [];
  bool _offline = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final interventions = await _api.todayInterventions();
      await _localDb.saveAll(interventions);
      setState(() {
        _interventions = interventions;
        _offline = false;
      });
    } catch (_) {
      // TODO: relire le cache local quand le réseau est indisponible
      setState(() => _offline = true);
    } finally {
      setState(() => _loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.orange;
      case 'done':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes interventions'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: Column(
        children: [
          if (_offline)
            const MaterialBanner(
              content: Text('Hors connexion : données du dernier chargement'),
              actions: [SizedBox.shrink()],
            ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _interventions.length,
              itemBuilder: (context, index) {
                final intervention = _interventions[index];
                return ListTile(
                  leading: Icon(Icons.build, color: _statusColor(intervention.status)),
                  title: Text(intervention.address),
                  subtitle: Text(TimeOfDay.fromDateTime(intervention.startsAt).format(context)),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InterventionDetailScreen(intervention: intervention, api: _api),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
