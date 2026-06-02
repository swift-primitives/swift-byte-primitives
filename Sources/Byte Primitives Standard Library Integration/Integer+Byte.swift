// Integer+Byte.swift
//
// Bridges between `Byte` and standard-library integer types. Three groups:
//
// 1. Widening (unlabelled): `UInt16/UInt32/UInt64/Int8/Int16/Int32/Int64`
//    from `Byte`. Replaces `UInt16(byte.underlying)` chains in
//    endianness/LEB128 decoding paths. The `Int8` form traps on overflow
//    (same semantic as stdlib's `Int8.init(_ source: UInt8)`).
//
// 2. `bitPattern` (stdlib-pattern label): `Int8/Int16/Int32/Int64` from
//    `Byte`. Mirrors stdlib's `Int8.init(bitPattern: UInt8)`. For `Int16+`
//    the byte zero-extends through `UInt16/32/64` first.
//
// 3. Fallible `Byte` init: `Byte.init?(exactly: some BinaryInteger)`.
//    Stdlib-pattern fallible init at the byte-domain layer.
//
// Motivating arc sites (binary-parser-primitives Binary.Machine.Run):
// `let b0 = UInt16(try! input.advance())` in u16le/u16be/u32le/u32be/u64le/u64be
// decoders; `Int8(bitPattern: try! input.advance())` in i8 decoder; LEB128
// arithmetic uses `byte.underlying` only at integer-up-conversion sites.

public import Byte_Primitives

// MARK: - Widening conversions (unlabelled)

extension UInt {
    /// Widens a `Byte` to platform-width `UInt` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int {
    /// Widens a `Byte` to platform-width `Int` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt16 {
    /// Widens a `Byte` to `UInt16` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt32 {
    /// Widens a `Byte` to `UInt32` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt64 {
    /// Widens a `Byte` to `UInt64` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int8 {
    /// Converts a `Byte` to `Int8`, trapping on values greater than `127`.
    ///
    /// Mirrors `Int8.init(_ source: UInt8)` from the standard library. For
    /// bit-pattern reinterpretation that treats the high bit as sign, use
    /// ``init(bitPattern:)-(Byte)``.
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int16 {
    /// Widens a `Byte` to `Int16` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int32 {
    /// Widens a `Byte` to `Int32` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int64 {
    /// Widens a `Byte` to `Int64` (zero-extending).
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

// MARK: - bitPattern conversions (stdlib-pattern label)

extension Int8 {
    /// Reinterprets the byte's bit pattern as `Int8`.
    ///
    /// Mirrors `Int8.init(bitPattern: UInt8)` — bytes with the high bit set
    /// become negative (e.g., `0xFF` → `-1`).
    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: byte.underlying)
    }
}

extension Int16 {
    /// Reinterprets the byte's bit pattern as `Int16` after zero-extending.
    ///
    /// Provided for stdlib-pattern symmetry with `Int16.init(bitPattern: UInt16)`.
    /// For unsigned source `Byte` the result equals ``init(_:)-(Byte)``.
    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt16(byte))
    }
}

extension Int32 {
    /// Reinterprets the byte's bit pattern as `Int32` after zero-extending.
    ///
    /// Provided for stdlib-pattern symmetry with `Int32.init(bitPattern: UInt32)`.
    /// For unsigned source `Byte` the result equals ``init(_:)-(Byte)``.
    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt32(byte))
    }
}

extension Int64 {
    /// Reinterprets the byte's bit pattern as `Int64` after zero-extending.
    ///
    /// Provided for stdlib-pattern symmetry with `Int64.init(bitPattern: UInt64)`.
    /// For unsigned source `Byte` the result equals ``init(_:)-(Byte)``.
    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt64(byte))
    }
}

// MARK: - Fallible byte init from BinaryInteger

extension Byte {
    /// Creates a byte from an exact `BinaryInteger` value if it fits in `UInt8`.
    ///
    /// Returns `nil` if the value is negative or greater than `255`. Mirrors
    /// stdlib's `UInt8.init?(exactly:)` at the byte-domain layer.
    ///
    /// ```swift
    /// Byte(exactly: 42)    // Byte(0x2A)
    /// Byte(exactly: 256)   // nil
    /// Byte(exactly: -1)    // nil
    /// ```
    @inlinable
    public init?(exactly source: some BinaryInteger) {
        guard let uint8 = UInt8(exactly: source) else { return nil }
        self.init(uint8)
    }
}
