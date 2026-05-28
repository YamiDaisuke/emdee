import Testing
import Foundation
@testable import Core

struct LoggerTests {
    @Test func belowLevelMessageNotEmitted() {
        var logger = Logger(level: .warning, context: .webServer)
        var captured = ""
        logger.outputWriter = { captured = $0 }
        logger.log("suppressed", level: .debug)
        #expect(captured.isEmpty)
    }

    @Test func noContextProducesNoOutput() {
        var logger = Logger(level: .debug)
        var captured = ""
        logger.outputWriter = { captured = $0 }
        logger.log("silent", level: .error)
        #expect(captured.isEmpty)
    }

    @Test func webServerContextEmitsStructuredLine() {
        var logger = Logger(level: .warning, context: .webServer)
        var captured = ""
        logger.outputWriter = { captured = $0 }
        logger.log("hello web", level: .warning)
        #expect(captured.contains("[WARNING]"))
        #expect(captured.contains("[webServer]"))
        #expect(captured.contains("hello web"))
        #expect(captured.contains(".swift:"))
        #expect(captured.contains("webServerContextEmitsStructuredLine"))
        #expect(captured.contains("T") && captured.contains("Z"))
    }

    @Test func tuiContextEmitsStructuredLine() {
        var logger = Logger(level: .debug, context: .tui)
        var captured = ""
        logger.outputWriter = { captured = $0 }
        logger.log("hello tui", level: .info)
        #expect(captured.contains("[INFO]"))
        #expect(captured.contains("[tui]"))
        #expect(captured.contains("hello tui"))
        #expect(captured.contains(".swift:"))
        #expect(captured.contains("tuiContextEmitsStructuredLine"))
        #expect(captured.contains("T") && captured.contains("Z"))
    }
}
