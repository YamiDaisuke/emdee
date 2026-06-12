import Core
import Foundation

public struct TUIRenderer {
    private let logger: Logger

    public init(logger: Logger) {
        self.logger = logger
    }

    public func renderFile(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        let document = try MarkdownDocument(path: url)
        let rendered = ANSIRenderer().render(document)
        print(rendered)
        logger.log("Rendered \(path)", level: .info)
    }
}
