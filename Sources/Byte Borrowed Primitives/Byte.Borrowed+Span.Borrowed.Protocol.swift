// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-byte-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-byte-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
//
// W2 DECOUPLE: `Byte.Borrowed` conforms to the namespace-neutral
// `Span.Borrowed.`Protocol`` (in swift-span-primitives), replacing the former
// memory-domain borrowed-span protocol conformance that was injected
// memory-side and is now retired. The nominal `Byte.Borrowed` struct is KEPT;
// only its borrowed-span capability conformance moves to the neutral protocol.
//
// The witness `var span: Swift.Span<Byte> { @_lifetime(copy self) get }`
// already exists on the struct (Byte.Borrowed.swift); this conformance binds
// it to `Span.Borrowed.`Protocol``'s requirement. `Element == Byte`.

public import Byte_Primitive
public import Span_Protocol_Primitives

extension Byte.Borrowed: Span.Borrowed.`Protocol` {
    public typealias Element = Byte
}
