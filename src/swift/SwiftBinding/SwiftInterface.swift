import Foundation
import TSCBasic
import SwiftSyntax
import SwiftParser

public func parseInterface(headerPaths: [URL], moduleDir: URL, moduleName: String) throws -> SourceFileSyntax {
    let findSDK = TSCBasic.Process(args: "xcrun", "--show-sdk-path")
    try findSDK.launch()
    let sdkPath = try findSDK.waitUntilExit().utf8Output().trimmingCharacters(in: .newlines)
    
    var synthArgs: [String] = [
        "xcrun", "swift-synthesize-interface",
        "-I", moduleDir.path,
        "-module-name", moduleName,
        "-target", "arm64-apple-macos15",
        "-sdk", sdkPath
    ]

    for headerPath in headerPaths {
        synthArgs += ["-I", headerPath.path]
    }

    let synth = TSCBasic.Process(arguments: synthArgs, outputRedirection: .collect(redirectStderr: true))
    try synth.launch()
    let interface = try synth.waitUntilExit().utf8Output()

    return Parser.parse(source: interface)
}
