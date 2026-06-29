// exports.swift
// Re-export the byte type plus the bit-domain types this integration target
// surfaces in its public API (`Bit`, `Bit.Pattern<_>.Mask`) so consumers
// importing Byte_Bit_Primitives see the full decomposition surface via a
// single import.

@_exported public import Byte_Primitive
@_exported public import Bit_Primitive
@_exported public import Bit_Pattern_Primitives
