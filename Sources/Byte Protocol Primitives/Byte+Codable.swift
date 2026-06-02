// Byte+Codable.swift
//
// `Codable` conformance routing through `UInt8`'s wire form (single-byte
// integer representation: `42`, not `{"underlying": 42}` or `"0x2A"`).
//
// Composes with the supervisor's W2+W3 unification disposition (2026-05-19):
// the conformance is in the same foundational set as `Equatable`, `Hashable`,
// `Comparable`, `ExpressibleByIntegerLiteral`, `Sendable`, and bitwise.
//
// Identity-discipline preserved: Codable is a serialization conformance,
// orthogonal to the byte-vs-arithmetic axis. `UInt8` is still NOT a
// `Byte.\`Protocol\`` conformer (per [byte-protocol-capability-marker.md]
// 2026-05-15), and `Byte` still has no arithmetic operators (per
// [byte-arithmetic-conformance.md] v1.0.0 RECOMMENDATION ζ 2026-05-19).
//
// `Tagged<Tag, Byte>` inherits Codable via Tagged's existing conditional
// conformance `Tagged: Codable where Underlying: Codable` (gated on
// `!hasFeature(Embedded)`).

#if !hasFeature(Embedded)
    public import Byte_Primitive

    extension Byte: Codable {
        /// Creates a byte by decoding its `UInt8` wire form.
        ///
        /// - Throws: An error if the decoder fails to read a `UInt8`.
        @inlinable
        public init(from decoder: Decoder) throws {
            try self.init(UInt8(from: decoder))
        }

        /// Encodes the byte as its underlying `UInt8` wire form.
        ///
        /// - Throws: An error if the encoder fails to write the `UInt8`.
        @inlinable
        public func encode(to encoder: Encoder) throws {
            try underlying.encode(to: encoder)
        }
    }
#endif
