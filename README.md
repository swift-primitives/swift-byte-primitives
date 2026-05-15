# Byte Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A typed byte primitive — `Byte`, the atomic unit of binary data, distinct from `UInt8`. `Byte` participates in byte-stream domains (file content, network payloads, hex encodings, parser inputs); `UInt8` participates in arithmetic algebras. The institute prefers type-level distinction at the boundary between these domains.

`Byte` is a `Carrier.\`Protocol\``-conforming struct with `Underlying = UInt8` and `Domain = Never`. Bitwise operations forward to the underlying byte; arithmetic is deliberately NOT forwarded — bytes are not numbers.

---

## Quick Start

```swift
import Byte_Primitives

let b: Byte = 0xFF                    // ExpressibleByIntegerLiteral
let masked = b & 0x0F                  // Byte(rawValue: 0x0F)
let toggled = b ^ 0xFF                 // Byte(rawValue: 0x00)
let inverted = ~b                      // Byte(rawValue: 0x00)
let shifted = Byte(rawValue: 0x01) << 4  // Byte(rawValue: 0x10)

// Carrier round-trip
let raw: UInt8 = b.underlying          // 255
let restored = Byte(raw)               // == b
```

### Hex (and other base) encoding

Hex rendering is NOT part of `Byte`. Use the encoder packages:

- [`swift-binary-base-primitives`](https://github.com/swift-primitives/swift-binary-base-primitives) — `Binary.Base.16` (Base16/Base32/Base32Hex/Base58/Base62/Base64/Base85)
- [`swift-rfc-4648`](https://github.com/swift-ietf/swift-rfc-4648) — `RFC_4648.Base16` (the canonical RFC 4648 Base16 encoder)

The institute's L1 String-conversion friction is intentional per [PRIM-FOUND-004] — `Byte` stays narrow; encoding belongs to encoders.

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

## License

Apache License 2.0 — see [LICENSE.md](LICENSE.md).
