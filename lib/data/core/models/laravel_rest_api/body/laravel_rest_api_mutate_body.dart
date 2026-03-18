class LaravelRestApiMutateBody {
  final List<Mutation> mutate;
  final Map<String, dynamic> body;

  LaravelRestApiMutateBody({required this.mutate, required this.body});

  Map<String, dynamic> toJson() => {
    "mutate": mutate.map((m) => m.toJson()).toList(),
    ...body,
  };
}

enum MutationOperation { create, update }

enum RelationType { singleRelation, multipleRelation }

enum MutationRelationOperation { create, update, attach, detach, toggle, sync }

class Mutation {
  final MutationOperation operation;
  final dynamic key;
  final Map<String, dynamic>? attributes;
  final bool? withoutDetaching;
  final List<MutationRelation>? relations;

  Mutation({
    this.key,
    this.relations,
    this.attributes,
    this.withoutDetaching,

    required this.operation,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'operation': operation.name,
      if (key != null) 'key': key,
      if (withoutDetaching != null) 'without_detaching': withoutDetaching,
      if (attributes != null) 'attributes': attributes,
    };

    if (relations != null && relations!.isNotEmpty) {
      map['relations'] = _relationsToGroupedJson(relations!);
    }

    return map;
  }
}

class MutationRelation {
  final String table;
  final MutationRelationOperation operation;
  final RelationType relationType;

  final dynamic key;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? pivot;
  final bool? withoutDetaching;

  final List<MutationRelation>? relations;

  MutationRelation({
    this.key,
    this.pivot,
    this.relations,
    this.attributes,
    this.withoutDetaching,
    this.relationType = RelationType.singleRelation,

    required this.table,
    required this.operation,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.name,
      if (key != null) 'key': key,
      if (attributes != null) 'attributes': attributes,
      if (pivot != null) 'pivot': pivot,
      if (withoutDetaching != null) 'without_detaching': withoutDetaching,
      if (relations != null && relations!.isNotEmpty)
        'relations': _relationsToGroupedJson(relations!),
    };
  }
}

Map<String, dynamic> _relationsToGroupedJson(List<MutationRelation> relations) {
  final map = <String, dynamic>{};

  for (final r in relations) {
    final key = r.table;
    final value = r.toJson();

    if (r.relationType == RelationType.singleRelation) {
      map[key] = value;
      continue;
    }

    final existing = map[key];
    if (existing == null) {
      map[key] = [value];
    } else if (existing is List) {
      existing.add(value);
    } else {
      map[key] = [existing, value];
    }
  }

  return map;
}
