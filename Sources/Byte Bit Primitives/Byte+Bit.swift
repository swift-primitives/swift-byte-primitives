public import Bit_Pattern_Primitives
public import Bit_Primitive
public import Byte_Primitive

extension Byte {

    @inlinable
    public var bits: Bit.Pattern<UInt8>.Mask {
        Bit.Pattern<UInt8>.Mask(underlying)
    }

    @inlinable
    public subscript(_ index: Int) -> Bit {
        (underlying >> UInt8(index)) & 1 == 1 ? .one : .zero
    }
}
