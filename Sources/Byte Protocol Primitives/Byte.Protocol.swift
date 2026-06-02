// Byte.Protocol.swift
//
// Byte.Protocol is a SIBLING protocol to Carrier.`Protocol` — not a
// refinement. The sibling shape is what makes recursive Tagged
// conformance work:
//
//   extension Tagged: Byte.`Protocol`
//   where Underlying: Byte.`Protocol`, Tag: ~Copyable { ... }
//
// Per Tagged's universal Carrier.`Protocol` conformance, Tagged<Tag, X>.Underlying
// is the immediate generic parameter X (not the bottom-most type). So for
// Tagged<Tag, Byte>, the Carrier-axis Underlying is Byte — NOT UInt8. A
// refinement form (`: Carrier.`Protocol` where Underlying == UInt8`) would
// force every Byte.`Protocol` conformer's Carrier.Underlying to equal UInt8,
// which Tagged<Tag, Byte> cannot satisfy. The sibling protocol decouples
// the byte-domain accessor (`byte: Byte`) from the carrier-storage accessor
// (`underlying: UInt8` on Byte itself), letting any T: Byte.`Protocol`
// answer "what byte do you carry?" without forcing
// T.Carrier.Underlying == UInt8.
//
// Pattern parallels swift-ordinal-primitives' `Ordinal.\`Protocol\`` (sibling
// to Carrier with `ordinal: Ordinal` accessor) and the analysis in
// swift-institute/Research/byte-protocol-capability-marker.md. Earlier
// revisions of this file used the refinement form — that shape is
// incompatible with recursive Tagged conformance per the constraint
// principle above.
//
// Conformers:
//   - `Byte` itself (trivial-self: `byte == self`).
//   - `Tagged<Tag, T: Byte.\`Protocol\`>` via recursive extension
//     (Tagged+Byte.Protocol.swift) — delegates `byte: Byte { underlying.byte }`.
//   - Future byte-domain newtypes (ASCII.Code, Latin1.Byte, UTF8.Code_Unit,
//     RFC-specific byte types) conform by providing `byte: Byte` and
//     `init(_: Byte)`.
//
// UInt8 itself does NOT conform: UInt8 is the arithmetic-algebras type;
// Byte is its byte-domain twin. The protocol exists precisely to be the
// "subset of byte-shaped values that opt in to byte-domain semantics" —
// UInt8 is excluded so the lifted bitwise/parser ops don't shadow stdlib's
// existing UInt8 operators. See:
// swift-institute/Research/byte-protocol-capability-marker.md Q1.

public import Byte_Primitive

extension Byte {
    /// A type that represents a byte in the byte-domain.
    ///
    /// Sibling protocol to `Carrier.\`Protocol\`` (not a refinement) — the
    /// sibling shape admits recursive `Tagged` conformance via the
    /// `Underlying: Byte.\`Protocol\`` constraint. See file header for
    /// design rationale.
    ///
    /// Conformers project to and inject from `Byte`, and inherit:
    ///
    /// - `static var zero / max: Self` (default impls below)
    /// - `==`, `hash(into:)`, `<` (default impls below)
    /// - `init(integerLiteral:)` (default impl below)
    /// - Bitwise operations `& | ^ ~ << >>` (from `Byte.Protocol+Bitwise.swift`)
    ///
    /// ## Conformers
    ///
    /// - `Byte` — the canonical byte value type.
    /// - `Tagged<Tag, T: Byte.\`Protocol\`>` — phantom-typed byte wrapper,
    ///   `Domain = Tag`.
    ///
    /// Future byte-domain types (e.g., `ASCII.Code`, `Latin1.Byte`,
    /// `UTF8.Code_Unit`) conform here to inherit byte-domain operations
    /// without re-implementing per-type.
    ///
    /// ## Relationship to Carrier.\`Protocol\`
    ///
    /// `Byte.\`Protocol\`` is a SIBLING to `Carrier.\`Protocol\``. Conforming
    /// types provide both conformances independently. Consumers needing
    /// byte-domain ergonomics constrain on `some Byte.\`Protocol\``;
    /// consumers needing cross-type generic dispatch over the raw UInt8
    /// (Form-D algorithms, `func describe<C: Carrier.\`Protocol\`<UInt8>>(_:)`)
    /// constrain on `some Carrier.\`Protocol\`<UInt8>`.
    ///
    /// ## Distinct from Carrier.\`Protocol\`<UInt8>
    ///
    /// `UInt8` conforms to `Carrier.\`Protocol\`<UInt8>` as a trivial-self-
    /// carrier (via `swift-carrier-primitives`' standard-library integration)
    /// but does NOT conform to `Byte.\`Protocol\``. UInt8 is the arithmetic
    /// twin; Byte is the byte-domain twin. Operations defined on
    /// `Byte.\`Protocol\`` therefore do NOT conflict with stdlib's UInt8
    /// operators.
    public protocol `Protocol` {
        /// The domain that scopes this byte-domain value.
        ///
        /// For bare `Byte`, `Domain` is `Never` (unscoped).
        /// For `Tagged<Tag, T: Byte.\`Protocol\`>`, `Domain` is `Tag`,
        /// enabling cross-type operators to enforce same-tag safety
        /// via `where A.Domain == B.Domain`.
        associatedtype Domain: ~Copyable = Never

        /// The error thrown by `init(_:)` for conformers whose byte-domain
        /// is a strict subset of all possible `Byte` values.
        ///
        /// Defaults to `Never` for conformers that accept every `Byte`
        /// (e.g., `Byte` itself, `Tagged<Tag, Byte>`). Refined conformers
        /// (e.g., `ASCII.Code`, whose valid range is 0x00–0x7F) declare
        /// a concrete error type. When `Error == Never`, the init is
        /// effectively non-throwing — Swift treats `throws(Never)` as
        /// non-throwing at call sites, so `Byte(...)` requires no `try`.
        associatedtype Error: Swift.Error = Never

        /// The underlying byte value.
        ///
        /// Bare `Byte` returns `self`; wrappers delegate to their
        /// contained byte (`underlying.byte`). The `byte.underlying: UInt8`
        /// path on the returned `Byte` provides the raw integer.
        var byte: Byte { get }

        /// Creates an instance from a byte value.
        ///
        /// Conformers whose byte-domain accepts every `Byte` use the
        /// default `Error == Never`; the init is then non-throwing at
        /// call sites. Refined conformers declare `Error` and throw when
        /// `byte` falls outside the valid subset.
        init(_ byte: Byte) throws(Self.Error)
    }
}

// MARK: - Byte Conformance
//
// Byte.`Protocol` has no parent protocols (mirroring Ordinal.`Protocol`'s
// shape — see file header). Stdlib conformances are declared directly on
// each conforming type so Tagged's recursive conformance does NOT have to
// re-declare the parent set (which would conflict with Tagged's existing
// conditional conformances in Tagged.swift and Tagged+Literals.swift,
// whose where-clauses differ from `Underlying: Byte.\`Protocol\``).
//
// Default-impl witnesses for Equatable.==, Hashable.hash(into:),
// Comparable.<, and ExpressibleByIntegerLiteral.init(integerLiteral:) live
// on the Byte.`Protocol` extension below. Direct conformers (Byte, future
// ASCII.Code, etc.) declare the stdlib conformances; the default impls
// satisfy the witness requirements. Tagged<Tag, T: Byte.`Protocol`> picks
// up its own stdlib conformances through Tagged's universal conditional
// conformances (Underlying: Equatable → Tagged: Equatable, etc.) and
// through Tagged+Literals.swift's SLI conformance.

extension Byte: Byte.`Protocol` {
    /// Bare bytes are unscoped.
    public typealias Domain = Never

    /// Returns self.
    @inlinable
    public var byte: Byte { self }

    /// Creates a byte from a byte (identity).
    @inlinable
    public init(_ byte: Byte) {
        self = byte
    }
}

// MARK: - Byte Stdlib Conformances
//
// Byte directly conforms to the stdlib protocols whose witnesses are
// provided by the Byte.`Protocol` default-impl extension below. Tagged
// inherits Equatable/Hashable/Comparable/Sendable via its own existing
// conditional conformances when Underlying conforms. The
// ExpressibleByIntegerLiteral conformance for Tagged<Tag, T: Byte.`Protocol`>
// rides on Tagged+Literals.swift (SLI target) — same pattern as Ordinal.

extension Byte: Equatable {}
extension Byte: Hashable {}
extension Byte: Comparable {}
extension Byte: ExpressibleByIntegerLiteral {}

// MARK: - Default Implementations

extension Byte.`Protocol` {
    /// Equality by underlying byte value.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.byte.underlying == rhs.byte.underlying
    }

    /// Hashing by underlying byte value.
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(byte.underlying)
    }

    /// Ordering by underlying byte value.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.byte.underlying < rhs.byte.underlying
    }
}

// MARK: - Default Implementations (universal-domain conformers only)
//
// The following defaults assume every `Byte` produces a valid `Self`
// (i.e., `Error == Never`). For refined conformers — where some bytes
// are outside the valid subset — these would silently store invalid
// values (`Self(Byte(0xFF))` lifts to .max for ASCII.Code despite
// 0xFF being non-ASCII), so they are gated to `Error == Never`.
// Refined conformers (e.g., `ASCII.Code`) provide their own.

extension Byte.`Protocol` where Self.Error == Never {
    /// The byte with all bits cleared (`0x00`).
    @inlinable
    public static var zero: Self { Self(Byte(0)) }

    /// The byte with all bits set (`0xFF`).
    ///
    /// Only defined for universal-domain conformers. Refined conformers
    /// (e.g., `ASCII.Code` whose max is `0x7F`, not `0xFF`) must provide
    /// their own to avoid silently storing an out-of-range value.
    @inlinable
    public static var max: Self { Self(Byte(0xFF)) }

    /// Creates a byte-domain value from an integer literal.
    ///
    /// Traps if the literal does not fit in `UInt8` (0...255), matching
    /// `UInt8`'s literal-init semantics. Only defined for universal-domain
    /// conformers — refined conformers must provide their own to add
    /// range validation (or remove the conformance).
    @inlinable
    public init(integerLiteral value: UInt8.IntegerLiteralType) {
        self.init(Byte(UInt8(integerLiteral: value)))
    }
}
