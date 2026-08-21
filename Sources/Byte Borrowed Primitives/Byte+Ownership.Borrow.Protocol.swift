public import Byte_Protocol_Primitives
public import Ownership_Primitives

extension Byte: Ownership.Borrow.`Protocol` {

    public typealias Borrowed = Swift.Span<Byte>
}
