// Byte+Carrier.Protocol.swift
//
// Byte carries a UInt8 in the byte-domain. The Carrier conformance pins the
// `Underlying` to UInt8 so generic algorithms targeting `Carrier.Protocol`
// dispatch on Byte's underlying byte rather than on Byte itself.

public import Carrier_Primitives

extension Byte: Carrier.`Protocol` {
    public typealias Underlying = UInt8

    /// The underlying 8-bit unsigned integer this byte carries.
    @inlinable
    public var underlying: UInt8 { rawValue }

    /// Constructs a byte from its underlying 8-bit unsigned integer.
    @inlinable
    public init(_ underlying: consuming UInt8) {
        self.rawValue = underlying
    }
}
