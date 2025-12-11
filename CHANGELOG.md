# Changelog

## 0.1.1

Added support for gate responses returning either a boolean or detailed policy message.

## 0.1.0

### Added

- New field `TextSearch? text` for `SearchFactory` (https://laravel-rest-api.lomkit.com/digging-deeper/full-text-search)
- New field `List<Select>? selects` for `Include`, allowing us to specify which fields to retrieve from distant relationships
- New field `List<Include>? includes` for `Include`, allowing us to fetch values from distant relationships
- New field `bool? withoutDetaching` for `Mutation`, allowing us to specify if sync should detach
- New field `List<MutationRelation>? relations` for `Mutation` (https://laravel-rest-api.lomkit.com/endpoints/mutate#relations)
- New `enum MutationRelationOperation` to define complex relation operations
- You can now pass `null` in filter options
- Raised the minimum Dart SDK version to 3.10.0

### Changed

- `MutationOperation` now only has `{ create, update }` values (before: `{ create, update, attach, detach, toggle, sync }`)

### Removed

- Default generated example code
- Unused `.fromJson()` methods

### Breaking Changes

- Generic type for `ActionsFactory` and `MutateFactory` removed (they were only used with the `.fromJson()` methods)
- `MutationOperation` value set reduced as mentioned above

## 0.0.1

Core functionality.
