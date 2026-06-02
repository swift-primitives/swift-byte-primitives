import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Integer+Byte Test` {}
}

extension Byte.`Integer+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

// MARK: - Unit (Widening conversions)

extension Byte.`Integer+Byte Test`.Unit {
    @Test
    func `UInt16 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(UInt16(b) == 0x00AB)
    }

    @Test
    func `UInt32 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(UInt32(b) == 0x0000_00AB)
    }

    @Test
    func `UInt64 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(UInt64(b) == 0x0000_0000_0000_00AB)
    }

    @Test
    func `Int8 from Byte preserves value when fits`() {
        let b: Byte = 0x42
        #expect(Int8(b) == 0x42)
    }

    @Test
    func `Int16 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(Int16(b) == 0x00AB)
    }

    @Test
    func `Int32 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(Int32(b) == 0x0000_00AB)
    }

    @Test
    func `Int64 widens Byte zero-extending`() {
        let b: Byte = 0xAB
        #expect(Int64(b) == 0x0000_0000_0000_00AB)
    }
}

// MARK: - Unit (bitPattern conversions)

extension Byte.`Integer+Byte Test`.Unit {
    @Test
    func `Int8 bitPattern preserves bits, treats high bit as sign`() {
        let high: Byte = 0xFF
        #expect(Int8(bitPattern: high) == -1)

        let mid: Byte = 0x80
        #expect(Int8(bitPattern: mid) == Int8.min)

        let low: Byte = 0x7F
        #expect(Int8(bitPattern: low) == Int8.max)
    }

    @Test
    func `Int16 bitPattern zero-extends Byte`() {
        let b: Byte = 0xFF
        #expect(Int16(bitPattern: b) == 0x00FF)
    }

    @Test
    func `Int32 bitPattern zero-extends Byte`() {
        let b: Byte = 0xFF
        #expect(Int32(bitPattern: b) == 0x0000_00FF)
    }

    @Test
    func `Int64 bitPattern zero-extends Byte`() {
        let b: Byte = 0xFF
        #expect(Int64(bitPattern: b) == 0x0000_0000_0000_00FF)
    }
}

// MARK: - Unit (Byte.init?(exactly:))

extension Byte.`Integer+Byte Test`.Unit {
    @Test
    func `Byte exactly succeeds for in-range integer`() {
        #expect(Byte(exactly: 0) == Byte(0))
        #expect(Byte(exactly: 42) == Byte(42))
        #expect(Byte(exactly: 255) == Byte(255))
    }

    @Test
    func `Byte exactly returns nil for negative`() {
        #expect(Byte(exactly: -1) == nil)
        #expect(Byte(exactly: Int.min) == nil)
    }

    @Test
    func `Byte exactly returns nil for too-large`() {
        #expect(Byte(exactly: 256) == nil)
        #expect(Byte(exactly: Int.max) == nil)
    }
}

// MARK: - Edge Case

extension Byte.`Integer+Byte Test`.`Edge Case` {
    @Test
    func `zero round-trips through all widening forms`() {
        let z: Byte = 0
        #expect(UInt16(z) == 0)
        #expect(UInt32(z) == 0)
        #expect(UInt64(z) == 0)
        #expect(Int8(z) == 0)
        #expect(Int16(z) == 0)
        #expect(Int32(z) == 0)
        #expect(Int64(z) == 0)
    }

    @Test
    func `max byte 0xFF widens correctly per unsigned target`() {
        let m: Byte = 0xFF
        #expect(UInt16(m) == 255)
        #expect(UInt32(m) == 255)
        #expect(UInt64(m) == 255)
        #expect(Int16(m) == 255)
        #expect(Int32(m) == 255)
        #expect(Int64(m) == 255)
    }
}

// MARK: - Integration

extension Byte.`Integer+Byte Test`.Integration {
    @Test
    func `round-trip Byte through UInt16 preserves value`() {
        (UInt8.min...UInt8.max).forEach { i in
            let b = Byte(i)
            let widened = UInt16(b)
            #expect(UInt16(b.underlying) == widened)
        }
    }

    @Test
    func `Int8 bitPattern is inverse of UInt8 bitPattern round-trip`() {
        (UInt8.min...UInt8.max).forEach { i in
            let b = Byte(i)
            let signed = Int8(bitPattern: b)
            #expect(UInt8(bitPattern: signed) == i)
        }
    }

    @Test
    func `Byte exactly is inverse of widening for in-range values`() {
        (UInt8.min...UInt8.max).forEach { i in
            let widened = UInt16(i)
            #expect(Byte(exactly: widened) == Byte(i))
        }
    }
}
