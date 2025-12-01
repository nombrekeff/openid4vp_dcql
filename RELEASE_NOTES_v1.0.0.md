# Release Notes - v1.0.0

## Initial Release

We are excited to announce the first release of `openid4vp_dcql`, a Dart library for building and validating **Digital Credentials Query Language (DCQL)** queries as defined in the [OpenID for Verifiable Presentations (OpenID4VP) v1.0 specification](https://openid.net/specs/openid-4-verifiable-presentations-1_0.html#name-credential-query).

### Key Features

*   **Fluent Builder API**: Construct complex nested queries with readable, chainable methods using `DcqlBuilder`.
*   **Type Safety**: Compile-time checks for known credential types (`mdoc`, `sd-jwt`) and claims.
*   **Spec Compliance**: Built-in validation ensures your queries meet the DCQL specification requirements.
*   **Zero Boilerplate**: No need to manually construct deeply nested Maps or JSON objects.
*   **JSON Serialization**: Easily convert queries to and from JSON for transmission.

### Supported Formats

*   `mso_mdoc` (Mobile Driving License, etc.)
*   `dc+sd-jwt` (SD-JWT VC)

### Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  openid4vp_dcql: ^1.0.0
```

See the [README](README.md) for usage examples.
