// Byte+Codable Tests.swift
//
// Foundation-free wire-form check for `Byte: Codable`. byte's Codable delegates
// to its `UInt8` underlying (`underlying.encode(to:)` / `init(UInt8(from:))`) so
// it serializes as a bare single value (`42`), not a keyed object. That delegation
// is the only byte-specific behavior, and it is what this suite verifies — via a
// minimal stdlib-only `Encoder` probe, with no Foundation (`JSONEncoder`), so the
// primitive stays Foundation-free per [PRIM-FOUND-001]. Round-trip / range / array
// coverage is intentionally not re-tested: that exercises `UInt8`'s own Codable.

import Testing

@testable import Byte_Primitives

@Suite("Byte+Codable")
struct ByteCodableTests {

    @Test("Byte encodes as a single UInt8 value (bare wire form, not keyed)")
    func encodesAsBareUInt8() throws {
        let probe = SingleValueEncoderProbe()
        try Byte(0x2A).encode(to: probe)
        #expect(probe.recorded.value == 0x2A)
    }
}

@Suite("Byte+CustomStringConvertible")
struct ByteDescriptionTests {

    @Test("Decimal description matches UInt8")
    func decimalDescription() {
        #expect(Byte(0).description == "0")
        #expect(Byte(127).description == "127")
        #expect(Byte(255).description == "255")
    }
}

// MARK: - Foundation-free single-value Encoder probe

// Records the single `UInt8` written by `Byte.encode(to:)`. byte delegates to its
// `UInt8` underlying (a single-value encode); requesting a keyed/unkeyed container —
// or encoding a non-`UInt8` value — would be a wire-form regression and traps.
private struct SingleValueEncoderProbe: Encoder, SingleValueEncodingContainer {
    final class Recorded { var value: UInt8? }
    let recorded = Recorded()

    var codingPath: [any CodingKey] { [] }
    var userInfo: [CodingUserInfoKey: Any] { [:] }

    func singleValueContainer() -> any SingleValueEncodingContainer { self }
    func unkeyedContainer() -> any UnkeyedEncodingContainer { wrongShape() }
    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> { wrongShape() }

    func encode(_ value: UInt8) throws { recorded.value = value }

    func encodeNil() throws { wrongShape() }
    func encode(_ value: Bool) throws { wrongShape() }
    func encode(_ value: String) throws { wrongShape() }
    func encode(_ value: Double) throws { wrongShape() }
    func encode(_ value: Float) throws { wrongShape() }
    func encode(_ value: Int) throws { wrongShape() }
    func encode(_ value: Int8) throws { wrongShape() }
    func encode(_ value: Int16) throws { wrongShape() }
    func encode(_ value: Int32) throws { wrongShape() }
    func encode(_ value: Int64) throws { wrongShape() }
    func encode(_ value: UInt) throws { wrongShape() }
    func encode(_ value: UInt16) throws { wrongShape() }
    func encode(_ value: UInt32) throws { wrongShape() }
    func encode(_ value: UInt64) throws { wrongShape() }
    func encode(_ value: some Encodable) throws { wrongShape() }

    private func wrongShape() -> Never {
        fatalError("Byte must encode as a single UInt8 value (bare wire form)")
    }
}
