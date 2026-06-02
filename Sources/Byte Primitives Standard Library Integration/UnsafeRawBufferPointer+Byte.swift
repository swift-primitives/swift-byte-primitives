// UnsafeRawBufferPointer+Byte.swift
//
// Byte-canonical companions to stdlib's `UnsafeMutableRawBufferPointer.copyBytes(from:)`
// and `UnsafeMutableRawPointer.storeBytes(of:as:)` patterns. Stdlib's signatures
// constrain sources to `UInt8`; these byte-typed overloads accept `Byte`
// sequences directly, matching the institute's "Byte is canonical" discipline.
//
// Memory layout: `Byte` is `@frozen` with a single `underlying: UInt8` stored
// property, making it BitwiseCopyable and layout-identical to `UInt8`. Raw
// pointer load/store with `as: Byte.self` is sound; rebinding raw memory
// between `UInt8` and `Byte` is a no-op at the layout level.
//
// Per [API-BYTE-007]: stdlib-interop byte-typed extensions live in SLI.

public import Byte_Primitives

// MARK: - UnsafeMutableRawBufferPointer.copyBytes (Byte-typed)

extension UnsafeMutableRawBufferPointer {
    /// Copies `Byte` values from a sequence into this raw buffer.
    ///
    /// Byte-canonical companion to stdlib's
    /// `copyBytes(from:) where Bytes.Element == UInt8`. Stops at the lesser of
    /// the source's element count and this buffer's byte count.
    ///
    /// When the source provides contiguous storage, this uses `memcpy`.
    /// Otherwise, it falls back to per-byte iteration.
    @inlinable
    public func copyBytes<Bytes: Swift.Sequence>(
        from source: Bytes
    ) where Bytes.Element == Byte {
        let copied = unsafe source.withContiguousStorageIfAvailable { sourceBuffer -> Int in
            let bytesToCopy = Swift.min(sourceBuffer.count, self.count)
            if bytesToCopy > 0,
                let dest = unsafe self.baseAddress,
                let src = unsafe sourceBuffer.baseAddress
            {
                unsafe dest.copyMemory(
                    from: UnsafeRawPointer(src),
                    byteCount: bytesToCopy
                )
            }
            return bytesToCopy
        }
        if copied != nil { return }
        // Fallback: per-byte iteration for non-contiguous sources.
        var iterator = source.makeIterator()
        var offset = 0
        while offset < self.count, let byte = iterator.next() {
            // WHY: the loop only runs when `offset < self.count`, so `self.count >= 1`;
            // a non-empty raw buffer always has a non-nil `baseAddress`.
            // swift-format-ignore: NeverForceUnwrap
            unsafe self.baseAddress!.storeBytes(
                of: byte,
                toByteOffset: offset,
                as: Byte.self
            )
            offset += 1
        }
    }
}
