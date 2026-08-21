import Byte_Primitives_Test_Support
import Testing

extension Byte {
    @Suite struct `String+Byte Test` {}
}

extension Byte.`String+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension Byte.`String+Byte Test`.Unit {
    @Test
    func `decodes ASCII byte sequence as UTF-8`() {
        let bytes: [Byte] = [0x48, 0x69]
        #expect(String(decoding: bytes, as: UTF8.self) == "Hi")
    }

    @Test
    func `decodes empty sequence to empty string`() {
        let bytes: [Byte] = []
        #expect(String(decoding: bytes, as: UTF8.self).isEmpty)
    }

    @Test
    func `decodes valid multi-byte UTF-8 sequence`() {

        let bytes: [Byte] = [0xC3, 0xA9]
        #expect(String(decoding: bytes, as: UTF8.self) == "é")
    }
}

extension Byte.`String+Byte Test`.`Edge Case` {
    @Test
    func `invalid UTF-8 produces replacement character`() {

        let bytes: [Byte] = [0x80]
        #expect(String(decoding: bytes, as: UTF8.self) == "\u{FFFD}")
    }

    @Test
    func `null byte is preserved as U+0000`() {
        let bytes: [Byte] = [0x00]
        #expect(String(decoding: bytes, as: UTF8.self) == "\u{0000}")
    }
}

extension Byte.`String+Byte Test`.Integration {
    @Test
    func `Byte decoding matches UInt8 decoding for same bytes`() {
        let uint8s: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        let bytes = [Byte](uint8s)

        let fromUInt8 = String(decoding: uint8s, as: UTF8.self)
        let fromByte = String(decoding: bytes, as: UTF8.self)

        #expect(fromByte == fromUInt8)
        #expect(fromByte == "Hello")
    }
}
