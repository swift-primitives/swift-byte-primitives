// Tagged+Byte.Protocol.swift
//
// Recursive conformance: any `Tagged<Tag, T>` where `T: Byte.\`Protocol\``
// is itself a `Byte.\`Protocol\``. The phantom `Tag` becomes the
// `Byte.\`Protocol\``'s `Domain` discriminator, mirroring the
// `Ordinal.\`Protocol\``-side `extension Tagged: Ordinal.\`Protocol\``
// precedent in swift-ordinal-primitives.
//
// Why recursive rather than flat (`where Underlying == UInt8`): the
// recursive form lets phantom-tagged byte-domain values be written as
// `Tagged<Tag, Byte>` (wrap the institute byte type), mirroring how
// phantom-tagged cardinals are written `Tagged<Tag, Cardinal>` (wrap the
// institute cardinal type), not `Tagged<Tag, UInt>` (wrap the stdlib
// raw integer). Symmetric across Group A capability markers.
//
// Why this works structurally: Byte.\`Protocol\` is a SIBLING protocol to
// Carrier.\`Protocol\` (see Byte.Protocol.swift file header). Its byte-domain
// accessor `byte: Byte` is independent of Carrier's `Underlying`
// associatedtype, so Tagged<Tag, Byte>'s Carrier.Underlying == Byte
// (per the universal Tagged: Carrier.\`Protocol\` conformance) does not
// collide with Byte.\`Protocol\``'s requirements.

public import Byte_Primitive
public import Byte_Protocol_Primitives
public import Tagged_Primitives

// MARK: - Tagged Conformance

extension Tagged: Byte.`Protocol`
where Underlying: Byte.`Protocol`, Tag: ~Copyable {
    /// The phantom `Tag` IS the byte-domain's `Domain`.
    public typealias Domain = Tag

    /// Propagates the underlying conformer's `Error`.
    ///
    /// When `Underlying` is a universal-domain conformer (e.g., `Byte`,
    /// `Error == Never`), `Tagged<Tag, Underlying>.init(_ byte: Byte)` is
    /// effectively non-throwing at call sites.
    public typealias Error = Underlying.Error

    /// The underlying byte value, delegated through the wrapped conformer.
    @inlinable
    public var byte: Byte { underlying.byte }

    /// Creates a tagged byte-domain value from a byte.
    ///
    /// `@_disfavoredOverload` to defer to `Tagged: Carrier.\`Protocol\``'s
    /// `init(_ underlying: Underlying)` when both apply (same effective
    /// signature when `Underlying == Byte`). Pattern mirrors
    /// `Ordinal.\`Protocol\``'s Tagged conformance.
    ///
    /// Throws `Underlying.Error` propagated from the wrapped conformer's
    /// `init(_:)`.
    @_disfavoredOverload
    @inlinable
    public init(_ byte: Byte) throws(Underlying.Error) {
        self.init(_unchecked: try Underlying(byte))
    }
}
