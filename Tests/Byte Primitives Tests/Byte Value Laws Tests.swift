import Byte_Primitives_Test_Support
import Testing

extension Byte.Test {

    enum Law {}
}

extension Byte.Test.Law {

    static let domain: [Byte] = (UInt8.min...UInt8.max).map { Byte($0) }

    static let probes: [Byte] = [0x00, 0x01, 0x0F, 0x55, 0x7F, 0x80, 0xAA, 0xF0, 0xFE, 0xFF]

    enum Checksum {}
}

extension Byte.Test.Unit {
    @Test
    func `UInt8 injection and projection round-trip over the full domain`() {
        (UInt8.min...UInt8.max).forEach { value in
            #expect(Byte(value).underlying == value)
        }
    }

    @Test
    func `identity initializer preserves every byte`() {
        for byte in Byte.Test.Law.domain {
            #expect(Byte(byte) == byte)
        }
    }

    @Test
    func `byte-axis projection is the identity on Byte`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte.byte == byte)
        }
    }

    @Test
    func `description matches the underlying decimal rendering`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte.description == byte.underlying.description)
        }
    }
}

extension Byte.Test.Unit {
    @Test
    func `complement is an involution`() {
        for byte in Byte.Test.Law.domain {
            #expect(~(~byte) == byte)
        }
    }

    @Test
    func `De Morgan laws hold over the domain-probe grid`() {
        for a in Byte.Test.Law.domain {
            for b in Byte.Test.Law.probes {
                #expect(~(a & b) == (~a | ~b))
                #expect(~(a | b) == (~a & ~b))
            }
        }
    }

    @Test
    func `identity and annihilator elements`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte & Byte(0xFF) == byte)
            #expect(byte & Byte(0x00) == Byte(0x00))
            #expect(byte | Byte(0x00) == byte)
            #expect(byte | Byte(0xFF) == Byte(0xFF))
            #expect(byte ^ Byte(0x00) == byte)
        }
    }

    @Test
    func `AND and OR are idempotent`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte & byte == byte)
            #expect(byte | byte == byte)
        }
    }

    @Test
    func `XOR group laws: self-inverse and complement relation`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte ^ byte == Byte(0x00))
            #expect(byte ^ Byte(0xFF) == ~byte)
        }
    }

    @Test
    func `AND, OR and XOR are commutative over the domain-probe grid`() {
        for a in Byte.Test.Law.domain {
            for b in Byte.Test.Law.probes {
                #expect(a & b == b & a)
                #expect(a | b == b | a)
                #expect(a ^ b == b ^ a)
            }
        }
    }

    @Test
    func `associativity over the probe grid`() {
        for a in Byte.Test.Law.probes {
            for b in Byte.Test.Law.probes {
                for c in Byte.Test.Law.probes {
                    #expect((a & b) & c == a & (b & c))
                    #expect((a | b) | c == a | (b | c))
                    #expect((a ^ b) ^ c == a ^ (b ^ c))
                }
            }
        }
    }

    @Test
    func `distributivity over the probe grid`() {
        for a in Byte.Test.Law.probes {
            for b in Byte.Test.Law.probes {
                for c in Byte.Test.Law.probes {
                    #expect(a & (b | c) == (a & b) | (a & c))
                    #expect(a | (b & c) == (a | b) & (a | c))
                }
            }
        }
    }
}

extension Byte.Test.Unit {
    @Test
    func `order agrees with the underlying UInt8 order over the domain-probe grid`() {
        for a in Byte.Test.Law.domain {
            for b in Byte.Test.Law.probes {
                #expect((a < b) == (a.underlying < b.underlying))
                #expect((a == b) == (a.underlying == b.underlying))
            }
        }
    }

    @Test
    func `equal bytes hash equally over the full domain`() {
        let uniqued = Set(Byte.Test.Law.domain + Byte.Test.Law.domain)
        #expect(uniqued.count == 256)
    }
}

extension Byte.Test.`Edge Case` {
    @Test
    func `shift by zero is the identity`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte << 0 == byte)
            #expect(byte >> 0 == byte)
        }
    }

    @Test
    func `shift by eight or more saturates to zero`() {
        for byte in Byte.Test.Law.domain {
            #expect(byte << 8 == Byte(0x00))
            #expect(byte >> 8 == Byte(0x00))
            #expect(byte << UInt8.max == Byte(0x00))
            #expect(byte >> UInt8.max == Byte(0x00))
        }
    }

    @Test
    func `in-range shifts match the underlying masking shifts`() {
        for byte in Byte.Test.Law.domain {
            (UInt8(0)..<8).forEach { amount in
                #expect((byte << amount).underlying == byte.underlying &<< amount)
                #expect((byte >> amount).underlying == byte.underlying &>> amount)
            }
        }
    }

    @Test
    func `in-range shifts compose additively`() {
        for byte in Byte.Test.Law.probes {
            (UInt8(0)...4).forEach { first in
                (UInt8(0)...3).forEach { second in
                    #expect((byte << first) << second == byte << (first + second))
                    #expect((byte >> first) >> second == byte >> (first + second))
                }
            }
        }
    }

    @Test
    func `zero and max are the order extremes`() {
        for byte in Byte.Test.Law.domain {
            #expect(Byte.zero <= byte)
            #expect(byte <= Byte.max)
        }
        #expect(Byte.zero == Byte(0x00))
        #expect(Byte.max == Byte(0xFF))
    }
}

extension Byte.Test.Integration {
    @Test
    func `Tagged bytes inherit bitwise semantics unchanged`() {
        for a in Byte.Test.Law.probes {
            for b in Byte.Test.Law.probes {
                let taggedA = Tagged<Byte.Test.Law.Checksum, Byte>(a)
                let taggedB = Tagged<Byte.Test.Law.Checksum, Byte>(b)
                #expect((taggedA & taggedB).byte == a & b)
                #expect((taggedA | taggedB).byte == a | b)
                #expect((taggedA ^ taggedB).byte == a ^ b)
                #expect((~taggedA).byte == ~a)
            }
        }
    }

    @Test
    func `Tagged bytes inherit shift semantics unchanged`() {
        for byte in Byte.Test.Law.probes {
            let tagged = Tagged<Byte.Test.Law.Checksum, Byte>(byte)
            for amount in [0, 1, 4, 7, 8] as [UInt8] {
                #expect((tagged << amount).byte == byte << amount)
                #expect((tagged >> amount).byte == byte >> amount)
            }
        }
    }

    @Test
    func `Tagged bytes inherit order and extremes`() {
        let zero: Tagged<Byte.Test.Law.Checksum, Byte> = .zero
        let max: Tagged<Byte.Test.Law.Checksum, Byte> = .max
        #expect(zero.byte == Byte(0x00))
        #expect(max.byte == Byte(0xFF))
        #expect(zero < max)
    }

    @Test
    func `Tagged byte literal construction matches Byte literal construction`() {
        let tagged: Tagged<Byte.Test.Law.Checksum, Byte> = 0xA5
        let byte: Byte = 0xA5
        #expect(tagged.byte == byte)
    }
}
