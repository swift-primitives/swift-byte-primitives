# Byte Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A typed byte primitive — `Byte`, the atomic unit of binary data, distinct from `UInt8`. `Byte` participates in byte-stream domains (file content, network payloads, hex encodings, parser inputs); `UInt8` participates in arithmetic algebras. The institute prefers type-level distinction at the boundary between these domains.

`Byte` is a `Carrier.\`Protocol\``-conforming struct with `Underlying = UInt8` and `Domain = Never`. Bitwise operations forward to the underlying byte; arithmetic is deliberately NOT forwarded — bytes are not numbers.

---

## Quick Start

```swift
import Byte_Primitives

let b: Byte = 0xFF                    // ExpressibleByIntegerLiteral
let masked = b & 0x0F                  // Byte(0x0F)
let toggled = b ^ 0xFF                 // Byte(0x00)
let inverted = ~b                      // Byte(0x00)
let shifted = Byte(0x01) << 4          // Byte(0x10)

// Carrier round-trip
let raw: UInt8 = b.underlying          // 255
let restored = Byte(raw)               // == b
```

### Hex (and other base) encoding

Hex rendering is NOT part of `Byte`. Use a dedicated encoder package — `swift-binary-base-primitives` (`Binary.Base.16`, for Base16/Base32/Base64/Base85) or [`swift-rfc-4648`](https://github.com/swift-ietf/swift-rfc-4648) (`RFC_4648.Base16`, the canonical RFC 4648 encoder).

This narrowness is deliberate: `Byte` stays a pure binary unit, and encoding belongs to the encoder packages.

### UInt8 ↔ Byte bridges

```swift
import Byte_Primitives_Standard_Library_Integration

let raw: UInt8 = 0x42
let asByte: Byte = raw.byte            // Byte(rawValue: 0x42)
let back: UInt8 = UInt8(asByte)        // 0x42
```

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Byte Primitives", package: "swift-byte-primitives"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Three library products covering the bare type, its standard-library integration, and a Test Support target.

| Product | Target | Purpose |
|---------|--------|---------|
| `Byte Primitives` | `Sources/Byte Primitives/` | The `Byte` struct — Carrier.Protocol conformance, bitwise operations, stdlib conformances (Equatable, Hashable, Sendable, Comparable, ExpressibleByIntegerLiteral). |
| `Byte Primitives Standard Library Integration` | `Sources/Byte Primitives Standard Library Integration/` | Bridges between `Byte` and `UInt8`: `UInt8.byte` accessor and `UInt8(_:Byte)` conversion. |
| `Byte Primitives Test Support` | `Tests/Support/` | Re-exports the umbrella + Carrier Test Support fixtures for downstream test consumers. |

The package depends only on `swift-carrier-primitives`.

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26+ | ✅ |
| iOS 26+ | ✅ |
| tvOS 26+ | ✅ |
| watchOS 26+ | ✅ |
| visionOS 26+ | ✅ |
| Linux (Swift 6.3+) | ✅ |
| Windows (Swift 6.3+) | ✅ |
| Embedded Swift | ✅ |

---

## Related Packages

- [`swift-carrier-primitives`](https://github.com/swift-primitives/swift-carrier-primitives) — `Carrier.Protocol`, the phantom-typed wrapper protocol `Byte` conforms to (`Underlying = UInt8`, `Domain = Never`).
- [`swift-tagged-primitives`](https://github.com/swift-primitives/swift-tagged-primitives) — phantom-type infrastructure underlying the `Carrier` surface.
- [`swift-ownership-primitives`](https://github.com/swift-primitives/swift-ownership-primitives) — ownership and lifetime annotations used across the primitive.

---

## Community

<!-- BEGIN: discussion -->
<!-- END: discussion -->

## License

Apache License 2.0 — see [LICENSE.md](LICENSE.md).
