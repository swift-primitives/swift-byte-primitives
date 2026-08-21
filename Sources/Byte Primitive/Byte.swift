@frozen
public struct Byte {

    public let underlying: UInt8

    @inlinable
    public init(_ underlying: consuming UInt8) {
        self.underlying = underlying
    }
}

extension Byte: Sendable {}
