// swift-tools-version: 6.4

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
            plugins: ["SDLGeneratorPlugin"],
        ),
        .target(
            name: "SDL",
            dependencies: ["CSDL"],
            path: "src/swift/SDL",
            cSettings: [
                // TODO: this shouldn't be necessary but is for now
                .headerSearchPath("../../../include"),
            ]
        ),
        .plugin(
            name: "CMakeBuilder",
            capability: .externalBuilder,
            path: "src/swift/CMakeBuilder"
        ),
        .plugin(
            name: "SDLGeneratorPlugin",
            capability: .buildTool,
            path: "src/swift/SDLGeneratorPlugin"
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
