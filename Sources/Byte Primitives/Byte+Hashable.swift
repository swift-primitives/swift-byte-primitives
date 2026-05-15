// Byte+Hashable.swift

extension Byte: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
