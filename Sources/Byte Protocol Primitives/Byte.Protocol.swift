public import Byte_Primitive

extension Byte {

    public protocol `Protocol` {

        associatedtype Domain: ~Copyable = Never

        associatedtype Error: Swift.Error = Never

        var byte: Byte { get }

        init(_ byte: Byte) throws(Self.Error)
    }
}

extension Byte: Byte.`Protocol` {

    public typealias Domain = Never

    @inlinable
    public var byte: Byte { self }

    @inlinable
    public init(_ byte: Byte) {
        self = byte
    }
}

extension Byte: Equatable {}
extension Byte: Hashable {}
extension Byte: Comparable {}
extension Byte: ExpressibleByIntegerLiteral {}

extension Byte.`Protocol` {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.byte.underlying == rhs.byte.underlying
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(byte.underlying)
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.byte.underlying < rhs.byte.underlying
    }
}

extension Byte.`Protocol` where Self.Error == Never {

    @inlinable
    public static var zero: Self { Self(Byte(0)) }

    @inlinable
    public static var max: Self { Self(Byte(0xFF)) }

    @inlinable
    public init(integerLiteral value: UInt8.IntegerLiteralType) {
        self.init(Byte(UInt8(integerLiteral: value)))
    }
}
