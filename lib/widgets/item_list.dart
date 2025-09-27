import 'package:flutter/material.dart';
import 'package:stock_pilot/models/item.dart';
import 'package:stock_pilot/item_detail_widget.dart';

class ItemList extends StatelessWidget {
	final List<Item> items;
	final void Function() onRefresh;

	ItemList({@required this.items, this.onRefresh});

	@override
	Widget build(BuildContext context) {
		if (items == null || items.isEmpty) {
			return Center(
				child: Text(
					'No items yet. Tap + to add your first one.',
					style: Theme.of(context).textTheme.bodyMedium,
				),
			);
		}
		return RefreshIndicator(
			onRefresh: () async { if (onRefresh != null) onRefresh(); },
			child: ListView.separated(
				physics: const AlwaysScrollableScrollPhysics(),
				itemCount: items.length,
				separatorBuilder: (_, __) => Divider(height: 0),
				itemBuilder: (context, index) {
					final item = items[index];
					return ListTile(
						leading: Hero(
							tag: 'item-image-${item.id ?? index}',
							child: CircleAvatar(
								backgroundImage: NetworkImage(item.imageUrl),
								backgroundColor: Colors.grey.shade200,
							),
						),
						title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
						subtitle: Text('${item.category} • Qty ${item.quantity}'),
						trailing: Text(
							'\$${item.price.toStringAsFixed(2)}',
							style: TextStyle(fontWeight: FontWeight.bold),
						),
						onTap: () {
							Navigator.push(
								context,
								MaterialPageRoute(builder: (_) => ItemDetailWidget(item)),
							);
						},
					);
				},
			),
		);
	}
}

