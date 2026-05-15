// Byte+Equatable.swift

extension Byte: Equatable {
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
