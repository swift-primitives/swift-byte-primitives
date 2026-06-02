// Numeric+Byte.swift
//
// Direct numeric → ASCII-decimal-digit serialization into byte-domain
// `RangeReplaceableCollection`s, without going through a `String`
// intermediate.
//
// Replaces patterns like:
//
//   buffer.append(contentsOf: String(value).utf8)
//   self.bytes = Swift.Array(String(value).utf8)
//
// with:
//
//   buffer.append(contentsOf: value)
//
// at call sites where `value: some BinaryInteger`. Foundation-free per
// `[PRIM-FOUND-001]`; no `String` allocation for the integer-to-digits
// conversion. Sign and digits are emitted into a single UInt8 buffer;
// one boundary call to the existing BSLI's
// `append(contentsOf:) where S.Element == UInt8` flushes through to the
// destination's typed Byte-domain element.
//
// Motivating sites: rfc-2183 `RFC_2183.Size.swift` lines 62 + 131,
// serializer-primitives + byte-serializer-primitives literal-serializer
// patterns. After this addition, the standard form at consumer sites is
// `buffer.append(contentsOf: value)` for `value: some BinaryInteger`.

public import Byte_Primitives

// MARK: - BinaryInteger → ASCII decimal digits

extension RangeReplaceableCollection where Element: Byte.`Protocol` {
    /// Appends the ASCII decimal-digit representation of a `BinaryInteger`
    /// value, with no `String` intermediate.
    ///
    /// Negative values are prefixed with `'-'` (0x2D). The value `0` produces
    /// the single digit `'0'` (0x30).
    ///
    /// ```swift
    /// var buffer: [Byte] = []
    /// buffer.append(contentsOf: 42)               // [0x34, 0x32]      "42"
    /// buffer.append(contentsOf: 1024)             // [0x31, 0x30, 0x32, 0x34]
    ///
    /// var codes: [ASCII.Code] = []
    /// codes.append(contentsOf: -7)                // [0x2D, 0x37]      "-7"
    /// ```
    ///
    /// - Parameter value: The integer value to serialize as ASCII digits.
    /// - Throws: `Element.Error` propagated from the underlying byte-domain
    ///   element initializer. The produced byte sequence is always ASCII
    ///   (decimal digits `0x30–0x39` and `'-' 0x2D`), so for the standard
    ///   refined element `ASCII.Code` this never actually throws — but the
    ///   type system requires the `try` at call sites with refined `Element`
    ///   to surface the typed-throws contract uniformly. Universal-domain
    ///   `Element` (e.g., `Byte`, `Error == Never`) needs no `try`.
    @_disfavoredOverload
    @inlinable
    public mutating func append<I: BinaryInteger>(contentsOf value: I) throws(Element.Error) {
        var digits: [UInt8] = []
        digits.reserveCapacity(21)
        if value == .zero {
            digits.append(0x30)
        } else {
            if I.isSigned, value < .zero {
                digits.append(0x2D)
            }
            let digitStart = digits.count
            var magnitude = value.magnitude
            while magnitude > 0 {
                digits.append(0x30 &+ UInt8(magnitude % 10))
                magnitude /= 10
            }
            digits[digitStart...].reverse()
        }
        try self.append(contentsOf: digits)
    }
}
