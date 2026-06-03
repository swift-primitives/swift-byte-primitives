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
// W3 PRUNE: the nominal `Byte.Borrowed` struct is DELETED. Its role — a
// `~Copyable & ~Escapable` borrow-view over `Swift.Span<Byte>` — is now
// played by bare `Swift.Span<Byte>` itself, which IS the borrowed-span
// capability by identity (`Swift.Span: Span.Borrowed.`Protocol`` — the
// linchpin conformance in swift-span-primitives). Every member the nominal
// vended (`span`, `init(_ span:)`, `count`) is native to `Swift.Span`, so
// there is no byte-domain span API to re-home — the nominal was a pure
// wrapper. Per the `.Borrowed`-prune disposition in
// swift-institute/Research/memory-byte-bit-domain-orthogonality.md.

public import Byte_Protocol_Primitives
public import Ownership_Primitives

// MARK: - Byte: Ownership.Borrow.`Protocol`

/// Conforms ``Byte`` to ``Ownership/Borrow/Protocol`` with `Borrowed`
/// resolved to `Swift.Span<Byte>`.
///
/// `Byte` is a Case-B-shaped conformer where the borrowed projection is the
/// stdlib `Swift.Span<Byte>` rather than a locally-declared nominal view.
/// This drives `Cursor<Byte>`: the single-generic borrowed-bytes cursor
/// `Cursor<DomainTag: Ownership.Borrow.`Protocol`>` derives its storage as
/// `DomainTag.Borrowed`, so `Cursor<Byte>.storage` is `Swift.Span<Byte>`.
/// `Text` (`typealias Borrowed = Swift.Span<Byte>`) and `Binary`
/// (`typealias Borrowed = Swift.Span<Byte>`) share the same shape — all three
/// cursors read a bare span, with no per-element wrapping.
///
/// `Swift.Span<Byte>` satisfies the associated-type constraint
/// `Borrowed: ~Copyable, ~Escapable`: it is `~Escapable` (its scope is its
/// lifetime) and carries the byte-domain read-access contract through its
/// identity conformance to ``Span/Borrowed/Protocol``.
extension Byte: Ownership.Borrow.`Protocol` {
    public typealias Borrowed = Swift.Span<Byte>
}
