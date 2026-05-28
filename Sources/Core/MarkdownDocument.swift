import Foundation
import Markdown

public struct MarkdownDocument {
    public let source: URL?
    public let document: Document

    public init(path: URL) throws {
        let text = try String(contentsOf: path, encoding: .utf8)
        self.source = path
        self.document = Document(parsing: text)
    }

    public init(string: String) {
        self.source = nil
        self.document = Document(parsing: string)
    }
}
