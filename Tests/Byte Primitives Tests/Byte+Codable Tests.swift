import Testing

@testable import Byte_Primitives

extension Byte {
    @Suite struct `Codable Test` {

        @Test
        func `Byte encodes as a single UInt8 value (bare wire form, not keyed)`() throws {
            let probe = SingleValueEncoderProbe()
            try Byte(0x2A).encode(to: probe)
            #expect(probe.recorded.value == 0x2A)
        }
    }
}

extension Byte {
    @Suite struct `CustomStringConvertible Test` {

        @Test
        func `Decimal description matches UInt8`() {
            #expect(Byte(0).description == "0")
            #expect(Byte(127).description == "127")
            #expect(Byte(255).description == "255")
        }
    }
}

private struct SingleValueEncoderProbe: Encoder, SingleValueEncodingContainer {
    let recorded = Recorded()
}

extension SingleValueEncoderProbe {
    final class Recorded { var value: UInt8? }

    var codingPath: [any CodingKey] { [] }
    var userInfo: [CodingUserInfoKey: Any] { [:] }

    func singleValueContainer() -> any SingleValueEncodingContainer { self }
    func unkeyedContainer() -> any UnkeyedEncodingContainer { wrongShape() }
    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        wrongShape()
    }

    func encode(_ value: UInt8) throws { recorded.value = value }

    func encodeNil() throws { wrongShape() }
    func encode(_ value: Bool) throws { wrongShape() }
    func encode(_ value: String) throws { wrongShape() }
    func encode(_ value: Double) throws { wrongShape() }
    func encode(_ value: Float) throws { wrongShape() }
    func encode(_ value: Int) throws { wrongShape() }
    func encode(_ value: Int8) throws { wrongShape() }
    func encode(_ value: Int16) throws { wrongShape() }
    func encode(_ value: Int32) throws { wrongShape() }
    func encode(_ value: Int64) throws { wrongShape() }
    func encode(_ value: UInt) throws { wrongShape() }
    func encode(_ value: UInt16) throws { wrongShape() }
    func encode(_ value: UInt32) throws { wrongShape() }
    func encode(_ value: UInt64) throws { wrongShape() }
    func encode(_ value: some Encodable) throws { wrongShape() }

    private func wrongShape() -> Never {
        fatalError("Byte must encode as a single UInt8 value (bare wire form)")
    }
}
