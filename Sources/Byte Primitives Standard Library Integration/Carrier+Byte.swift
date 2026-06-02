// Carrier+Byte.swift
//
// Bridges between `Byte` and any `Carrier.Protocol` whose `Underlying` is
// `UInt8` — most notably `UInt8` itself (which conforms to `Carrier.Protocol`
// as a trivial-self-carrier via `swift-carrier-primitives`).
//
// Lifting the bridge to `Carrier.Protocol where Underlying == UInt8` means
// any UInt8-carrying type acquires the `.byte` view and the `init(_:Byte)`
// constructor uniformly — Byte's domain story does not need a separate
// per-type bridge file for each future UInt8 carrier.

public import Byte_Primitives
public import Carrier_Primitives

extension Carrier.`Protocol` where Underlying == UInt8 {
    /// The `Byte` view of this UInt8 carrier.
    ///
    /// For `UInt8` itself this returns a `Byte` wrapping the same raw value;
    /// for any other UInt8 carrier (e.g., a domain-tagged byte) it discards
    /// the domain tag and returns the bare `Byte`.
    @inlinable
    public var byte: Byte {
        Byte(underlying)
    }

    /// Constructs this UInt8 carrier from a `Byte`.
    ///
    /// Symmetric to ``byte`` for explicit-construction sites.
    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}
