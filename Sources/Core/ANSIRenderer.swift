import Markdown

public struct ANSIRenderer: MarkupVisitor {
    public typealias Result = String

    private enum ANSI {
        static let reset = "\u{1B}[0m"
        static let bold = "\u{1B}[1m"
        static let italic = "\u{1B}[3m"
        static let dim = "\u{1B}[2m"
        static let fgCyan = "\u{1B}[36m"
        static let fgYellow = "\u{1B}[33m"
        static let bgDarkGray = "\u{1B}[100m"
    }

    public init() {}

    public func render(_ document: MarkdownDocument) -> String {
        visit(document.document)
    }

    public func defaultVisit(_ markup: any Markup) -> String {
        markup.children.map { visit($0) }.joined()
    }

    public func visitDocument(_ document: Document) -> String {
        document.children.map { visit($0) }.joined(separator: "\n")
    }

    public func visitHeading(_ heading: Heading) -> String {
        let text = heading.children.map { visit($0) }.joined()
        let prefix = String(repeating: "#", count: heading.level)
        switch heading.level {
        case 1:
            return "\(ANSI.bold)\(ANSI.fgYellow)\(prefix) \(text)\(ANSI.reset)"
        case 2:
            return "\(ANSI.bold)\(prefix) \(text)\(ANSI.reset)"
        case 3:
            return "\(ANSI.bold)\(prefix) \(text)\(ANSI.reset)"
        default:
            return "\(ANSI.dim)\(ANSI.bold)\(prefix) \(text)\(ANSI.reset)"
        }
    }

    public func visitParagraph(_ paragraph: Paragraph) -> String {
        paragraph.children.map { visit($0) }.joined()
    }

    public func visitText(_ text: Text) -> String {
        text.string
    }

    public func visitStrong(_ strong: Strong) -> String {
        "\(ANSI.bold)\(strong.children.map { visit($0) }.joined())\(ANSI.reset)"
    }

    public func visitEmphasis(_ emphasis: Emphasis) -> String {
        "\(ANSI.italic)\(emphasis.children.map { visit($0) }.joined())\(ANSI.reset)"
    }

    public func visitInlineCode(_ inlineCode: InlineCode) -> String {
        "\(ANSI.bgDarkGray)\(ANSI.fgCyan)\(inlineCode.code)\(ANSI.reset)"
    }

    public func visitCodeBlock(_ codeBlock: CodeBlock) -> String {
        let code = codeBlock.code.hasSuffix("\n")
            ? String(codeBlock.code.dropLast())
            : codeBlock.code
        return code.components(separatedBy: "\n")
            .map { "\(ANSI.fgCyan)\($0)\(ANSI.reset)" }
            .joined(separator: "\n")
    }

    public func visitBlockQuote(_ blockQuote: BlockQuote) -> String {
        let inner = blockQuote.children.map { visit($0) }.joined(separator: "\n")
        return inner.components(separatedBy: "\n")
            .map { "\(ANSI.dim)│\(ANSI.reset) \($0)" }
            .joined(separator: "\n")
    }

    public func visitUnorderedList(_ unorderedList: UnorderedList) -> String {
        unorderedList.children.map { item -> String in
            let text = item.children.map { visit($0) }.joined()
            return "  • \(text)"
        }.joined(separator: "\n")
    }

    public func visitOrderedList(_ orderedList: OrderedList) -> String {
        orderedList.children.enumerated().map { index, item -> String in
            let text = item.children.map { visit($0) }.joined()
            return "  \(index + 1). \(text)"
        }.joined(separator: "\n")
    }

    public func visitListItem(_ listItem: ListItem) -> String {
        listItem.children.map { visit($0) }.joined()
    }

    public func visitSoftBreak(_ softBreak: SoftBreak) -> String {
        "\n"
    }

    public func visitLineBreak(_ lineBreak: LineBreak) -> String {
        "\n"
    }

    public func visitThematicBreak(_ thematicBreak: ThematicBreak) -> String {
        String(repeating: "─", count: 40)
    }
}
