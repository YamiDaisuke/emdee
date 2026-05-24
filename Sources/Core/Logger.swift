public enum LogLevel: String, CaseIterable, Comparable {
    case debug
    case info
    case warning
    case error

    private var order: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .warning: return 2
        case .error: return 3
        }
    }

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.order < rhs.order
    }
}

public enum LogContext {
    case webServer
    case tui
}

public struct Logger {
    private let level: LogLevel
    private let context: LogContext?

    public init(level: LogLevel, context: LogContext? = nil) {
        self.level = level
        self.context = context
    }

    public func log(_ message: String, level messageLevel: LogLevel) {
        guard context != nil, messageLevel >= self.level else { return }
        print(message)
    }
}
