import Bit_Pattern_Primitives
import Bit_Primitive
import Byte_Bit_Primitives
import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Bit Test` {}
}

extension Byte.`Bit Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Unit: subscript

extension Byte.`Bit Test`.Unit {
    @Test
    func `subscript reads least-significant bit first`() {
        let byte: Byte = 0b0000_0101
        #expect(byte[0] == .one)
        #expect(byte[1] == .zero)
        #expect(byte[2] == .one)
        #expect(byte[3] == .zero)
    }

    @Test
    func `subscript reads most-significant bit`() {
        let byte: Byte = 0b1000_0000
        #expect(byte[7] == .one)
        #expect(byte[6] == .zero)
        #expect(byte[0] == .zero)
    }

    @Test
    func `subscript over all-zero byte yields zero everywhere`() {
        let byte: Byte = 0x00
        for index in 0..<8 {
            #expect(byte[index] == .zero)
        }
    }

    @Test
    func `subscript over all-ones byte yields one everywhere`() {
        let byte: Byte = 0xFF
        for index in 0..<8 {
            #expect(byte[index] == .one)
        }
    }

    @Test
    func `subscript matches raw shift-and-mask for every byte and position`() {
        for value in UInt8.min...UInt8.max {
            let byte = Byte(value)
            for index in 0..<8 {
                let expected: Bit = (value >> UInt8(index)) & 1 == 1 ? .one : .zero
                #expect(byte[index] == expected)
            }
        }
    }
}

// MARK: - Unit: bits

extension Byte.`Bit Test`.Unit {
    @Test
    func `bits wraps the underlying byte`() {
        let byte: Byte = 0b1011_0010
        #expect(byte.bits.underlying == 0b1011_0010)
    }

    @Test
    func `bits popcount counts set bits`() {
        #expect((Byte(0b1011_0010).bits.popcount) == 4)
        #expect((Byte(0x00).bits.popcount) == 0)
        #expect((Byte(0xFF).bits.popcount) == 8)
    }

    @Test
    func `bits popcount matches nonzeroBitCount for every byte`() {
        for value in UInt8.min...UInt8.max {
            #expect(Byte(value).bits.popcount == value.nonzeroBitCount)
        }
    }
}

// MARK: - Integration

extension Byte.`Bit Test`.Integration {
    @Test
    func `subscript reconstructs the byte by folding the eight bits`() {
        for value in UInt8.min...UInt8.max {
            let byte = Byte(value)
            var reconstructed: UInt8 = 0
            for index in 0..<8 where byte[index] == .one {
                reconstructed |= UInt8(1) << UInt8(index)
            }
            #expect(reconstructed == value)
        }
    }

    @Test
    func `bits popcount equals subscript-counted ones`() {
        for value in UInt8.min...UInt8.max {
            let byte = Byte(value)
            var ones = 0
            for index in 0..<8 where byte[index] == .one {
                ones += 1
            }
            #expect(byte.bits.popcount == ones)
        }
    }
}

// MARK: - Edge Case

extension Byte.`Bit Test`.`Edge Case` {
    @Test
    func `bits mask supports bitwise queries`() {
        let byte: Byte = 0b0000_1111
        let lowNibble = Bit.Pattern<UInt8>.Mask.lowBits(4)
        #expect(byte.bits.contains(lowNibble))
        #expect(byte.bits.intersects(lowNibble))
    }
}
