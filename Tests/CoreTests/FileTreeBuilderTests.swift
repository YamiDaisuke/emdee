import Testing
import Foundation
@testable import Core

struct FileTreeBuilderTests {

    private func makeTempDir() throws -> URL {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        return temp
    }

    private func touch(_ url: URL) throws {
        try FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        FileManager.default.createFile(atPath: url.path, contents: nil)
    }

    @Test func multiLevelTreeMirrorsDirectoryStructure() throws {
        let root = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: root) }

        try touch(root.appendingPathComponent("a.md"))
        try touch(root.appendingPathComponent("docs/b.md"))
        try touch(root.appendingPathComponent("docs/sub/c.md"))
        try touch(root.appendingPathComponent("z.md"))

        let tree = try buildFileTree(at: root)

        guard case .directory(_, _, let children) = tree else {
            Issue.record("root should be a directory node"); return
        }
        #expect(children.count == 3)

        guard case .directory(let docsName, _, let docsChildren) = children[0] else {
            Issue.record("first child should be the docs directory"); return
        }
        #expect(docsName == "docs")
        #expect(docsChildren.count == 2)

        guard case .directory(let subName, _, let subChildren) = docsChildren[0] else {
            Issue.record("first docs child should be sub directory"); return
        }
        #expect(subName == "sub")
        #expect(subChildren.count == 1)

        guard case .file(let cName, _) = subChildren[0] else {
            Issue.record("sub child should be c.md"); return
        }
        #expect(cName == "c.md")

        guard case .file(let bName, _) = docsChildren[1] else {
            Issue.record("second docs child should be b.md"); return
        }
        #expect(bName == "b.md")

        guard case .file(let aName, _) = children[1],
              case .file(let zName, _) = children[2] else {
            Issue.record("remaining root children should be a.md and z.md"); return
        }
        #expect(aName == "a.md")
        #expect(zName == "z.md")
    }

    @Test func rootFilesAppearDirectlyUnderRoot() throws {
        let root = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: root) }

        try touch(root.appendingPathComponent("readme.md"))

        let tree = try buildFileTree(at: root)

        guard case .directory(_, _, let children) = tree else {
            Issue.record("should be a directory node"); return
        }
        #expect(children.count == 1)
        guard case .file(let name, _) = children[0] else {
            Issue.record("child should be a file node"); return
        }
        #expect(name == "readme.md")
    }

    @Test func directoriesAppearBeforeFilesRegardlessOfAlphaOrder() throws {
        let root = try makeTempDir()
        defer { try? FileManager.default.removeItem(at: root) }

        // 'a.md' sorts before 'zzz/' alphabetically, but directory must come first
        try touch(root.appendingPathComponent("a.md"))
        try touch(root.appendingPathComponent("zzz/z.md"))

        let tree = try buildFileTree(at: root)

        guard case .directory(_, _, let children) = tree else {
            Issue.record("should be a directory node"); return
        }
        #expect(children.count == 2)
        guard case .directory = children[0] else {
            Issue.record("directory zzz must appear before file a.md"); return
        }
    }
}
