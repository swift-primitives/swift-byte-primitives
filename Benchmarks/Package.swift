// swift-tools-version: 6.3.1

import PackageDescription

// Standalone benchmark harness for the typed byte→bit decomposition.
// Nested package per [BENCH-001]/[BENCH-003] (executable-target instrument):
// own .build, run the binary directly with `-c release` — never `swift test`.
let package = Package(
    name: "byte-bit-benchmarks",
    platforms: [
        .macOS(.v26)
    ],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/swift-primitives/swift-bit-primitives.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "byte-bit-bench",
            dependencies: [
                .product(name: "Byte Bit Primitives", package: "byte-bit-decomposition"),
                .product(name: "Byte Primitive", package: "byte-bit-decomposition"),
                .product(name: "Bit Primitive", package: "swift-bit-primitives"),
                .product(name: "Bit Pattern Primitives", package: "swift-bit-primitives"),
            ]
        )
    ]
)
