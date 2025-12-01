# OpenID4VP DCQL

[![Status](https://github.com/nombrekeff/openid4vp_dcql/actions/workflows/dart.yml/badge.svg)](https://github.com/nombrekeff/openid4vp_dcql/actions/workflows/dart.yml)
[![Pub](https://img.shields.io/pub/v/openid4vp_dcql)](https://pub.dev/packages/openid4vp_dcql)

A Dart library for building and validating **Digital Credentials Query Language (DCQL)** queries as defined in the [OpenID for Verifiable Presentations (OpenID4VP) v1.0 specification](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query).

Build complex credential queries with a fluent, type-safe API, validate them against the spec, and serialize them to JSON for transmission.

## Package version to Spec

List of package versions and what specs they support

| version                                                          | Spec                                                                                              |
| ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| [v1.0.0](https://pub.dev/packages/openid4vp_dcql/versions/1.0.0) | [v1.0](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query) |

## Why

* **Fluent Builder API**: Construct complex nested queries with readable, chainable methods.
* **Type Safety**: Compile-time checks for known credential types (`mdoc`, `sd-jwt`) and claims.
* **Spec Compliance**: Built-in validation ensures your queries meet the DCQL specification requirements.
* **Zero Boilerplate**: No need to manually construct deeply nested Maps or JSON objects.

## What

This library focuses exclusively on the **Digital Credentials Query Language (DCQL)** part of the OpenID4VP specification.

It does **not** handle

* Cryptographic operations (signing, encryption, or verification of credentials).
* PKI or Key Management.
* Transport protocols (OID4VP request/response handling).

It is designed to be used within a larger OpenID4VP implementation or by a Verifier application that needs to construct queries.

## Install

```bash
dart pub add openid4vp_dcql
```

## Core Example

```dart
import 'dart:convert';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

void main() {
  try {
    final query = DcqlBuilder()
      // Request an mDoc Driving License
      .credential('credential-1', type: CredentialType.mdocDl)
          .claim(Claims.mdocDl.firstName, id: 'first_name')
          .claim(Claims.mdocDl.documentNumber, id: 'doc_number')
          // Define combinations of claims that satisfy the requirement
          .claimSet(["first_name", "doc_number"])
      
      // Request an SD-JWT PID
      .credential('credential-2', type: CredentialType.sdJwtPid)
          .claim(Claims.sdJwtPid.documentNumber)
      
      // Define logic between credentials (e.g., Credential 1 OR Credential 2)
      .credentialSet()
          .option(['credential-1'])
          .option(['credential-2'])

      // Build will throw a ValidationException if the query is invalid
      // can be skipped by setting (skipValidation: true)
      .build();

    print(jsonEncode(query.toJson()));
  } catch (e) {
    print(e);
  }
}
```

## Manual Construction

You can also construct the query object directly without using the builder. However, you will lose some conveniences, such as automatic path prefixing (namespaces) for claims.

```dart
import 'dart:convert';
import 'package:openid4vp_dcql/openid4vp_dcql.dart';

void main() {
  final query = DcqlQuery(
    credentials: [
      Credential(
        id: 'credential-1',
        format: Formats.mso_mdoc,
        meta: Meta(meta: {'doctype_value': 'org.iso.18013.5.1.mDL'}),
        claims: [
          Claim(id: 'first_name', path: ['org.iso.18013.5.1', 'first_name']),
          Claim(id: 'doc_number', path: ['org.iso.18013.5.1', 'document_number']),
        ],
        claimSets: [
          ['first_name', 'doc_number']
        ],
      ),
      Credential(
        id: 'credential-2',
        format: Formats.sd_jwt,
        meta: Meta(meta: {'vcts_values': ['urn:eu.europa.ec.eudi.pid.1']}),
        claims: [
          Claim(path: ['document_number']),
        ],
      ),
    ],
    credentialSets: [
      CredentialSet(
        options: [
          ['credential-1'],
          ['credential-2'],
        ],
      ),
    ],
  );

  // Validate the query structure
  final validation = DcqlValidator().validate(query);
  if (validation.isValid) {
    print(jsonEncode(query.toJson()));
  } else {
    print('Invalid query: ${validation.errors}');
  }
}
```

## Features

### Fluent Builder

The `DcqlBuilder` allows you to chain methods to define credentials, claims, and sets naturally.

### Validation
The library includes a robust validator `DcqlValidator` that checks for:

* **Uniqueness**: Ensures all credential and claim IDs are unique within their scope.
* **Referential Integrity**: Verifies that all IDs referenced in `claim_sets` and `credential_sets` actually exist.
* **Structure**: Checks for non-empty paths, correct value types, and required fields.
* **Format Compliance**: Validates format-specific requirements (e.g., `doctype_value` for mdoc).

You can validate a query object or a JSON string:

```dart
final validator = DcqlValidator();

// Validate a DcqlQuery object
final result = validator.validate(query);

// Validate a JSON string
final resultJson = validator.validateJson(jsonString);

if (result.isInvalid) {
  print('Validation failed:');
  for (final error in result.errors!) {
    print('- $error');
  }
}
```

> **Note**: The `DcqlBuilder.build()` method automatically runs validation and throws a `ValidationException` if the query is invalid. To skip this check, use `.build(skipValidation: true)`.

### Supported Formats

* `mso_mdoc` (Mobile Driving License, etc.)
* `dc+sd-jwt` (SD-JWT VC)

## Contributing

Open an issue for discussion, then PR with tests.

## License

MIT
