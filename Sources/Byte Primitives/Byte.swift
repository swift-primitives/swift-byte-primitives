// Byte.swift

/// A single byte: the atomic unit of binary data.
///
/// `Byte` answers "what is one byte of data?" — distinct from `UInt8`, which
/// answers "what is one 8-bit unsigned integer?" The semantic separation matters
/// in the institute's type system: `UInt8` participates in arithmetic algebras;
/// `Byte` participates in byte-stream domains (file content, network payloads,
/// hex encodings, parser inputs).
///
/// `Byte` conforms to `Carrier.\`Protocol\`` with `Underlying = UInt8` and
/// `Domain = Never`. Construction and underlying access flow through the carrier
/// machinery; bitwise operations are forwarded to the underlying byte; arithmetic
/// is deliberately NOT forwarded (bytes are not numbers).
///
/// ```swift
/// let b: Byte = 0xFF
/// let masked = b & 0x0F          // .init(rawValue: 0x0F)
/// let raw = b.underlying          // UInt8 = 255
/// ```
///
/// ## Design
///
/// - **Backing**: `UInt8` (8-bit unsigned integer)
/// - **Bitwise**: `& | ^ ~ << >>` forwarded to the underlying byte
/// - **Arithmetic**: NOT forwarded — `+`, `-`, `*`, `/` are absent by design
/// - **Literal**: `ExpressibleByIntegerLiteral` for `0xFF`-style construction
///
/// Hex (and other base) rendering is NOT part of `Byte`. Use the encoder
/// packages — `swift-binary-base-primitives` (`Binary.Base.16`) or
/// `swift-ietf/swift-rfc-4648` (`RFC_4648.Base16`). L1 String-conversion
/// friction is intentional per `[PRIM-FOUND-004]`.
@frozen
public struct Byte {
    /// The underlying 8-bit unsigned integer.
    public let rawValue: UInt8

    /// Creates a byte from a raw unsigned 8-bit integer.
    @inlinable
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

extension Byte: Sendable {}
