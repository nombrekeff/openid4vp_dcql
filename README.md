# OpenID4VP DCQL

A Dart library for building and validating **Digital Credentials Query Language (DCQL)** queries as defined in the [OpenID for Verifiable Presentations (OpenID4VP) v1.0 specification](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query).

Build complex credential queries with a fluent, type-safe API, validate them against the spec, and serialize them to JSON for transmission.

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
      
      .build();

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

The library includes a robust validator that checks for:

* Unique IDs for credentials and claims.
* Valid references in `claim_sets` and `credential_sets`.
* Correct value types and non-empty paths.

### Supported Formats

* `mso_mdoc` (Mobile Driving License, etc.)
* `dc+sd-jwt` (SD-JWT VC)
* `jwt_vc_json` (W3C Verifiable Credentials)

## Contributing

Open an issue for discussion, then PR with tests.

## License

MIT
