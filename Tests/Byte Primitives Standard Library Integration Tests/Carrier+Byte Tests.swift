import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Carrier+Byte Test` {}
}

extension Byte.`Carrier+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Unit

extension Byte.`Carrier+Byte Test`.Unit {
    @Test
    func `UInt8 carrier byte accessor returns matching Byte`() {
        let raw: UInt8 = 0x42
        #expect(raw.byte == Byte(0x42))
    }

    @Test
    func `UInt8 carrier init from Byte returns matching underlying`() {
        let b: Byte = 0xAB
        #expect(UInt8(b) == 0xAB)
    }

    @Test
    func `Byte carrier byte accessor is idempotent`() {
        let b: Byte = 0x42
        #expect(b.byte == b)
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

extension Byte.`Carrier+Byte Test`.`Edge Case` {
    @Test
    func `zero round-trips`() {
        let raw: UInt8 = 0
        #expect(raw.byte == Byte(0))
        #expect(UInt8(raw.byte) == 0)
    }

    @Test
    func `maximum round-trips`() {
        let raw: UInt8 = 0xFF
        #expect(raw.byte == Byte(0xFF))
        #expect(UInt8(raw.byte) == 0xFF)
    }
}

// MARK: - Integration

extension Byte.`Carrier+Byte Test`.Integration {
    @Test
    func `UInt8 byte composes with bitwise operations`() {
        let raw: UInt8 = 0xAB
        let result = raw.byte & 0xF0
        #expect(result == Byte(0xA0))
    }

    @Test
    func `round-trip preserves all UInt8 values`() {
        (UInt8.min...UInt8.max).forEach { i in
            #expect(UInt8(i.byte) == i)
        }
    }
}
