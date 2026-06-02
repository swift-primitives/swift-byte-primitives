import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Array+Byte Test` {}
}

extension Byte.`Array+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Unit

extension Byte.`Array+Byte Test`.Unit {
    @Test
    func `Array of Byte from Sequence of UInt8 wraps each element`() {
        let uint8s: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        let bytes = [Byte](uint8s)
        #expect(bytes == [Byte(0x48), Byte(0x65), Byte(0x6C), Byte(0x6C), Byte(0x6F)])
    }

    @Test
    func `Array of UInt8 from Sequence of Byte unwraps each element`() {
        let bytes: [Byte] = [0x42, 0xFF, 0x00]
        let uint8s = [UInt8](bytes)
        #expect(uint8s == [0x42, 0xFF, 0x00])
    }

    @Test
    func `Sequence underlying returns eager UInt8 array`() {
        let bytes: [Byte] = [0x10, 0x20, 0x30]
        #expect(bytes.underlying == [0x10, 0x20, 0x30])
    }
}

// MARK: - Edge Case

extension Byte.`Array+Byte Test`.`Edge Case` {
    @Test
    func `empty source yields empty result`() {
        #expect([Byte]([] as [UInt8]) == [])
        #expect([UInt8]([] as [Byte]) == [])
        #expect(([] as [Byte]).underlying == [])
    }

    @Test
    func `single-element source`() {
        #expect([Byte]([0x42] as [UInt8]) == [Byte(0x42)])
        #expect([UInt8]([Byte(0x42)]) == [0x42])
        #expect([Byte(0x42)].underlying == [0x42])
    }

    @Test
    func `accepts non-Array Sequence input`() {
        // Range<UInt8> is a Sequence with Element == UInt8 (when bounded
        // appropriately); verify the generic init accepts arbitrary
        // sequences, not just Arrays.
        let bytes = [Byte](stride(from: UInt8(0), to: 4, by: 1))
        #expect(bytes == [Byte(0), Byte(1), Byte(2), Byte(3)])
    }
}

// MARK: - Integration

extension Byte.`Array+Byte Test`.Integration {
    @Test
    func `round-trip UInt8 -> Byte -> UInt8 preserves all bytes`() {
        let original: [UInt8] = [0x00, 0x42, 0xFF, 0x80]
        let bytes = [Byte](original)
        let restored = [UInt8](bytes)
        #expect(restored == original)
    }

    @Test
    func `underlying matches manual map for all byte sequences`() {
        let bytes: [Byte] = [0x00, 0x42, 0xFF, 0x80]
        #expect(bytes.underlying == bytes.map(\.underlying))
    }

    @Test
    func `Sequence underlying composes with Array UInt8 init`() {
        let bytes: [Byte] = [0xAB, 0xCD, 0xEF]
        #expect([UInt8](bytes) == bytes.underlying)
    }
}
