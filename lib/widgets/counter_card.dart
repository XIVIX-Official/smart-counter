import 'package:flutter/material.dart';
import '../models/counter_room.dart';

class CounterCard extends StatelessWidget {
  final CounterRoom room;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isActive;

  const CounterCard({
    super.key,
    required this.room,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 4 : 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    context,
                    label: 'Items',
                    value: room.totalItems.toString(),
                    icon: Icons.inventory_2,
                  ),
                  _buildInfoChip(
                    context,
                    label: 'Active Items',
                    value: room.activeItems.toString(),
                    icon: Icons.check_circle,
                    backgroundColor: Colors.green.withOpacity(0.2),
                  ),
                  _buildInfoChip(
                    context,
                    label: 'Members',
                    value: room.memberCount.toString(),
                    icon: Icons.people,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String label,
    required String value,
    IconData? icon,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.8),
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}