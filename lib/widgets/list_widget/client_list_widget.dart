import 'package:flutter/material.dart';
import '../../models/client.dart';
import '../../services/client_service.dart';
import '../form_screen/client_form_screen.dart';

class ClientListWidget extends StatelessWidget {
  final List<Client> clients;
  final Function(Client) onEdit;
  final Function(Client) onDelete;

  const ClientListWidget({
    Key? key,
    required this.clients,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  void _confirmDelete(BuildContext context, Client client) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить клиента'),
        content: Text('Удалить ${client.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Нет'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
            },
            child: Text('Да'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ClientService.deleteClient(client.id);
      onDelete(client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final client = clients[index];
        return ListTile(
          title: Text(client.fullName),
          subtitle: Text('${client.phone} • ${client.email}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final updatedClient = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientFormScreen(client: client),
                  ),
                );
                if (updatedClient != null && updatedClient is Client) {
                  await ClientService.updateClient(updatedClient);
                  onEdit(updatedClient);
                }
              } else if (value == 'delete') {
                _confirmDelete(context, client);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Редактировать')),
              PopupMenuItem(value: 'delete', child: Text('Удалить')),
            ],
          ),
        );
      },
    );
  }
}
