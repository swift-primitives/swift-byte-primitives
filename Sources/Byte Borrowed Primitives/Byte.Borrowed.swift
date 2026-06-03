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

public import Byte_Primitive
public import Byte_Protocol_Primitives
public import Ownership_Primitives

extension Byte {
    // SAFETY: Safe by construction — backing storage uses only stdlib safe
    // SAFETY: types; `@safe` documents that this type performs no unsafe
    // SAFETY: operations.
    /// Borrowed view of a contiguous span of bytes.
    ///
    /// `Byte.Borrowed` is the byte-domain counterparty to ``Byte`` — a
    /// `~Copyable & ~Escapable` borrow-view over `Swift.Span<Byte>`, parallel
    /// to ``String/Borrowed`` for strings and ``Path/Borrowed`` for paths.
    /// It encodes affine ownership of a contiguous byte region at the type
    /// level.
    ///
    /// Case B conformer of ``Ownership/Borrow/Protocol`` per
    /// `ownership-borrow-protocol-unification.md` v1.0.0 — type owns interior
    /// storage (the Span) and encodes a type-level invariant (the borrow
    /// lifetime).
    ///
    /// Conforms to ``Span/Borrowed/Protocol`` with `Element == Byte`,
    /// providing the unified read-access contract that `Cursor<DomainTag>`
    /// operations (peek/advance/consume/seek) parameterize on. (The neutral
    /// span protocol lives in swift-span-primitives; `Swift.Span<Byte>` itself
    /// also conforms by identity.)
    ///
    /// ## Span<Byte> substrate (W2 cascade landed)
    ///
    /// The span field is `Swift.Span<Byte>` per the W2 byte-domain typing
    /// discipline. Stdlib-interop callers holding `Span<UInt8>` (from
    /// `String.utf8`, `Data`, raw byte buffers) bridge at the SLI boundary
    /// — see `Byte_Primitives_Standard_Library_Integration` for the
    /// `@_disfavoredOverload` forwarders. Under the Span<Byte> substrate,
    /// `Cursor<DomainTag>` operations return `Byte` directly without
    /// per-element wrapping.
    ///
    /// ## Lifetime
    ///
    /// `~Copyable & ~Escapable`. The view cannot be duplicated and cannot
    /// outlive the source span it borrows. The compiler enforces this via
    /// `@_lifetime(borrow span)` on the initializer.
    ///
    /// ## Usage
    ///
    /// `Byte.Borrowed` is the institute's borrowed-Span storage for the
    /// byte domain. The single-generic cursor `Cursor<Byte>` derives its
    /// storage as `Byte.Borrowed` via Byte's
    /// `Ownership.Borrow.\`Protocol\`` conformance; the cursor inherits
    /// `~Copyable & ~Escapable` from `Byte.Borrowed`'s own suppression
    /// attributes.
    @safe
    public struct Borrowed: ~Copyable, ~Escapable {
        @usableFromInline
        internal let _span: Swift.Span<Byte>

        /// The borrowed span of bytes.
        ///
        /// Lifetime-bound to `self` via `@_lifetime(copy self)` — the span
        /// flows from whatever scope produced this Borrowed view.
        @inlinable
        public var span: Swift.Span<Byte> {
            @_lifetime(copy self) get { _span }
        }

        /// Creates a borrowed view from a span.
        ///
        /// The view's lifetime is bound to the span's lifetime.
        @inlinable
        @_lifetime(borrow span)
        public init(_ span: borrowing Swift.Span<Byte>) {
            self._span = copy span
        }

        /// The number of bytes the borrowed view spans.
        @inlinable
        public var count: Int { _span.count }
    }
}

// MARK: - Ownership.Borrow.`Protocol` Conformance

extension Byte: Ownership.Borrow.`Protocol` {}

// Note: Byte.Borrowed's borrowed-span capability conformance is to the
// namespace-neutral `Span.Borrowed.`Protocol`` (with `Element == Byte`),
// declared in this package — see
// `Byte.Borrowed+Span.Borrowed.Protocol.swift`. This replaces the former
// memory-domain borrowed-span protocol conformance (W2 decouple): the neutral
// span protocol lets byte/binary/memory each conform without a cross-domain
// edge, and byte no longer depends on memory.
