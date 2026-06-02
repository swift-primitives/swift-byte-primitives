// Byte+Carrier.swift
//
// Byte conforms to Carrier.`Protocol` with Underlying == UInt8 — the
// carrier-axis conformance, separate from the byte-domain-axis
// `Byte.\`Protocol\`` conformance in Byte.Protocol.swift.
//
// These two conformances are sibling axes:
//
//   - Carrier.`Protocol`<UInt8>: cross-type generic dispatch over any
//     UInt8-carrying value. Includes Byte, future UInt8-carrying newtypes,
//     and (via trivial-self-carrier in swift-carrier-primitives' standard-
//     library integration) UInt8 itself.
//   - Byte.`Protocol`: byte-domain ergonomics (bitwise, hex-rendering hooks,
//     parser-input shape). Conformers project to `byte: Byte`. Does NOT
//     include UInt8 — UInt8 is the arithmetic twin, not a byte-domain
//     conformer (per byte-protocol-capability-marker.md Q1).
//
// See file header of Byte.Protocol.swift for the full design rationale
// and the constraint principle that drove the sibling-not-refinement
// choice.

public import Byte_Primitive
public import Carrier_Primitives

// MARK: - Carrier.`Protocol` Conformance

extension Byte: Carrier.`Protocol` {
    /// Byte carries a `UInt8`.
    public typealias Underlying = UInt8

    // `Domain` defaults to `Never` per the Carrier protocol declaration.
    //
    // The Carrier-required `var underlying: UInt8 { borrowing get }` is
    // satisfied by Byte's stored `public let underlying: UInt8` field
    // declared in Byte.swift.
    //
    // The Carrier-required `init(_ underlying: consuming UInt8)` is
    // satisfied by Byte's existing same-shape initializer declared in
    // Byte.swift.
}
