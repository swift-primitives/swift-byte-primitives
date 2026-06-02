// Array+Byte.swift
//
// Bridges between byte-domain sequences (any `Byte.`Protocol`` conformer
// — `Byte`, `ASCII.Code`, `Tagged<_, Byte>`, future newtypes) and `UInt8`
// stdlib carriers.
//
// The byte-domain ↔ UInt8-stdlib bridge lives ONCE here, generically over
// `Byte.`Protocol``, so consumer code reads naturally without per-call-site
// `.lazy.map(\.underlying)` patching. Per the byte-protocol-capability-marker
// discipline, `UInt8` itself is arithmetic-domain and does NOT conform to
// `Byte.`Protocol`` — these helpers fire exactly on the byte-domain set.
//
// **Generic over `RangeReplaceableCollection`** (not Array-specific) so the
// bridges fire uniformly on `Array`, `ContiguousArray`, `Deque`, and any
// other `RangeReplaceableCollection` conformer. The `Sequence.underlying`
// property remains a `Sequence` extension (eager `[UInt8]` result is
// `Array`-typed by definition).
//
// Motivating arc sites:
//
// - `Array<X>(uint8s)` (`X: Byte.`Protocol``) — replaces
//   `Swift.Array(uint8s.map(X.init))` at stdlib-bridge construction sites.
//   Covers `[Byte]`, `[ASCII.Code]`, etc.
// - `Array<UInt8>(bytes)` (bytes: `Sequence<X: Byte.`Protocol``) — reverse
//   direction, used at stdlib-bridge sites where a UInt8-typed API consumes
//   the byte-domain sequence. `@_disfavoredOverload` so it does NOT compete
//   with stdlib's same-type `init<S>(_:)` for Element-type inference when
//   the source already has byte-domain Element.
// - `bytes.underlying` (`Sequence<X: Byte.`Protocol``) — eager `[UInt8]`
//   accessor, lifts the per-element `byte.underlying` ergonomic to the
//   sequence level.

public import Byte_Primitives

// MARK: - Inbound bridges (build byte-domain collection from UInt8 / byte-domain source)

extension RangeReplaceableCollection where Element: Byte.`Protocol` {
    /// Creates a byte-domain collection (any `RangeReplaceableCollection`
    /// whose `Element: Byte.`Protocol`` — `[Byte]`, `ContiguousArray<ASCII.Code>`,
    /// etc.) from any sequence of `UInt8` values.
    ///
    /// Each `UInt8` element is wrapped via `Byte($0)` then `Element($0)`.
    /// Replaces `Swift.Array(uint8s.map(Element.init))` patterns.
    ///
    /// Throws `Element.Error` when a byte falls outside `Element`'s valid
    /// subset (e.g., `[ASCII.Code](bytes)` throws `ASCII.Code.Error.notASCII`
    /// for any byte ≥ 0x80). For universal-domain `Element` (e.g., `Byte`,
    /// `Error == Never`), the call site requires no `try`.
    ///
    /// `reserveCapacity` is invoked from `source.underestimatedCount` to
    /// match the allocation profile of the original `source.lazy.map`
    /// stdlib form (single sized allocation, no growth-reallocations).
    /// The `lazy.map` shape is unavailable here because `LazyMapSequence`'s
    /// transform is non-throwing; typed throws forced the explicit loop.
    /// Deferred: `Sequence.ThrowingMap` in `swift-sequence-primitives`
    /// would restore the lazy form for higher-tier consumers.
    @inlinable
    public init<S: Swift.Sequence>(_ source: S) throws(Element.Error) where S.Element == UInt8 {
        self.init()
        self.reserveCapacity(source.underestimatedCount)
        for u in source {
            self.append(try Element(Byte(u)))
        }
    }

    /// Creates a byte-domain collection from any sequence of `Y: Byte.`Protocol``
    /// values (cross-byte-domain bridge, e.g., `[ASCII.Code](bytes)` where
    /// `bytes: [Byte]`).
    ///
    /// Each element is bridged via `.byte` (returns `Byte`) then `Element(_:Byte)`.
    /// `@_disfavoredOverload` so stdlib's same-type init wins when the source
    /// already has the destination element type.
    ///
    /// Throws `Element.Error` for refined `Element` (see same-shape doc above).
    @_disfavoredOverload
    @inlinable
    public init<S: Swift.Sequence>(_ source: S) throws(Element.Error) where S.Element: Byte.`Protocol` {
        self.init()
        self.reserveCapacity(source.underestimatedCount)
        for x in source {
            self.append(try Element(x.byte))
        }
    }
}

// MARK: - Outbound bridges (build UInt8 collection from byte-domain source)

extension RangeReplaceableCollection where Element == UInt8 {
    /// Creates a `UInt8` collection from a sequence of byte-domain values.
    ///
    /// Each element is unwrapped via `.byte.underlying`. Replaces
    /// `Swift.Array(bytes.map(\.underlying))` patterns at stdlib-bridge sites.
    ///
    /// `@_disfavoredOverload` so stdlib's same-type init wins for
    /// `Array<UInt8>(uint8s)` (no Element-type inference ambiguity at call
    /// sites like `Array(byteSlice)`). Explicit-type call sites
    /// (`Array<UInt8>(bytes)`) continue to resolve via this overload.
    @_disfavoredOverload
    @inlinable
    public init<S: Swift.Sequence>(_ source: S) where S.Element: Byte.`Protocol` {
        self.init(source.lazy.map { $0.byte.underlying })
    }
}

// MARK: - Sequence-level eager underlying

extension Sequence where Element: Byte.`Protocol` {
    /// Eager `[UInt8]` of the underlying byte values.
    ///
    /// Lifts the per-element `byte.underlying` accessor to the sequence level.
    /// Use at stdlib-bridge sites where a UInt8-typed API consumes the byte
    /// sequence.
    @inlinable
    public var underlying: [UInt8] {
        self.map { $0.byte.underlying }
    }
}

// MARK: - Cross-byte-domain append bridges

extension RangeReplaceableCollection where Element: Byte.`Protocol` {
    /// Appends a byte-domain element from any other byte-domain type.
    ///
    /// Bridges through `.byte` (returns `Byte`) and `Element(_:Byte)` so a
    /// `[Byte]` accepts `ASCII.Code` values directly, a `[ASCII.Code]` accepts
    /// `Byte` values directly, etc. Stdlib's `append(_:Element)` exact-match
    /// continues to win when the input element type IS the collection's element
    /// type; this overload fires for cross-byte-domain appends.
    ///
    /// Throws `Element.Error` for refined `Element` (see Inbound bridges above).
    @_disfavoredOverload
    @inlinable
    public mutating func append<X: Byte.`Protocol`>(_ other: X) throws(Element.Error) {
        self.append(try Element(other.byte))
    }

    /// Appends the contents of a byte-domain sequence bridged through `.byte`.
    ///
    /// Pre-grows capacity to `count + source.underestimatedCount` to match
    /// stdlib's `append(contentsOf:)` allocation profile.
    @_disfavoredOverload
    @inlinable
    public mutating func append<S: Swift.Sequence>(contentsOf source: S) throws(Element.Error) where S.Element: Byte.`Protocol` {
        self.reserveCapacity(self.count + source.underestimatedCount)
        for x in source {
            self.append(try Element(x.byte))
        }
    }

    /// Appends the contents of a `UInt8` sequence (e.g., `String.UTF8View`)
    /// wrapped to the byte-domain element type.
    ///
    /// Pre-grows capacity to `count + source.underestimatedCount` to match
    /// stdlib's `append(contentsOf:)` allocation profile.
    @_disfavoredOverload
    @inlinable
    public mutating func append<S: Swift.Sequence>(contentsOf source: S) throws(Element.Error) where S.Element == UInt8 {
        self.reserveCapacity(self.count + source.underestimatedCount)
        for u in source {
            self.append(try Element(Byte(u)))
        }
    }
}
