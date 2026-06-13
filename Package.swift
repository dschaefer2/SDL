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
            name: "SDL",
            cSettings: [
                .publicHeaderPath("../../include"),
            ],
            swiftSettings: [
                .bridgingHeader("SDL3.h", visibility: .public),
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
        .plugin(name: "CMakeBuilder", capability: .externalBuilder),
        .plugin(name: "SDLGeneratorPlugin", capability: .buildTool),
        .testTarget(
            name: "SDLTests",
            dependencies: ["SDL"],
        ),
    ],
    plugins: [
        "CMakeBuilder",
    ]
)
