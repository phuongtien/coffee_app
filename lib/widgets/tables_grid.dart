// widgets/tables_grid.dart - Tables grid view
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tables_provider.dart';
import 'table_card.dart';

class TablesGrid extends StatelessWidget {
  const TablesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TablesProvider>(
      builder: (context, tablesProvider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: tablesProvider.tables.length,
              itemBuilder: (context, i) {
                return TableCard(table: tablesProvider.tables[i]);
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 800) return 3;
    if (width > 560) return 2;
    return 1;
  }
}