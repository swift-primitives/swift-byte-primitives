// exports.swift
// Umbrella re-export of the full Byte surface: Namespace + Protocol surface
// + Borrowed view + Tagged conformance. Per [MOD-005] this target's sole
// content is `@_exported public import` re-exports of the sub-namespace
// targets. Consumers importing Byte_Primitives get the union.

@_exported public import Byte_Borrowed_Primitives
@_exported public import Byte_Primitive
@_exported public import Byte_Protocol_Primitives
@_exported public import Byte_Tagged_Primitives
