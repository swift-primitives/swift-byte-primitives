import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Numeric+Byte Test` {}
}

extension Byte.`Numeric+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

// MARK: - Unit — append(contentsOf: BinaryInteger)

extension Byte.`Numeric+Byte Test`.Unit {
    @Test
    func `append small positive integer produces ASCII decimal digits`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: 42)
        #expect(buffer == [0x34, 0x32])  // "42"
    }

    @Test
    func `append large positive integer produces ASCII decimal digits`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: 1024)
        #expect(buffer == [0x31, 0x30, 0x32, 0x34])  // "1024"
    }

    @Test
    func `append zero produces single zero digit`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: 0)
        #expect(buffer == [0x30])  // "0"
    }

    @Test
    func `append negative integer prefixes with minus sign`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: -7)
        #expect(buffer == [0x2D, 0x37])  // "-7"
    }

    @Test
    func `append negative multi-digit integer`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: -123)
        #expect(buffer == [0x2D, 0x31, 0x32, 0x33])  // "-123"
    }

    @Test
    func `append unsigned integer never produces minus sign`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: UInt32(255))
        #expect(buffer == [0x32, 0x35, 0x35])  // "255"
    }

    @Test
    func `append into existing buffer preserves prefix`() {
        var buffer: [Byte] = [0x48, 0x69, 0x3D]  // "Hi="
        buffer.append(contentsOf: 42)
        #expect(buffer == [0x48, 0x69, 0x3D, 0x34, 0x32])
    }
}

// MARK: - Edge Case

extension Byte.`Numeric+Byte Test`.`Edge Case` {
    @Test
    func `append UInt64 max produces 20 digits`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: UInt64.max)
        // 18446744073709551615
        #expect(
            buffer == [
                0x31, 0x38, 0x34, 0x34, 0x36, 0x37, 0x34, 0x34, 0x30, 0x37,
                0x33, 0x37, 0x30, 0x39, 0x35, 0x35, 0x31, 0x36, 0x31, 0x35,
            ]
        )
    }

    @Test
    func `append Int min produces negative magnitude`() {
        var buffer: [Byte] = []
        buffer.append(contentsOf: Int64.min)
        // -9223372036854775808
        #expect(
            buffer == [
                0x2D, 0x39, 0x32, 0x32, 0x33, 0x33, 0x37, 0x32, 0x30, 0x33,
                0x36, 0x38, 0x35, 0x34, 0x37, 0x37, 0x35, 0x38, 0x30, 0x38,
            ]
        )
    }
}
