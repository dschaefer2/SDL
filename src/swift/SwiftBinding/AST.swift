import Foundation
import TSCBasic

public class ASTNode: Decodable {
    var kind: String?
    var name: String?
    var tagUsed: String?
    var type: ASTType?
    var inner: [ASTNode]?
    
    struct ASTType: Decodable {
        var qualType: String
    }
}

public func loadAST(headerPaths: [URL], headerFile: URL) throws -> ASTNode{
    var clangArgs: [String] = [
        "clang", "-Xclang", "-ast-dump=json", "-fsyntax-only",
        "-I", headerFile.deletingLastPathComponent().path
    ]

    for headerPath in headerPaths {
        clangArgs += ["-I", headerPath.path]
    }
    clangArgs += [headerFile.path]
    
    let clang = TSCBasic.Process(arguments: clangArgs, outputRedirection: .collect(redirectStderr: true))
    try clang.launch()
    let clangOutput = try Data(clang.waitUntilExit().output.get())
    return try JSONDecoder().decode(ASTNode.self, from: clangOutput)
}
