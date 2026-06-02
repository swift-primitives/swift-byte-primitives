import Byte_Primitives_Test_Support
import Testing

// MARK: - Test Suite Structure

extension Byte {
    @Suite struct `Collection+Byte Test` {}
}

extension Byte.`Collection+Byte Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
}

// MARK: - Unit — trimming(_ Set)

extension Byte.`Collection+Byte Test`.Unit {
    @Test
    func `trimming with set removes matching bytes from both ends`() {
        let bytes: [Byte] = [0x20, 0x48, 0x69, 0x20]  // " Hi "
        #expect(bytes.trimming([0x20]).elementsEqual([0x48, 0x69]))
    }

    @Test
    func `trimming with set keeps interior matching bytes`() {
        let bytes: [Byte] = [0x20, 0x48, 0x20, 0x69, 0x20]
        #expect(bytes.trimming([0x20]).elementsEqual([0x48, 0x20, 0x69]))
    }

    @Test
    func `trimming with predicate matches set semantics`() {
        let bytes: [Byte] = [0x09, 0x20, 0x46, 0x6F, 0x6F, 0x20, 0x09]
        let lwsp: Set<Byte> = [0x20, 0x09]
        #expect(bytes.trimming(lwsp).elementsEqual(bytes.trimming(where: lwsp.contains)))
        #expect(bytes.trimming(lwsp).elementsEqual([0x46, 0x6F, 0x6F]))
    }
}

// MARK: - Unit — firstIndex(of: Collection)

extension Byte.`Collection+Byte Test`.Unit {
    @Test
    func `firstIndex of byte subsequence returns matching position`() {
        let haystack: [Byte] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
        #expect(haystack.firstIndex(of: [0x6C, 0x6F]) == 3)
    }

    @Test
    func `firstIndex returns first match when multiple exist`() {
        let haystack: [Byte] = [0x61, 0x62, 0x61, 0x62, 0x63]  // "ababc"
        #expect(haystack.firstIndex(of: [0x61, 0x62]) == 0)
    }

    @Test
    func `contains returns true when subsequence present`() {
        let haystack: [Byte] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(haystack.contains([0x6C, 0x6F]))
        #expect(haystack.contains([0x48]))
    }

    @Test
    func `contains returns false when subsequence absent`() {
        let haystack: [Byte] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(!haystack.contains([0x7A]))
        #expect(!haystack.contains([0x6C, 0x7A]))
    }
}

// MARK: - Edge Case

extension Byte.`Collection+Byte Test`.`Edge Case` {
    @Test
    func `trimming empty collection yields empty subsequence`() {
        let empty: [Byte] = []
        #expect(empty.trimming([0x20]).isEmpty)
    }

    @Test
    func `trimming all-matching collection yields empty subsequence`() {
        let all: [Byte] = [0x20, 0x20, 0x20]
        #expect(all.trimming([0x20]).isEmpty)
    }

    @Test
    func `trimming with empty set is a no-op`() {
        let bytes: [Byte] = [0x48, 0x69]
        #expect(bytes.trimming(Set<Byte>()).elementsEqual([0x48, 0x69]))
    }

    @Test
    func `firstIndex of empty needle returns startIndex`() {
        let haystack: [Byte] = [0x48, 0x69]
        let empty: [Byte] = []
        #expect(haystack.firstIndex(of: empty) == 0)
    }

    @Test
    func `firstIndex of longer-than-haystack needle returns nil`() {
        let haystack: [Byte] = [0x48]
        #expect(haystack.firstIndex(of: [0x48, 0x69]) == nil)
    }

    @Test
    func `firstIndex of absent needle returns nil`() {
        let haystack: [Byte] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
        #expect(haystack.firstIndex(of: [0x77, 0x6F]) == nil)
    }
}
