class PaginatedResponse<T> {
  final int currentPage;
  final List<UserData> data;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;
  final MetaData meta;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
    required this.meta,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'from': from,
      'last_page': lastPage,
      'per_page': perPage,
      'to': to,
      'total': total,
      'meta': meta.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String name;
  final Gates gates;

  UserData({required this.id, required this.name, required this.gates});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'gates': gates.toJson()};
  }
}

class Gates {
  final GateValue authorizedToView;
  final GateValue authorizedToUpdate;
  final GateValue authorizedToDelete;
  final GateValue authorizedToRestore;
  final GateValue authorizedToForceDelete;

  Gates({
    required this.authorizedToView,
    required this.authorizedToUpdate,
    required this.authorizedToDelete,
    required this.authorizedToRestore,
    required this.authorizedToForceDelete,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorized_to_view': authorizedToView.toJson(),
      'authorized_to_update': authorizedToUpdate.toJson(),
      'authorized_to_delete': authorizedToDelete.toJson(),
      'authorized_to_restore': authorizedToRestore.toJson(),
      'authorized_to_force_delete': authorizedToForceDelete.toJson(),
    };
  }

  bool get canView => authorizedToView.allowed;
  String? get viewMessage => authorizedToView.message;

  bool get canUpdate => authorizedToUpdate.allowed;
  String? get updateMessage => authorizedToUpdate.message;
}

class MetaData {
  final MetaGates gates;

  MetaData({required this.gates});

  Map<String, dynamic> toJson() {
    return {'gates': gates.toJson()};
  }
}

class MetaGates {
  final GateValue authorizedToCreate;

  MetaGates({required this.authorizedToCreate});

  factory MetaGates.fromJson(Map<String, dynamic> json) {
    return MetaGates(
      authorizedToCreate: GateValue.fromJson(json['authorized_to_create']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'authorized_to_create': authorizedToCreate.toJson()};
  }
}

class GateValue {
  final bool allowed;
  final String? message;

  const GateValue({required this.allowed, this.message});

  /// Accepts either:
  /// - `true` / `false`
  /// - `{ "allowed": bool, "message": "..." }`
  factory GateValue.fromJson(dynamic json) {
    if (json is bool) {
      return GateValue(allowed: json);
    }

    if (json is Map<String, dynamic>) {
      return GateValue(
        allowed: json['allowed'] as bool? ?? false,
        message: json['message'] as String?,
      );
    }

    throw ArgumentError('Invalid gate value: $json');
  }

  /// If there is no message, return a pure bool (to keep API compatible).
  /// If there is a message, return `{ allowed, message }`.
  dynamic toJson() {
    if (message == null) {
      return allowed;
    }

    return {'allowed': allowed, 'message': message};
  }
}
