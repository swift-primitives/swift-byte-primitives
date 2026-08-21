public import Byte_Primitive

extension Byte: CustomStringConvertible {

    @inlinable
    public var description: String {
        underlying.description
    }
}
