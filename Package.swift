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
    ],
    targets: [
        .executableTarget(
            name: "emdee",
            dependencies: ["Core", "TUIRenderer", "WebRenderer"]
        ),
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
            ]
        ),
        .target(
            name: "TUIRenderer",
            dependencies: [
                "Core",
                .product(name: "SwiftTUI", package: "SwiftTUI"),
            ]
        ),
        .target(
            name: "WebRenderer",
            dependencies: ["Core"]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        ),
        .testTarget(
            name: "TUIRendererTests",
            dependencies: ["TUIRenderer"]
        ),
        .testTarget(
            name: "WebRendererTests",
            dependencies: ["WebRenderer"]
        ),
    ]
)
