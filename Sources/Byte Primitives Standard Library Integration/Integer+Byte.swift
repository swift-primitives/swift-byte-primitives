public import Byte_Primitives

extension UInt {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt16 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt32 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension UInt64 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int8 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int16 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int32 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int64 {

    @inlinable
    public init(_ byte: Byte) {
        self.init(byte.underlying)
    }
}

extension Int8 {

    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: byte.underlying)
    }
}

extension Int16 {

    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt16(byte))
    }
}

extension Int32 {

    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt32(byte))
    }
}

extension Int64 {

    @inlinable
    public init(bitPattern byte: Byte) {
        self.init(bitPattern: UInt64(byte))
    }
}

extension Byte {

    @inlinable
    public init?(exactly source: some BinaryInteger) {
        guard let uint8 = UInt8(exactly: source) else { return nil }
        self.init(uint8)
    }
}
