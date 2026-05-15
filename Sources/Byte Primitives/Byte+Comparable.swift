// Byte+Comparable.swift

extension Byte: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
