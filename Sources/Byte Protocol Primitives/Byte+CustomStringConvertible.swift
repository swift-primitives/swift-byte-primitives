// Byte+CustomStringConvertible.swift
//
// `CustomStringConvertible` conformance, rendering through `UInt8`'s
// integer description (decimal: `255`, not hex). Mirrors stdlib
// `UInt8.description`. Hex / base-N rendering is the encoder packages'
// responsibility (`swift-binary-base-primitives`,
// `swift-ietf/swift-rfc-4648`), per the L1 String-conversion friction
// guidance in `Byte.swift`'s design notes.

public import Byte_Primitive

extension Byte: CustomStringConvertible {
    /// Decimal representation (`0`–`255`).
    @inlinable
    public var description: String {
        underlying.description
    }
}
