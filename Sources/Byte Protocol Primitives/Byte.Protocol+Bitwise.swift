// Byte.Protocol+Bitwise.swift
//
// Bitwise operations on byte-domain types. Lifted to `Byte.\`Protocol\`` so
// universal-domain conformers (Byte itself, Tagged<Tag, Byte>) inherit
// the operations uniformly.
//
// Arithmetic is NOT forwarded — bytes are not numbers. Conformers that
// need arithmetic semantics should reach for the underlying UInt8
// explicitly via the byte-axis accessor (`byte.underlying`) or the
// carrier-axis accessor (`underlying` when the conformer also conforms
// to `Carrier.\`Protocol\`<UInt8>`).
//
// Gated to `where Error == Never`: refined conformers (e.g., ASCII.Code,
// whose valid range is 0x00–0x7F) MUST provide their own bitwise where
// the operation preserves their invariant. `~` for ASCII.Code is the
// canonical case — `~0x41 == 0xBE` leaves the ASCII range, so the
// default `~` would silently store an invalid byte. Refined conformers
// opt-in per operator.

public import Byte_Primitive

extension Byte.`Protocol` where Self.Error == Never {
    /// Bitwise AND of two byte-domain values.
    @inlinable
    public static func & (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying & rhs.byte.underlying))
    }

    /// Bitwise OR of two byte-domain values.
    @inlinable
    public static func | (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying | rhs.byte.underlying))
    }

    /// Bitwise XOR of two byte-domain values.
    @inlinable
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying ^ rhs.byte.underlying))
    }

    /// Bitwise complement of the byte-domain value.
    @inlinable
    public static prefix func ~ (operand: Self) -> Self {
        Self(Byte(~operand.byte.underlying))
    }

    /// Bitwise AND assignment.
    @inlinable
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }

    /// Bitwise OR assignment.
    @inlinable
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }

    /// Bitwise XOR assignment.
    @inlinable
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }

    /// Logical left shift by an unsigned amount, zero-filling on the right.
    ///
    /// Shift amounts ≥ 8 produce zero, matching `UInt8`'s masking-shift
    /// (`&<<`) semantics.
    @inlinable
    public static func << (lhs: Self, rhs: UInt8) -> Self {
        guard rhs < 8 else { return Self(Byte(0)) }
        return Self(Byte(lhs.byte.underlying &<< rhs))
    }

    /// Logical right shift by an unsigned amount, zero-filling on the left.
    ///
    /// Shift amounts ≥ 8 produce zero, matching `UInt8`'s masking-shift
    /// (`&>>`) semantics.
    @inlinable
    public static func >> (lhs: Self, rhs: UInt8) -> Self {
        guard rhs < 8 else { return Self(Byte(0)) }
        return Self(Byte(lhs.byte.underlying &>> rhs))
    }
}
