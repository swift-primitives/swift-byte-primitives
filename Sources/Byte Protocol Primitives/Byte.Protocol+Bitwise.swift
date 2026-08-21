public import Byte_Primitive

extension Byte.`Protocol` where Self.Error == Never {

    @inlinable
    public static func & (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying & rhs.byte.underlying))
    }

    @inlinable
    public static func | (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying | rhs.byte.underlying))
    }

    @inlinable
    public static func ^ (lhs: Self, rhs: Self) -> Self {
        Self(Byte(lhs.byte.underlying ^ rhs.byte.underlying))
    }

    @inlinable
    public static prefix func ~ (operand: Self) -> Self {
        Self(Byte(~operand.byte.underlying))
    }

    @inlinable
    public static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }

    @inlinable
    public static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }

    @inlinable
    public static func ^= (lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }

    @inlinable
    public static func << (lhs: Self, rhs: UInt8) -> Self {
        guard rhs < 8 else { return Self(Byte(0)) }
        return Self(Byte(lhs.byte.underlying &<< rhs))
    }

    @inlinable
    public static func >> (lhs: Self, rhs: UInt8) -> Self {
        guard rhs < 8 else { return Self(Byte(0)) }
        return Self(Byte(lhs.byte.underlying &>> rhs))
    }
}
