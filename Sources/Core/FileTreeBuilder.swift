import Foundation

public func buildFileTree(at directoryURL: URL) throws -> FileNode {
    let files = try discoverMarkdownFiles(in: directoryURL)
    return buildNode(at: directoryURL, from: files)
}

private func buildNode(at url: URL, from files: [URL]) -> FileNode {
    let urlPath = url.path

    let directFiles = files.filter {
        $0.deletingLastPathComponent().path == urlPath
    }

    var seenSubdirPaths = Set<String>()
    for file in files where file.deletingLastPathComponent().path != urlPath {
        var current = file.deletingLastPathComponent()
        while current.deletingLastPathComponent().path != urlPath {
            current = current.deletingLastPathComponent()
        }
        seenSubdirPaths.insert(current.path)
    }

    let subdirURLs = seenSubdirPaths.sorted().map { URL(fileURLWithPath: $0) }

    var children: [FileNode] = []
    for subdirURL in subdirURLs {
        let subdirFiles = files.filter { $0.path.hasPrefix(subdirURL.path + "/") }
        children.append(buildNode(at: subdirURL, from: subdirFiles))
    }
    for file in directFiles {
        children.append(.file(name: file.lastPathComponent, path: file))
    }

    return .directory(name: url.lastPathComponent, path: url, children: children)
}
