import 'package:flutter/material.dart';

typedef CreateEntityCallback = Future<void> Function(Map<String, dynamic> json);
typedef UpdateEntityCallback = Future<void> Function(
  String id,
  Map<String, dynamic> json,
);
typedef DeleteEntityCallback = Future<void> Function(String id);

class EntityCrudPanel extends StatelessWidget {
  const EntityCrudPanel({
    super.key,
    required this.entityLabel,
    required this.onCreate,
    this.createTemplate = const {},
    this.onCompleted,
  });

  final String entityLabel;
  final CreateEntityCallback onCreate;
  final Map<String, dynamic> createTemplate;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final payload = await _showCreateFormDialog(
              context,
              title: 'Create $entityLabel',
              template: createTemplate,
            );
            if (payload == null) return;
            await _runWithFeedback(
              context,
              action: () => onCreate(payload),
              successMessage: '$entityLabel created',
            );
            onCompleted?.call();
          },
          icon: const Icon(Icons.add),
          label: Text('Create $entityLabel'),
        ),
      ],
    );
  }
}

class EntityUpdateOption {
  const EntityUpdateOption({
    required this.id,
    required this.label,
    required this.values,
  });

  final String id;
  final String label;
  final Map<String, dynamic> values;
}

class _UpdateDialogResult {
  const _UpdateDialogResult({required this.id, required this.payload});

  final String id;
  final Map<String, dynamic> payload;
}

class EntityRowActionsMenu extends StatelessWidget {
  const EntityRowActionsMenu({
    super.key,
    required this.entityLabel,
    required this.option,
    required this.template,
    required this.onUpdate,
    required this.onDelete,
    this.onCompleted,
  });

  final String entityLabel;
  final EntityUpdateOption option;
  final Map<String, dynamic> template;
  final UpdateEntityCallback onUpdate;
  final DeleteEntityCallback onDelete;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_RowAction>(
      tooltip: 'Actions',
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        if (action == _RowAction.update) {
          final result = await _showUpdateFormForOptionDialog(
            context,
            title: 'Update $entityLabel',
            template: template,
            option: option,
          );
          if (result == null) return;
          await _runWithFeedback(
            context,
            action: () => onUpdate(result.id, result.payload),
            successMessage: '$entityLabel updated',
          );
          onCompleted?.call();
          return;
        }

        final confirmed = await _showDeleteConfirmDialog(
          context,
          entityLabel: entityLabel,
          itemLabel: option.label,
        );
        if (confirmed != true) return;
        await _runWithFeedback(
          context,
          action: () => onDelete(option.id),
          successMessage: '$entityLabel deleted',
        );
        onCompleted?.call();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _RowAction.update,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.edit_outlined),
            title: Text('Update'),
          ),
        ),
        PopupMenuItem(
          value: _RowAction.delete,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.delete_outline),
            title: Text('Delete'),
          ),
        ),
      ],
    );
  }
}

enum _RowAction { update, delete }

Future<void> _runWithFeedback(
  BuildContext context, {
  required Future<void> Function() action,
  required String successMessage,
}) async {
  try {
    await action();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(successMessage)),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Operation failed: $e')),
    );
  }
}

Future<Map<String, dynamic>?> _showCreateFormDialog(
  BuildContext context, {
  required String title,
  required Map<String, dynamic> template,
}) async {
  final controllers = <String, TextEditingController>{};
  final boolValues = <String, bool>{};

  for (final entry in template.entries) {
    final value = entry.value;
    if (value is bool) {
      boolValues[entry.key] = value;
    } else {
      controllers[entry.key] = TextEditingController(
        text: value == null ? '' : value.toString(),
      );
    }
  }

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 560,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final entry in template.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildCreateField(
                          keyName: entry.key,
                          sampleValue: entry.value,
                          controller: controllers[entry.key],
                          boolValue: boolValues[entry.key],
                          onBoolChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              boolValues[entry.key] = value;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    final payload = <String, dynamic>{};
                    for (final entry in template.entries) {
                      final key = entry.key;
                      final sample = entry.value;
                      if (sample is bool) {
                        payload[key] = boolValues[key] ?? false;
                        continue;
                      }

                      final raw = controllers[key]?.text.trim() ?? '';
                      payload[key] = _coerceValue(raw, sample);
                    }

                    Navigator.of(dialogContext).pop(payload);
                  } catch (e) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Invalid form input: $e')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  ).whenComplete(() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
  });
}

dynamic _coerceValue(String raw, dynamic sampleValue) {
  if (sampleValue is int) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      throw FormatException('Expected integer for value "$raw"');
    }
    return parsed;
  }

  if (sampleValue is double) {
    final parsed = double.tryParse(raw);
    if (parsed == null) {
      throw FormatException('Expected decimal for value "$raw"');
    }
    return parsed;
  }

  if (sampleValue is num) {
    final parsed = num.tryParse(raw);
    if (parsed == null) {
      throw FormatException('Expected number for value "$raw"');
    }
    return parsed;
  }

  return raw;
}

Widget _buildCreateField({
  required String keyName,
  required dynamic sampleValue,
  required TextEditingController? controller,
  required bool? boolValue,
  required ValueChanged<bool?> onBoolChanged,
}) {
  final label = _toLabel(keyName);

  if (sampleValue is bool) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(
          value: boolValue ?? false,
          onChanged: (value) => onBoolChanged(value),
        ),
      ],
    );
  }

  TextInputType? keyboardType;
  if (sampleValue is int) {
    keyboardType = TextInputType.number;
  } else if (sampleValue is num) {
    keyboardType = const TextInputType.numberWithOptions(decimal: true);
  }

  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
    ),
  );
}

String _toLabel(String key) {
  if (key.isEmpty) return key;
  final spaced = key.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m.group(1)} ${m.group(2)}',
  );
  return spaced[0].toUpperCase() + spaced.substring(1);
}

Future<_UpdateDialogResult?> _showUpdateFormForOptionDialog(
  BuildContext context, {
  required String title,
  required Map<String, dynamic> template,
  required EntityUpdateOption option,
}) async {
  final controllers = <String, TextEditingController>{};
  final boolValues = <String, bool>{};

  for (final entry in template.entries) {
    final key = entry.key;
    final sample = entry.value;
    final sourceValue = option.values[key] ?? sample;
    if (sample is bool) {
      boolValues[key] = sourceValue is bool ? sourceValue : sample;
    } else {
      controllers[key] = TextEditingController(
        text: sourceValue == null ? '' : sourceValue.toString(),
      );
    }
  }

  return showDialog<_UpdateDialogResult>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 560,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final entry in template.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildCreateField(
                          keyName: entry.key,
                          sampleValue: entry.value,
                          controller: controllers[entry.key],
                          boolValue: boolValues[entry.key],
                          onBoolChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              boolValues[entry.key] = value;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    final payload = <String, dynamic>{};
                    for (final entry in template.entries) {
                      final key = entry.key;
                      final sample = entry.value;
                      if (sample is bool) {
                        payload[key] = boolValues[key] ?? false;
                        continue;
                      }
                      final raw = controllers[key]?.text.trim() ?? '';
                      payload[key] = _coerceValue(raw, sample);
                    }

                    Navigator.of(dialogContext).pop(
                      _UpdateDialogResult(id: option.id, payload: payload),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Invalid form input: $e')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  ).whenComplete(() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
  });
}

Future<bool?> _showDeleteConfirmDialog(
  BuildContext context, {
  required String entityLabel,
  required String itemLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Delete $entityLabel'),
        content: Text('Delete "$itemLabel"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
