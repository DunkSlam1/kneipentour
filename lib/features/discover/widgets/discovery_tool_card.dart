import 'package:flutter/material.dart';

class DiscoveryToolCard extends StatelessWidget {
  const DiscoveryToolCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.enabled = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: enabled ? colorScheme.primary : colorScheme.outline,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: enabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: enabled
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
