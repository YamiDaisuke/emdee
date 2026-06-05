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

    private func plainText(from markup: any Markup) -> String {
        if let text = markup as? Text {
            return text.string
        }
        return markup.children.map { plainText(from: $0) }.joined()
    }

    public func render(_ document: MarkdownDocument) -> String {
        var renderer = self
        return renderer.visit(document.document)
    }

    public mutating func defaultVisit(_ markup: any Markup) -> String {
        var results: [String] = []
        for child in markup.children {
            results.append(visit(child))
        }
        return results.joined()
    }

    public mutating func visitDocument(_ document: Document) -> String {
        var results: [String] = []
        for child in document.children {
            results.append(visit(child))
        }
        return results.joined(separator: "\n")
    }

    public mutating func visitHeading(_ heading: Heading) -> String {
        var results: [String] = []
        for child in heading.children {
            results.append(visit(child))
        }
        let text = results.joined()
        let prefix = String(repeating: "#", count: heading.level)
        switch heading.level {
        case 1:
            return "\(ANSI.bold)\(ANSI.fgYellow)\(prefix) \(text)\(ANSI.reset)"
        case 2:
            return "\(ANSI.bold)\(prefix) \(text)\(ANSI.reset)"
        case 3:
            return "\(ANSI.bold)\(ANSI.fgCyan)\(prefix) \(text)\(ANSI.reset)"
        default:
            return "\(ANSI.dim)\(ANSI.bold)\(prefix) \(text)\(ANSI.reset)"
        }
    }

    public mutating func visitParagraph(_ paragraph: Paragraph) -> String {
        var results: [String] = []
        for child in paragraph.children {
            results.append(visit(child))
        }
        return results.joined()
    }

    public mutating func visitText(_ text: Text) -> String {
        text.string
    }

    public mutating func visitStrong(_ strong: Strong) -> String {
        var results: [String] = []
        for child in strong.children {
            results.append(visit(child))
        }
        return "\(ANSI.bold)\(results.joined())\(ANSI.reset)"
    }

    public mutating func visitEmphasis(_ emphasis: Emphasis) -> String {
        var results: [String] = []
        for child in emphasis.children {
            results.append(visit(child))
        }
        return "\(ANSI.italic)\(results.joined())\(ANSI.reset)"
    }

    public mutating func visitInlineCode(_ inlineCode: InlineCode) -> String {
        "\(ANSI.bgDarkGray)\(ANSI.fgCyan)\(inlineCode.code)\(ANSI.reset)"
    }

    public mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> String {
        let code = codeBlock.code.hasSuffix("\n")
            ? String(codeBlock.code.dropLast())
            : codeBlock.code
        return code.components(separatedBy: "\n")
            .map { "\(ANSI.fgCyan)\($0)\(ANSI.reset)" }
            .joined(separator: "\n")
    }

    public mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> String {
        var results: [String] = []
        for child in blockQuote.children {
            results.append(visit(child))
        }
        let inner = results.joined(separator: "\n")
        return inner.components(separatedBy: "\n")
            .map { "\(ANSI.dim)│\(ANSI.reset) \($0)" }
            .joined(separator: "\n")
    }

    public mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> String {
        var items: [String] = []
        for item in unorderedList.children {
            var childResults: [String] = []
            for child in item.children {
                childResults.append(visit(child))
            }
            items.append("  • \(childResults.joined())")
        }
        return items.joined(separator: "\n")
    }

    public mutating func visitOrderedList(_ orderedList: OrderedList) -> String {
        var items: [String] = []
        var index = 1
        for item in orderedList.children {
            var childResults: [String] = []
            for child in item.children {
                childResults.append(visit(child))
            }
            items.append("  \(index). \(childResults.joined())")
            index += 1
        }
        return items.joined(separator: "\n")
    }

    public mutating func visitTable(_ table: Table) -> String {
        let headRows = table.head.children.compactMap { $0 as? Table.Row }
        let bodyRows = table.body.children.compactMap { $0 as? Table.Row }
        let allRows = headRows + bodyRows
        guard !allRows.isEmpty else { return "" }

        let cellTexts: [[String]] = allRows.map { row in
            row.children.compactMap { $0 as? Table.Cell }.map { plainText(from: $0) }
        }
        let columnWidths = computeColumnWidths(from: cellTexts)
        guard !columnWidths.isEmpty else { return "" }

        var lines: [String] = []
        lines.append(tableSeparator(columnWidths: columnWidths, left: "┌", mid: "┬", right: "┐"))
        for rowIdx in headRows.indices {
            lines.append(tableRow(cellTexts[rowIdx], columnWidths: columnWidths, bold: true))
        }
        if !headRows.isEmpty {
            lines.append(tableSeparator(columnWidths: columnWidths, left: "├", mid: "┼", right: "┤"))
        }
        let headCount = headRows.count
        for rowIdx in bodyRows.indices {
            lines.append(tableRow(cellTexts[headCount + rowIdx], columnWidths: columnWidths, bold: false))
        }
        lines.append(tableSeparator(columnWidths: columnWidths, left: "└", mid: "┴", right: "┘"))
        return lines.joined(separator: "\n")
    }

    private func computeColumnWidths(from cellTexts: [[String]]) -> [Int] {
        let columnCount = cellTexts.map(\.count).max() ?? 0
        guard columnCount > 0 else { return [] }
        var widths = Array(repeating: 0, count: columnCount)
        for row in cellTexts {
            for (idx, text) in row.enumerated() where idx < columnCount {
                widths[idx] = max(widths[idx], text.count)
            }
        }
        return widths
    }

    private func tableSeparator(columnWidths: [Int], left: String, mid: String, right: String) -> String {
        let inner = columnWidths.map { String(repeating: "─", count: $0 + 2) }.joined(separator: mid)
        let line = left + inner + right
        return line.count > 80 ? String(line.prefix(80)) : line
    }

    private func tableRow(_ cells: [String], columnWidths: [Int], bold: Bool) -> String {
        let parts = columnWidths.indices.map { idx -> String in
            let text = idx < cells.count ? cells[idx] : ""
            let padded = text + String(repeating: " ", count: max(0, columnWidths[idx] - text.count))
            return bold ? " \(ANSI.bold)\(padded)\(ANSI.reset) " : " \(padded) "
        }
        let line = "│" + parts.joined(separator: "│") + "│"
        return line.count > 80 ? String(line.prefix(80)) : line
    }

    public mutating func visitSoftBreak(_ softBreak: SoftBreak) -> String {
        "\n"
    }

    public mutating func visitLineBreak(_ lineBreak: LineBreak) -> String {
        "\n"
    }

    public mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> String {
        String(repeating: "─", count: 40)
    }
}
