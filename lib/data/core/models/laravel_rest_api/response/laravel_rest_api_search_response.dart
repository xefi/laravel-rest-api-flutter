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
  final bool authorizedToView;
  final bool authorizedToUpdate;
  final bool authorizedToDelete;
  final bool authorizedToRestore;
  final bool authorizedToForceDelete;

  Gates({
    required this.authorizedToView,
    required this.authorizedToUpdate,
    required this.authorizedToDelete,
    required this.authorizedToRestore,
    required this.authorizedToForceDelete,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorized_to_view': authorizedToView,
      'authorized_to_update': authorizedToUpdate,
      'authorized_to_delete': authorizedToDelete,
      'authorized_to_restore': authorizedToRestore,
      'authorized_to_force_delete': authorizedToForceDelete,
    };
  }
}

class MetaData {
  final MetaGates gates;

  MetaData({required this.gates});

  Map<String, dynamic> toJson() {
    return {'gates': gates.toJson()};
  }
}

class MetaGates {
  final bool authorizedToCreate;

  MetaGates({required this.authorizedToCreate});

  Map<String, dynamic> toJson() {
    return {'authorized_to_create': authorizedToCreate};
  }
}
