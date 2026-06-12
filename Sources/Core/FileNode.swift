import Foundation

public indirect enum FileNode: Equatable, Identifiable {
    case file(name: String, path: URL)
    case directory(name: String, path: URL, children: [FileNode])

    public var id: URL { path }

    public var name: String {
        switch self {
        case .file(let name, _): return name
        case .directory(let name, _, _): return name
        }
    }

    public var path: URL {
        switch self {
        case .file(_, let path): return path
        case .directory(_, let path, _): return path
        }
    }
}
