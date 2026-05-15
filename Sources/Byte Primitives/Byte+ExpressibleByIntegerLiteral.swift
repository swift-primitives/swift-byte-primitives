// Byte+ExpressibleByIntegerLiteral.swift

extension Byte: ExpressibleByIntegerLiteral {
    /// Creates a byte from an integer literal.
    ///
    /// Traps if the literal does not fit in `UInt8` (0...255), matching
    /// `UInt8`'s literal-init semantics.
    ///
    /// ```swift
    /// let b: Byte = 0xFF        // .init(rawValue: 255)
    /// let zero: Byte = 0         // .init(rawValue: 0)
    /// ```
    @inlinable
    public init(integerLiteral value: UInt8.IntegerLiteralType) {
        self.init(rawValue: UInt8(integerLiteral: value))
    }
}
