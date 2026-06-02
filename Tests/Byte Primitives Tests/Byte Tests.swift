import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct Test {}
}

extension Byte.Test {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Unit

extension Byte.Test.Unit {
    @Test
    func `init from UInt8 exposes underlying value`() {
        let b = Byte(0x42)
        #expect(b.underlying == 0x42)
    }

    @Test
    func `integer literal constructs byte`() {
        let b: Byte = 0xFF
        #expect(b.underlying == 0xFF)
    }

    @Test
    func `equality compares underlying values`() {
        #expect(Byte(0x10) == Byte(0x10))
        #expect(Byte(0x10) != Byte(0x11))
    }

    @Test
    func `comparison orders by underlying value`() {
        #expect(Byte(0x10) < Byte(0x11))
        #expect(Byte(0xFF) > Byte(0x00))
    }

    @Test
    func `hashable uses underlying value`() {
        var set: Set<Byte> = []
        set.insert(0x10)
        set.insert(0x10)
        set.insert(0x11)
        #expect(set.count == 2)
    }

    @Test
    func `bitwise AND masks correctly`() {
        let result = Byte(0xFF) & Byte(0x0F)
        #expect(result == Byte(0x0F))
    }

    @Test
    func `bitwise OR combines correctly`() {
        let result = Byte(0xF0) | Byte(0x0F)
        #expect(result == Byte(0xFF))
    }

    @Test
    func `bitwise XOR toggles correctly`() {
        let result = Byte(0xFF) ^ Byte(0x0F)
        #expect(result == Byte(0xF0))
    }

    @Test
    func `bitwise complement inverts all bits`() {
        let result = ~Byte(0x0F)
        #expect(result == Byte(0xF0))
    }

    @Test
    func `left shift moves bits left and zero-fills`() {
        let result = Byte(0x01) << 4
        #expect(result == Byte(0x10))
    }

    @Test
    func `right shift moves bits right and zero-fills`() {
        let result = Byte(0x80) >> 4
        #expect(result == Byte(0x08))
    }

    @Test
    func `compound assignments mutate in place`() {
        var b: Byte = 0xFF
        b &= 0x0F
        #expect(b == 0x0F)

        b |= 0x10
        #expect(b == 0x1F)

        b ^= 0x0F
        #expect(b == 0x10)
    }
}

// MARK: - Edge Case

extension Byte.Test.`Edge Case` {
    @Test
    func `zero byte`() {
        let b: Byte = 0
        #expect(b.underlying == 0)
    }

    @Test
    func `maximum byte`() {
        let b: Byte = 0xFF
        #expect(b.underlying == 255)
    }

    @Test
    func `shift by eight or more zeroes the byte`() {
        #expect(Byte(0xFF) << 8 == Byte(0))
        #expect(Byte(0xFF) >> 8 == Byte(0))
        #expect(Byte(0xFF) << 255 == Byte(0))
        #expect(Byte(0xFF) >> 255 == Byte(0))
    }

    @Test
    func `AND with zero clears all bits`() {
        #expect(Byte(0xFF) & Byte(0x00) == Byte(0x00))
    }

    @Test
    func `OR with all-ones saturates`() {
        #expect(Byte(0x00) | Byte(0xFF) == Byte(0xFF))
    }

    @Test
    func `XOR with self is zero`() {
        #expect(Byte(0x5A) ^ Byte(0x5A) == Byte(0x00))
    }

    @Test
    func `complement is involutive`() {
        let b: Byte = 0x5A
        #expect(~(~b) == b)
    }
}

// MARK: - Integration

extension Byte.Test.Integration {
    @Test
    func `Carrier underlying round-trips`() {
        let b = Byte(0x42)
        let raw: UInt8 = b.underlying
        let b2 = Byte(raw)
        #expect(b == b2)
    }

    @Test
    func `Carrier init from consuming UInt8 stores underlying value`() {
        let raw: UInt8 = 0x99
        let b = Byte(raw)
        #expect(b.underlying == 0x99)
    }

    @Test
    func `mask-and-shift extracts nibble`() {
        let b: Byte = 0xAB
        let upper = (b & 0xF0) >> 4
        let lower = b & 0x0F
        #expect(upper == 0x0A)
        #expect(lower == 0x0B)
    }

    @Test
    func `zero and max constants compose with bitwise`() {
        #expect(Byte.zero | Byte.max == Byte.max)
        #expect(Byte.zero & Byte.max == Byte.zero)
        #expect(~Byte.zero == Byte.max)
    }

    @Test
    func `bitwise AND across all bytes sums correctly`() {
        var total: UInt = 0
        (UInt8.min...UInt8.max).forEach { i in
            let result = Byte(i) & Byte(0xF0)
            total &+= UInt(result.underlying)
        }
        // Sum of (i & 0xF0) for i in 0...255 = 16 * (0+16+32+...+240) = 16 * 1920 = 30720
        #expect(total == 30720)
    }
}
