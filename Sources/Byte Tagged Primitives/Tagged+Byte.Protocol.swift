public import Byte_Primitive
public import Byte_Protocol_Primitives
public import Tagged_Primitives

extension Tagged: Byte.`Protocol`
where Underlying: Byte.`Protocol`, Tag: ~Copyable {

    public typealias Domain = Tag

    public typealias Error = Underlying.Error

    @inlinable
    public var byte: Byte { underlying.byte }

    @_disfavoredOverload
    @inlinable
    public init(_ byte: Byte) throws(Underlying.Error) {
        self.init(_unchecked: try Underlying(byte))
    }
}
