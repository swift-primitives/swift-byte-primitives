// Byte+Bit.swift
//
// Bit-decomposition view of a `Byte`: expose the eight bits of a byte as
// typed bit-domain values without leaving the institute type system. This
// is the recipient-then-provider integration `Byte` ⊗ `Bit` ([PKG-NAME-016]):
// `Byte` (recipient) gains a decomposition view conferred by `Bit` (provider).
//
// Both accessors are `@inlinable` so they fold to the same shift+mask the
// caller would have written by hand on the raw `UInt8` — the typed surface
// is a zero-cost relabelling of the underlying bit arithmetic, validated by
// the Benchmarks/ harness in this package.
//
// NOTE ON THE RETURN TYPE OF `bits`:
// The brief specified `var bits: Bit.Pattern<UInt8>` (= `Bit.Pattern(underlying)`).
// In the live swift-bit-primitives, `Bit.Pattern<Carrier>` is a CASELESS
// namespace enum — it carries no stored value and has no initializer, so it
// cannot be returned or constructed. The genuine UInt8-wrapping value type in
// that namespace is `Bit.Pattern<UInt8>.Mask` (stored `underlying: Carrier`,
// `init(_:)`, bitwise operators, `popcount`). `bits` therefore returns
// `Bit.Pattern<UInt8>.Mask`. This is the only type-correct realisation of the
// brief's intent ("a typed pattern wrapping the byte's bits"); flagged for
// principal review.

public import Byte_Primitive
public import Bit_Primitive
public import Bit_Pattern_Primitives

extension Byte {
    /// The eight bits of this byte as a typed bit pattern over `UInt8`.
    ///
    /// The returned `Bit.Pattern<UInt8>.Mask` wraps this byte's underlying
    /// `UInt8` directly, so bit-pattern queries (`popcount`, `&`, `|`, `~`,
    /// `contains`) operate on the same bits with no copy and no conversion.
    ///
    /// ```swift
    /// let b: Byte = 0b1011_0010
    /// b.bits.popcount        // 4
    /// ```
    @inlinable
    public var bits: Bit.Pattern<UInt8>.Mask {
        Bit.Pattern<UInt8>.Mask(underlying)
    }

    /// The bit at `index`, counting from the least-significant bit (index 0).
    ///
    /// Folds to the raw `(underlying >> index) & 1` test on `UInt8`.
    ///
    /// ```swift
    /// let b: Byte = 0b0000_0101
    /// b[0]   // .one
    /// b[1]   // .zero
    /// b[2]   // .one
    /// ```
    ///
    /// - Parameter index: A bit position in `0..<8`.
    @inlinable
    public subscript(_ index: Int) -> Bit {
        (underlying >> UInt8(index)) & 1 == 1 ? .one : .zero
    }
}
