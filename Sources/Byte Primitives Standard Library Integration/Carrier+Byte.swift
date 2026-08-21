public import Byte_Primitives
import Carrier_Primitives

extension Carrier.`Protocol` where Underlying == UInt8 {

    @inlinable
    public var byte: Byte {
        Byte(underlying)
    }

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}
