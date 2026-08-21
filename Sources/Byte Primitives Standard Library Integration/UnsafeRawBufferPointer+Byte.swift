public import Byte_Primitives

extension UnsafeMutableRawBufferPointer {

    @inlinable
    public func copyBytes<Bytes: Swift.Sequence>(
        from source: Bytes
    ) where Bytes.Element == Byte {
        let copied = source.withContiguousStorageIfAvailable { sourceBuffer -> Int in
            let bytesToCopy = Swift.min(sourceBuffer.count, self.count)
            if bytesToCopy > 0,
                let dest = self.baseAddress,
                let src = sourceBuffer.baseAddress
            {
                unsafe dest.copyMemory(
                    from: UnsafeRawPointer(src),
                    byteCount: bytesToCopy
                )
            }
            return bytesToCopy
        }
        if copied != nil { return }

        var iterator = source.makeIterator()
        var offset = 0
        while offset < self.count, let byte = iterator.next() {

            unsafe self.baseAddress!.storeBytes(
                of: byte,
                toByteOffset: offset,
                as: Byte.self
            )
            offset += 1
        }
    }
}
