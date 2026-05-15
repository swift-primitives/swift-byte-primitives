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
        .package(path: "../swift-carrier-primitives"),
    ],
    targets: [
        .target(
            name: "Byte Primitives",
            dependencies: [
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
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
                .product(name: "Carrier Primitives Test Support", package: "swift-carrier-primitives"),
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
