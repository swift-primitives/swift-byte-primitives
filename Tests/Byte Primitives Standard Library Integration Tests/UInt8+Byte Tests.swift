import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

@Suite struct `UInt8+Byte Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Unit

extension `UInt8+Byte Tests`.Unit {
    @Test
    func `UInt8 byte accessor returns matching Byte`() {
        let raw: UInt8 = 0x42
        #expect(raw.byte == Byte(rawValue: 0x42))
    }

    @Test
    func `UInt8 init from Byte returns matching raw`() {
        let b: Byte = 0xAB
        #expect(UInt8(b) == 0xAB)
    }

    @Test
    func `round-trip through UInt8 preserves value`() {
        let original: Byte = 0x5A
        let raw = UInt8(original)
        let restored = raw.byte
        #expect(original == restored)
    }
}

// MARK: - Edge Case

extension `UInt8+Byte Tests`.`Edge Case` {
    @Test
    func `zero round-trips`() {
        let raw: UInt8 = 0
        #expect(raw.byte == Byte(rawValue: 0))
        #expect(UInt8(raw.byte) == 0)
    }

    @Test
    func `maximum round-trips`() {
        let raw: UInt8 = 0xFF
        #expect(raw.byte == Byte(rawValue: 0xFF))
        #expect(UInt8(raw.byte) == 0xFF)
    }
}

// MARK: - Integration

extension `UInt8+Byte Tests`.Integration {
    @Test
    func `UInt8 byte composes with bitwise operations`() {
        let raw: UInt8 = 0xAB
        let result = raw.byte & 0xF0
        #expect(result == Byte(rawValue: 0xA0))
    }
}

// MARK: - Performance

extension `UInt8+Byte Tests`.Performance {
    @Test
    func `round-trip preserves all UInt8 values`() {
        for i: UInt8 in 0...255 {
            #expect(UInt8(i.byte) == i)
        }
    }
}
