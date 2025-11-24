class LaravelRestApiMutateResponse {
  final List<dynamic> created;
  final List<dynamic> updated;

  LaravelRestApiMutateResponse({required this.created, required this.updated});

  Map<String, dynamic> toJson() {
    return {'created': created, 'updated': updated};
  }
}
