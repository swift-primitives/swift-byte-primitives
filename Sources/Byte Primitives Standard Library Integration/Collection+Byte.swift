// Collection+Byte.swift
//
// Byte-domain collection utilities lifted to `Byte.`Protocol``.
//
// Mirrors `swift-binary-primitives/Collection+UInt8.swift`'s trimming and
// byte-subsequence search at the byte-domain layer. Per the
// byte-protocol-capability-marker discipline, `UInt8` itself does NOT
// conform to `Byte.`Protocol`` — these helpers fire exactly on the
// byte-domain set (`Byte`, `ASCII.Code`, `Tagged<_, Byte>`, future
// newtypes), without competing with the stdlib `UInt8` overloads.
//
// Motivating sites: rfc-2183 noted Set-keyed trimming on byte slices
// only has a UInt8-element pathway via `INCITS_4_1986.ASCII<Source>`;
// rfc-2046 noted `firstIndex(of: subsequence)` is UInt8-keyed in
// swift-binary-primitives. Lifting both completes the cascade for W2/W3
// container retypes.

public import Byte_Primitives

// MARK: - Byte Collection Trimming

extension Swift.Collection where Element: Byte.`Protocol` & Hashable {
    /// Trims byte-domain elements matching the given set from both ends.
    ///
    /// Returns a zero-copy `SubSequence` view of the original collection with
    /// matching bytes removed from the start and end. Companion to
    /// `swift-binary-primitives/Collection+UInt8.trimming(_:)` for the
    /// byte-domain layer.
    ///
    /// ```swift
    /// let bytes: [Byte] = [0x20, 0x48, 0x69, 0x20]    // " Hi "
    /// let trimmed = bytes.trimming([0x20])            // [0x48, 0x69]
    ///
    /// let lwsp: Set<Byte> = [0x20, 0x09]              // SPACE, HTAB
    /// let header: [Byte] = [0x09, 0x46, 0x6F, 0x6F, 0x20]
    /// let stripped = header.trimming(lwsp)            // [0x46, 0x6F, 0x6F]
    /// ```
    ///
    /// - Parameter byteSet: The set of byte-domain values to trim.
    /// - Returns: A subsequence with the specified bytes trimmed from both ends.
    @inlinable
    public func trimming(_ byteSet: Set<Element>) -> SubSequence {
        var start = startIndex
        while start != endIndex, byteSet.contains(self[start]) {
            start = index(after: start)
        }
        if start == endIndex {
            return self[start..<start]
        }
        var lastNonTrimIndex = start
        var i = start
        while i != endIndex {
            if !byteSet.contains(self[i]) {
                lastNonTrimIndex = i
            }
            i = index(after: i)
        }
        let end = index(after: lastNonTrimIndex)
        return self[start..<end]
    }

    /// Trims byte-domain elements matching the given predicate from both ends.
    ///
    /// ```swift
    /// let bytes: [Byte] = [0x20, 0x48, 0x69, 0x20]
    /// let trimmed = bytes.trimming(where: { $0 == Byte(0x20) })
    /// ```
    ///
    /// - Parameter predicate: Returns `true` for bytes to remove.
    /// - Returns: A subsequence with matching bytes trimmed from both ends.
    @inlinable
    public func trimming(where predicate: (Element) -> Bool) -> SubSequence {
        var start = startIndex
        while start != endIndex, predicate(self[start]) {
            start = index(after: start)
        }
        if start == endIndex {
            return self[start..<start]
        }
        var lastNonTrimIndex = start
        var i = start
        while i != endIndex {
            if !predicate(self[i]) {
                lastNonTrimIndex = i
            }
            i = index(after: i)
        }
        let end = index(after: lastNonTrimIndex)
        return self[start..<end]
    }
}

// MARK: - Byte Subsequence Search

extension Swift.Collection where Element: Byte.`Protocol` & Equatable {
    /// Finds the first occurrence of a byte-domain subsequence.
    ///
    /// Companion to `swift-binary-primitives/Collection+UInt8.firstIndex(of:)`
    /// lifted to the byte-domain layer. `needle` and `self` must share the
    /// same element type (e.g., both `[Byte]`, or both `[ASCII.Code]`).
    ///
    /// ```swift
    /// let haystack: [Byte] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
    /// let needle: [Byte] = [0x6C, 0x6F]
    /// haystack.firstIndex(of: needle)                 // 3
    /// ```
    ///
    /// - Parameter needle: The byte-domain subsequence to search for.
    /// - Returns: The index of the first occurrence, or `nil` if absent.
    @inlinable
    public func firstIndex<C: Swift.Collection>(of needle: C) -> Index?
    where C.Element == Element {
        guard !needle.isEmpty else { return startIndex }
        guard needle.count <= count else { return nil }
        var i = startIndex
        let searchEnd = index(endIndex, offsetBy: -needle.count + 1)
        while i < searchEnd {
            var matches = true
            var selfIndex = i
            var needleIndex = needle.startIndex
            while needleIndex != needle.endIndex {
                if self[selfIndex] != needle[needleIndex] {
                    matches = false
                    break
                }
                selfIndex = index(after: selfIndex)
                needleIndex = needle.index(after: needleIndex)
            }
            if matches {
                return i
            }
            i = index(after: i)
        }
        return nil
    }

    /// Checks if the collection contains a byte-domain subsequence.
    @inlinable
    public func contains<C: Swift.Collection>(_ needle: C) -> Bool
    where C.Element == Element {
        firstIndex(of: needle) != nil
    }
}
