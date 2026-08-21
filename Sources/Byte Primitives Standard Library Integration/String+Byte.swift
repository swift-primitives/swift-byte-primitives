public import Byte_Primitives

extension String {

    @inlinable
    public init<S: Swift.Sequence>(decoding bytes: S, as encoding: Swift.UTF8.Type)
    where S.Element: Byte.`Protocol` {
        self.init(decoding: bytes.lazy.map { $0.byte.underlying }, as: encoding)
    }

    @inlinable
    public init?<C: Swift.Collection>(validating bytes: C, as encoding: Swift.UTF8.Type)
    where C.Element: Byte.`Protocol` {
        self.init(validating: bytes.lazy.map { $0.byte.underlying }, as: encoding)
    }

    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X, radix: Int) {
        self.init(value.byte.underlying, radix: radix)
    }

    @inlinable
    public init(_ bytes: [Byte]) {
        self.init(decoding: bytes, as: Swift.UTF8.self)
    }

    @inlinable
    public init(_ bytes: ArraySlice<Byte>) {
        self.init(decoding: bytes, as: Swift.UTF8.self)
    }
}

extension Unicode.Scalar {

    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X) {
        self.init(value.byte.underlying)
    }
}

extension Character {

    @_disfavoredOverload
    @inlinable
    public init<X: Byte.`Protocol`>(_ value: X) {
        self.init(Unicode.Scalar(value))
    }
}
