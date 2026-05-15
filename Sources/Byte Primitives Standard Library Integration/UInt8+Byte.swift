// UInt8+Byte.swift
// Bridging conveniences between UInt8 and Byte.

public import Byte_Primitives

extension UInt8 {
    /// The `Byte` view of this 8-bit unsigned integer.
    ///
    /// The reverse direction is `Byte.underlying` from the Carrier conformance.
    @inlinable
    public var byte: Byte {
        Byte(rawValue: self)
    }

    /// Creates a UInt8 from a byte's raw value.
    ///
    /// Symmetric to `UInt8.byte` for explicit-construction sites.
    @inlinable
    public init(_ byte: Byte) {
        self = byte.rawValue
    }
}
