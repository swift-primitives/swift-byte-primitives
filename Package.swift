// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-byte-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Byte Primitive",
            targets: ["Byte Primitive"]
        ),
        .library(
            name: "Byte Protocol Primitives",
            targets: ["Byte Protocol Primitives"]
        ),
        .library(
            name: "Byte Borrowed Primitives",
            targets: ["Byte Borrowed Primitives"]
        ),
        .library(
            name: "Byte Tagged Primitives",
            targets: ["Byte Tagged Primitives"]
        ),
        .library(
            name: "Byte Primitives",
            targets: ["Byte Primitives"]
        ),
        .library(
            name: "Byte Primitives Standard Library Integration",
            targets: ["Byte Primitives Standard Library Integration"]
        ),
        .library(
            name: "Byte Primitives Test Support",
            targets: ["Byte Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-carrier-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-ownership-primitives.git", branch: "main"),
        .package(path: "../swift-span-primitives"),
    ],
    targets: [
        .target(
            name: "Byte Primitive",
            dependencies: []
        ),
        .target(
            name: "Byte Protocol Primitives",
            dependencies: [
                "Byte Primitive",
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
            ]
        ),
        .target(
            name: "Byte Borrowed Primitives",
            dependencies: [
                "Byte Protocol Primitives",
                .product(name: "Ownership Primitives", package: "swift-ownership-primitives"),
                .product(name: "Span Protocol Primitives", package: "swift-span-primitives"),
            ]
        ),
        .target(
            name: "Byte Tagged Primitives",
            dependencies: [
                "Byte Protocol Primitives",
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Byte Primitives",
            dependencies: [
                "Byte Primitive",
                "Byte Protocol Primitives",
                "Byte Borrowed Primitives",
                "Byte Tagged Primitives",
            ]
        ),
        .target(
            name: "Byte Primitives Standard Library Integration",
            dependencies: [
                "Byte Primitives",
                .product(name: "Carrier Primitives Standard Library Integration", package: "swift-carrier-primitives"),
            ]
        ),
        .target(
            name: "Byte Primitives Test Support",
            dependencies: [
                "Byte Primitives",
                "Byte Primitives Standard Library Integration",
                .product(name: "Ownership Primitives Test Support", package: "swift-ownership-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Byte Primitives Tests",
            dependencies: [
                "Byte Primitives",
                "Byte Primitives Test Support",
            ]
        ),
        .testTarget(
            name: "Byte Primitives Standard Library Integration Tests",
            dependencies: [
                "Byte Primitives",
                "Byte Primitives Standard Library Integration",
                "Byte Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
