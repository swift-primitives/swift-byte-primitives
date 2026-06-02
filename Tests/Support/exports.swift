// exports.swift
// Re-export test support dependencies for consumers.
//
// Spine anchor per [MOD-024]: Ownership Primitives Test Support is the
// highest-up upstream TS in direct product deps; it chains through Tagged
// Primitives Test Support to Carrier Primitives Test Support, so this
// single re-export carries the full spine transitively.

@_exported public import Byte_Primitives
@_exported public import Byte_Primitives_Standard_Library_Integration
@_exported public import Ownership_Primitives_Test_Support
