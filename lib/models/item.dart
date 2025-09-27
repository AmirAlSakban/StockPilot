class Item {
	final String id;
	final String name;
	final String description;
	final double price;
	final String category;
	final int quantity;
	final String imageUrl;
	final String createdAt;
	final String updatedAt;

	Item({
		this.id,
		this.name,
		this.description,
		this.price,
		this.category,
		this.quantity,
		this.imageUrl,
		this.createdAt,
		this.updatedAt,
	});

	factory Item.fromJson(Map<String, dynamic> json) {
		return Item(
			id: json['_id']?.toString() ?? json['id']?.toString(),
			name: json['name'] ?? '',
			description: json['description'] ?? '',
			price: _toDouble(json['price']),
			category: json['category'] ?? 'General',
			quantity: _toInt(json['quantity']),
			imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/300x200.png?text=No+Image',
			createdAt: json['createdAt']?.toString() ?? '',
			updatedAt: json['updatedAt']?.toString() ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'description': description,
				'price': price,
				'category': category,
				'quantity': quantity,
				'imageUrl': imageUrl,
				'createdAt': createdAt,
				'updatedAt': updatedAt,
			};

	Item copyWith({
		String id,
		String name,
		String description,
		double price,
		String category,
		int quantity,
		String imageUrl,
		String createdAt,
		String updatedAt,
	}) {
		return Item(
			id: id ?? this.id,
			name: name ?? this.name,
			description: description ?? this.description,
			price: price ?? this.price,
			category: category ?? this.category,
			quantity: quantity ?? this.quantity,
			imageUrl: imageUrl ?? this.imageUrl,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
		);
	}

	static double _toDouble(dynamic v) {
		if (v == null) return 0.0;
		if (v is double) return v;
		if (v is int) return v.toDouble();
		return double.tryParse(v.toString()) ?? 0.0;
	}

	static int _toInt(dynamic v) {
		if (v == null) return 0;
		if (v is int) return v;
		return int.tryParse(v.toString()) ?? 0;
	}
}

