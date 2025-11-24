class LaravelRestApiActionsBody {
  final List<Action> fields;

  LaravelRestApiActionsBody({required this.fields});

  Map<String, dynamic> toJson() {
    return {'fields': fields.map((action) => action.toJson()).toList()};
  }
}

class Action {
  final String name;
  final String value;

  Action({required this.name, required this.value});

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
