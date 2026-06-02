// String+Byte.swift
//
// UTF-8 decoding bridge from byte-domain sequences (any `Byte.`Protocol``
// conformer — `Byte`, `ASCII.Code`, `Tagged<_, Byte>`, future newtypes) to
// `Swift.String`. Mirrors stdlib's `String.init(decoding:as:)` shape, lifted
// to the byte-domain protocol marker.
//
// Foundation-free per `[PRIM-FOUND-001]` — this is a pure stdlib-bridge
// addition, NOT a Foundation `String.Encoding` bridge.

public import Byte_Primitives

extension String {
    /// Creates a string by decoding the given byte-domain sequence as UTF-8.
    ///
    /// Mirrors `String.init(decoding:as:)` for stdlib types, lifted to any
    /// `Byte.`Protocol`` conformer (`Byte`, `ASCII.Code`, `Tagged<_, Byte>`,
    /// future newtypes). Invalid byte sequences are replaced with U+FFFD per
    /// stdlib semantics. Useful for diagnostic output and tests where a
    /// byte stream is interpreted as a UTF-8 string.
    ///
    /// ```swift
    /// let bytes: [Byte] = [0x48, 0x69]
    /// let s = String(decoding: bytes, as: UTF8.self)        // "Hi"
    ///
    /// let codes: [ASCII.Code] = [0x48, 0x69]
    /// let s2 = String(decoding: codes, as: UTF8.self)       // "Hi"
    /// ```
    @inlinable
    public init<S: Swift.Sequence>(decoding bytes: S, as encoding: Swift.UTF8.Type)
    where S.Element: Byte.`Protocol` {
        self.init(decoding: bytes.lazy.map { $0.byte.underlying }, as: encoding)
    }

    /// Creates a string by validating the given byte-domain collection as UTF-8.
    ///
    /// Mirrors `String.init?(validating:as:)` for stdlib types, lifted to any
    /// `Byte.\`Protocol\`` conformer. Returns `nil` if the bytes do not form a
    /// well-formed UTF-8 sequence.
    ///
    /// ```swift
    /// let bytes: [Byte] = [0x48, 0x69]
    /// let s = String(validating: bytes, as: UTF8.self)        // Optional("Hi")
    /// ```
    @inlinable
    public init?<C: Swift.Collection>(validating bytes: C, as encoding: Swift.UTF8.Type)
    where C.Element: Byte.`Protocol` {
        self.init(validating: bytes.lazy.map { $0.byte.underlying }, as: encoding)
    }

    /// Creates a string representation of a byte-domain value in the given radix.
    ///
    /// Mirrors `String.init(_:radix:)` for `BinaryInteger`, lifted to
    /// `Byte.`Protocol``.
    ///
    /// ```swift
    /// let byte: Byte = 0xAB
    /// let s = String(byte, radix: 16)              // "ab"
    ///
    /// let code: ASCII.Code = 0x41
    /// let s2 = String(code, radix: 16)             // "41"
    /// ```
    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X, radix: Int) {
        self.init(value.byte.underlying, radix: radix)
    }
}

extension Unicode.Scalar {
    /// Creates a Unicode scalar from a byte-domain value.
    ///
    /// Mirrors `Unicode.Scalar.init(_ v: UInt8)`, lifted to `Byte.`Protocol``.
    /// For bytes in the ASCII range (0x00...0x7F) the scalar represents the
    /// corresponding U+0000...U+007F code point; high bytes (0x80...0xFF) are
    /// valid as Latin-1 supplement code points.
    ///
    /// ```swift
    /// let code: ASCII.Code = 0x41
    /// let scalar = Unicode.Scalar(code)            // "A"
    /// ```
    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X) {
        self.init(value.byte.underlying)
    }
}

extension Character {
    /// Creates a character from a byte-domain value, decoded as a single
    /// Unicode scalar.
    ///
    /// Mirrors `Character.init(Unicode.Scalar(_ v: UInt8))`, lifted to
    /// `Byte.`Protocol``. Useful for digit / letter / punctuation
    /// construction from typed byte constants.
    ///
    /// ```swift
    /// let code: ASCII.Code = 0x30           // '0'
    /// let ch = Character(code)              // "0"
    /// ```
    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X) {
        self.init(Unicode.Scalar(value))
    }
}
