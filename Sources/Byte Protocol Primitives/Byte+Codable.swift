#if !hasFeature(Embedded)
    public import Byte_Primitive

    extension Byte: Codable {

        @inlinable
        public init(from decoder: any Decoder) throws {
            try self.init(UInt8(from: decoder))
        }

        @inlinable
        public func encode(to encoder: any Encoder) throws {
            try underlying.encode(to: encoder)
        }
    }
#endif
