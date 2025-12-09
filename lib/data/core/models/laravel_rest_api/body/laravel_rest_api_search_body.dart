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
}

class TextSearch {
  final String? value;

  TextSearch({this.value});

  Map<String, dynamic> toJson() {
    return {if (value != null) 'value': value};
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
      if (value != null) 'value': value,
      if (type != null) 'type': type,
      if (nested != null) 'nested': nested!.map((e) => e.toJson()).toList(),
    };
  }
}

class Sort {
  final String field;
  final String direction;

  Sort({required this.field, required this.direction});

  Map<String, dynamic> toJson() {
    return {'field': field, 'direction': direction};
  }
}

class Select {
  final String field;

  Select({required this.field});

  Map<String, dynamic> toJson() {
    return {'field': field};
  }
}

class Include {
  final String relation;
  final List<Include>? includes;
  final List<Filter>? filters;
  final List<Select>? selects;
  final List<Scope>? scopes;
  final int? limit;

  Include({
    required this.relation,
    this.includes,
    this.filters,
    this.selects,
    this.scopes,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      if (includes != null)
        'includes': includes!.map((e) => e.toJson()).toList(),
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
      if (selects != null) 'selects': selects!.map((e) => e.toJson()).toList(),
      if (scopes != null) 'scopes': scopes!.map((e) => e.toJson()).toList(),
      if (limit != null) 'limit': limit,
    };
  }
}

class Aggregate {
  final String relation;
  final String type;
  final String field;
  final List<Filter>? filters;

  Aggregate({
    required this.relation,
    required this.type,
    required this.field,
    this.filters,
  });

  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      'type': type,
      'field': field,
      if (filters != null) 'filters': filters!.map((e) => e.toJson()).toList(),
    };
  }
}

class Instruction {
  final String name;
  final List<Field> fields;

  Instruction({required this.name, required this.fields});

  Map<String, dynamic> toJson() {
    return {'name': name, 'fields': fields.map((e) => e.toJson()).toList()};
  }
}

class Field {
  final String name;
  final dynamic value;

  Field({required this.name, required this.value});

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}
