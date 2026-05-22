// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "emdee",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/rensbreur/SwiftTUI.git", from: "0.1.0"),
        .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.6.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
    ],
    targets: [
        .executableTarget(
            name: "emdee",
            dependencies: ["Core", "TUIRenderer", "WebRenderer"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "TUIRenderer",
            dependencies: [
                "Core",
                .product(name: "SwiftTUI", package: "SwiftTUI"),
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "WebRenderer",
            dependencies: ["Core"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "TUIRendererTests",
            dependencies: ["TUIRenderer"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "WebRendererTests",
            dependencies: ["WebRenderer"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
