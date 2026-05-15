// Byte+Bitwise.swift
//
// Bitwise operations forwarded to the underlying UInt8. Arithmetic is NOT
// forwarded: bytes are not numbers. Use the underlying value directly when
// arithmetic semantics are required.

extension Byte {
    /// Bitwise AND of two bytes.
    @inlinable
    public static func & (lhs: Self, rhs: Self) -> Self {
        Self(rawValue: lhs.rawValue & rhs.rawValue)
    }

    /// Bitwise OR of two bytes.
    @inlinable
    public static func | (lhs: Self, rhs: Self) -> Self {
        Self(rawValue: lhs.rawValue | rhs.rawValue)
    }

    /// Bitwise XOR of two bytes.
    @inlinable
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        Self(rawValue: lhs.rawValue ^ rhs.rawValue)
    }

    /// Bitwise complement of the byte.
    @inlinable
    public static prefix func ~ (operand: Self) -> Self {
        Self(rawValue: ~operand.rawValue)
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
        guard rhs < 8 else { return Self(rawValue: 0) }
        return Self(rawValue: lhs.rawValue &<< rhs)
    }

    /// Logical right shift by an unsigned amount, zero-filling on the left.
    ///
    /// Shift amounts ≥ 8 produce zero, matching `UInt8`'s masking-shift
    /// (`&>>`) semantics.
    @inlinable
    public static func >> (lhs: Self, rhs: UInt8) -> Self {
        guard rhs < 8 else { return Self(rawValue: 0) }
        return Self(rawValue: lhs.rawValue &>> rhs)
    }
}
