import Foundation

public enum DiscoveryError: Error {
    case notADirectory(URL)
}

public func discoverMarkdownFiles(in directoryURL: URL) throws -> [URL] {
    var isDirectory: ObjCBool = false
    guard FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory),
          isDirectory.boolValue else {
        throw DiscoveryError.notADirectory(directoryURL)
    }

    let enumerator = FileManager.default.enumerator(
        at: directoryURL,
        includingPropertiesForKeys: [.isDirectoryKey],
        options: [.skipsHiddenFiles]
    )

    var results: [URL] = []
    while let url = enumerator?.nextObject() as? URL {
        let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
        if values?.isDirectory == false, url.pathExtension == "md" {
            results.append(url)
        }
    }

    return results.sorted { $0.path < $1.path }
}
