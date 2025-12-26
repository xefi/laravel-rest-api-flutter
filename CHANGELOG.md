# Changelog

## 0.2.2

### Changed

- Instruction fields now use `name` / `value` keys to match Laravel Rest API expectations

## 0.2.1

### Added

- Added multipart support for `MutateFactory` to allow file uploads using `FormData`
- New `mutateMultipart()` method for sending files alongside mutate payloads
- Forwarded `contentType` through the HTTP client to support `multipart/form-data`

### Improved

- Mutate endpoint now supports advanced use cases such as media uploads
- Better alignment with Laravel Rest API custom mutate hooks

### Backward Compatibility

- No breaking changes
- Existing JSON-based `mutate()` calls continue to work unchanged

## 0.2.0

### Added

- Added `DetailsFactory` to retrieve a single resource with relations, gates and metadata
- Added `RestoreFactory` to restore soft-deleted resources
- Added `ForceDeleteFactory` to permanently delete resources
- Added `LaravelRestApiDetailsResponse` to standardize details endpoint responses
- Added missing factories to fully cover Laravel Rest API resource interactions

### Fixed

- Fixed nested mutation relations serialization to correctly group relations by table name
- Prevented multiple relation operations from overwriting each other in mutate payloads
- Fixed `page` parameter not being sent in search requests when `instructions` was null

### Changed

- Instruction fields now use `field` / `value` keys to match Laravel Rest API expectations
- Actions requests now target the correct Lomkit endpoint format
- Improved alignment of SDK payloads with Laravel Rest API documentation

### Improved

- Explicit `null` values are now preserved in search filters and instruction fields
- Improved error handling consistency across search, actions, delete, restore and mutate factories
- Updated and stabilized unit tests across all factories

### Backward Compatibility

- No breaking API changes
- All changes are internal fixes or additive features only

## 0.1.2

- Make filter value nullable
- Added scope parameter on include

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
