// exports.swift
// Re-export Byte Protocol Primitives (transitively re-exports Byte_Primitive
// + Carrier_Primitives) so consumers importing Byte_Tagged_Primitives see
// the full Byte protocol surface in scope via a single import.

@_exported public import Byte_Protocol_Primitives
@_exported public import Tagged_Primitives
