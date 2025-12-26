class LaravelRestApiSearchBody {
  final TextSearch? text;
  final List<Scope>? scopes;
  final List<Filter>? filters;
  final List<Sort>? sorts;
  final List<Select>? selects;
  final List<Include>? includes;
  final List<Aggregate>? aggregates;
  final List<Instruction>? instructions;
  final List<String>? gates;
  final int? page;
  final int? limit;

  LaravelRestApiSearchBody({
    this.text,
    this.scopes,
    this.filters,
    this.sorts,
    this.selects,
    this.includes,
    this.aggregates,
    this.instructions,
    this.gates,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text!.toJson(),
      if (scopes != null) 'scopes': scopes!.map((e) => e.toJson()).toList(),
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
      if (sorts != null) 'sorts': sorts!.map((e) => e.toJson()).toList(),
      if (selects != null) 'selects': selects!.map((e) => e.toJson()).toList(),
      if (includes != null)
        'includes': includes!.map((e) => e.toJson()).toList(),
      if (aggregates != null)
        'aggregates': aggregates!.map((e) => e.toJson()).toList(),
      if (instructions != null)
        'instructions': instructions!.map((e) => e.toJson()).toList(),
      if (gates != null) 'gates': gates,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
  }

  Map<String, dynamic> toRequestJson() => {'search': toJson()};
}

enum TrashedMode { withTrashed, onlyTrashed, withoutTrashed }

extension TrashedModeJson on TrashedMode {
  String toJsonValue() {
    switch (this) {
      case TrashedMode.withTrashed:
        return 'with';
      case TrashedMode.onlyTrashed:
        return 'only';
      case TrashedMode.withoutTrashed:
        return 'without';
    }
  }
}

class TextSearch {
  final String? value;
  final TrashedMode? trashed;

  TextSearch({this.value, this.trashed});

  Map<String, dynamic> toJson() {
    return {
      if (value != null) 'value': value,
      if (trashed != null) 'trashed': trashed!.toJsonValue(),
    };
  }
}

class Scope {
  final String name;
  final List<dynamic>? parameters;

  Scope({required this.name, this.parameters});

  Map<String, dynamic> toJson() {
    return {'name': name, if (parameters != null) 'parameters': parameters};
  }
}

class Filter {
  final String? field;
  final String? operator;
  final dynamic value;
  final String? type;
  final List<Filter>? nested;

  Filter({this.field, this.operator, this.value, this.type, this.nested});

  Map<String, dynamic> toJson() {
    return {
      if (field != null) 'field': field,
      if (operator != null) 'operator': operator,
      if (nested == null) 'value': value,
      if (type != null) 'type': type,
      if (nested != null) 'nested': nested!.map((e) => e.toJson()).toList(),
    };
  }
}

class Sort {
  final String field;
  final String direction;

  Sort({required this.field, this.direction = 'asc'});

  Map<String, dynamic> toJson() => {'field': field, 'direction': direction};
}

class Select {
  final String field;

  Select({required this.field});

  Map<String, dynamic> toJson() => {'field': field};
}

class Include {
  final String relation;

  final TextSearch? text;
  final List<Scope>? scopes;
  final List<Filter>? filters;
  final List<Sort>? sorts;
  final List<Select>? selects;
  final List<Include>? includes;
  final List<Aggregate>? aggregates;
  final List<Instruction>? instructions;
  final List<String>? gates;
  final int? page;
  final int? limit;

  const Include({
    required this.relation,
    this.text,
    this.scopes,
    this.filters,
    this.sorts,
    this.selects,
    this.includes,
    this.aggregates,
    this.instructions,
    this.gates,
    this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      if (text != null) 'text': text!.toJson(),
      if (scopes != null) 'scopes': scopes!.map((e) => e.toJson()).toList(),
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
      if (sorts != null) 'sorts': sorts!.map((e) => e.toJson()).toList(),
      if (selects != null) 'selects': selects!.map((e) => e.toJson()).toList(),
      if (includes != null)
        'includes': includes!.map((e) => e.toJson()).toList(),
      if (aggregates != null)
        'aggregates': aggregates!.map((e) => e.toJson()).toList(),
      if (instructions != null)
        'instructions': instructions!.map((e) => e.toJson()).toList(),
      if (gates != null) 'gates': gates,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
  }
}

class Aggregate {
  final String relation;
  final String type;
  final String field;
  final String? alias;
  final List<Filter>? filters;

  Aggregate({
    required this.relation,
    required this.type,
    required this.field,
    this.alias,
    this.filters,
  });

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      'type': type,
      'field': field,
      if (alias != null) 'alias': alias,
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
    };
  }
}

class Instruction {
  final String name;
  final List<InstructionField> fields;

  Instruction({required this.name, required this.fields});

  Map<String, dynamic> toJson() {
    return {'name': name, 'fields': fields.map((e) => e.toJson()).toList()};
  }
}

class InstructionField {
  final String name;
  final dynamic value;

  const InstructionField({required this.name, required this.value});

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
