// swift-tools-version: 6.5

import PackageDescription

let package = Package(
    name: "SDL",
    platforms: [.macOS(.v26)],
    products: [
        .library(
            name: "SDL",
            targets: ["SDL"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-tools-support-core.git", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "603.0.1"),
    ],
    targets: [
        .target(
            name: "CSDL",
            path: "src/swift/CSDL",
            publicHeadersPath: ".",
            cSettings: [
                .publicHeaderPath("../../../include"),
            ],
            linkerSettings: [
                .linkedLibrary("SDL3"),
                .linkedFramework("CoreMedia", .when(platforms: [.macOS])),
                .linkedFramework("CoreVideo", .when(platforms: [.macOS])),
                .linkedFramework("Cocoa", .when(platforms: [.macOS])),
                .linkedFramework("UniformTypeIdentifiers", .when(platforms: [.macOS])),
                .linkedFramework("IOKit", .when(platforms: [.macOS])),
                .linkedFramework("ForceFeedback", .when(platforms: [.macOS])),
                .linkedFramework("Carbon", .when(platforms: [.macOS])),
                .linkedFramework("CoreAudio", .when(platforms: [.macOS])),
                .linkedFramework("AudioToolbox", .when(platforms: [.macOS])),
                .linkedFramework("AVFoundation", .when(platforms: [.macOS])),
                .linkedFramework("Foundation", .when(platforms: [.macOS])),
                .linkedFramework("GameController", .when(platforms: [.macOS])),
                .linkedFramework("Metal", .when(platforms: [.macOS])),
                .linkedFramework("QuartzCore", .when(platforms: [.macOS])),
                .linkedFramework("CoreHaptics", .when(platforms: [.macOS]))
            ],
            plugins: ["SDLAPIGenPlugin"],
        ),
        .target(
            name: "SDL",
            dependencies: ["CSDL"],
            path: "src/swift/SDL",
            cSettings: [
                // TODO: this shouldn't be necessary but is for now
                .headerSearchPath("../../../include"),
            ],
            plugins: ["SwiftSDLGenPlugin"]
        ),
        .plugin(
            name: "CMakeBuilder",
            capability: .externalBuilder,
            path: "src/swift/CMakeBuilder"
        ),
        .target(
            name: "SwiftBinding",
            dependencies: [
                .product(name: "TSCBasic", package: "swift-tools-support-core"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            path: "src/swift/SwiftBinding"
        ),
        .target(
            name: "SDLGenerator",
            dependencies: ["SwiftBinding"],
            path: "src/swift/SDLGenerator"
        ),
        .executableTarget(
            name: "SDLAPIGenerator",
            dependencies: ["SDLGenerator"],
            path: "src/swift/SDLAPIGenerator"
        ),
        .plugin(
            name: "SDLAPIGenPlugin",
            capability: .buildTool,
            dependencies: ["SDLAPIGenerator"],
            path: "src/swift/SDLAPIGenPlugin"
        ),
        .executableTarget(
            name: "SwiftSDLGenerator",
            path: "src/swift/SwiftSDLGenerator"
        ),
        .plugin(
            name: "SwiftSDLGenPlugin",
            capability: .buildTool,
            dependencies: ["SwiftSDLGenerator"],
            path: "src/swift/SwiftSDLGenPlugin"
        ),
        .testTarget(
            name: "SDLTests",
            dependencies: ["SDL"],
            path: "test/swift/SDLTests"
        ),
    ],
    plugins: [
        "CMakeBuilder",
    ]
)
