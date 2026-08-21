public import Byte_Primitives

extension RangeReplaceableCollection where Element: Byte.`Protocol` {

    @inlinable
    public init<S: Swift.Sequence>(_ source: S) throws(Element.Error) where S.Element == UInt8 {
        self.init()
        self.reserveCapacity(source.underestimatedCount)
        for u in source {
            self.append(try Element(Byte(u)))
        }
    }

    @_disfavoredOverload
    @inlinable
    public init<S: Swift.Sequence>(_ source: S) throws(Element.Error)
    where S.Element: Byte.`Protocol` {
        self.init()
        self.reserveCapacity(source.underestimatedCount)
        for x in source {
            self.append(try Element(x.byte))
        }
    }
}

extension RangeReplaceableCollection where Element == UInt8 {

    @_disfavoredOverload
    @inlinable
    public init<S: Swift.Sequence>(_ source: S) where S.Element: Byte.`Protocol` {
        self.init(source.lazy.map { $0.byte.underlying })
    }
}

extension Sequence where Element: Byte.`Protocol` {

    @inlinable
    public var underlying: [UInt8] {
        self.map { $0.byte.underlying }
    }
}

extension RangeReplaceableCollection where Element: Byte.`Protocol` {

    @_disfavoredOverload
    @inlinable
    public mutating func append<X: Byte.`Protocol`>(_ other: X) throws(Element.Error) {
        self.append(try Element(other.byte))
    }

    @_disfavoredOverload
    @inlinable
    public mutating func append<S: Swift.Sequence>(contentsOf source: S) throws(Element.Error)
    where S.Element: Byte.`Protocol` {
        self.reserveCapacity(self.count + source.underestimatedCount)
        for x in source {
            self.append(try Element(x.byte))
        }
    }

    @_disfavoredOverload
    @inlinable
    public mutating func append<S: Swift.Sequence>(contentsOf source: S) throws(Element.Error)
    where S.Element == UInt8 {
        self.reserveCapacity(self.count + source.underestimatedCount)
        for u in source {
            self.append(try Element(Byte(u)))
        }
    }
}
