import PackagePlugin

@main
struct SDLGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        // Return an empty array of commands.
        return []
    }
}

