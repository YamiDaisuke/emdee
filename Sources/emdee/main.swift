import Foundation
import Core
import TUIRenderer
import WebRenderer

// MARK: - Types

enum Mode {
    case tui
    case web
}

struct ParsedArguments {
    let path: String
    let mode: Mode
    let logLevel: LogLevel
}

// MARK: - Argument Parsing

func printUsage() {
    fputs("Usage: emdee [--web] [--log-level <level>] <path>\n", stderr)
    fputs("  <path>        Path to a .md file or a folder\n", stderr)
    fputs("  --web         Use web rendering mode (default: TUI)\n", stderr)
    let levels = LogLevel.allCases.map { $0.rawValue }.joined(separator: ", ")
    fputs("  --log-level   Log level: \(levels) (default: error)\n", stderr)
}

func parseArguments(_ args: [String]) -> ParsedArguments {
    var remaining = args
    var webFlag = false
    var logLevel: LogLevel = .error
    var pathArg: String?

    while !remaining.isEmpty {
        let arg = remaining.removeFirst()

        if arg == "--web" {
            webFlag = true
        } else if arg == "--log-level" {
            guard !remaining.isEmpty else {
                fputs("Error: --log-level requires a value.\n", stderr)
                printUsage()
                exit(1)
            }
            let levelString = remaining.removeFirst()
            guard let level = LogLevel(rawValue: levelString) else {
                let levels = LogLevel.allCases.map { $0.rawValue }.joined(separator: ", ")
                fputs("Error: invalid log level '\(levelString)'. Valid values: \(levels).\n", stderr)
                printUsage()
                exit(1)
            }
            logLevel = level
        } else if arg.hasPrefix("--") {
            fputs("Error: unknown flag '\(arg)'.\n", stderr)
            printUsage()
            exit(1)
        } else {
            if pathArg != nil {
                fputs("Error: unexpected extra argument '\(arg)'.\n", stderr)
                printUsage()
                exit(1)
            }
            pathArg = arg
        }
    }

    guard let rawPath = pathArg else {
        fputs("Error: a path argument is required.\n", stderr)
        printUsage()
        exit(1)
    }

    let resolvedPath = URL(fileURLWithPath: rawPath).standardized.path
    let mode: Mode = webFlag ? .web : .tui
    return ParsedArguments(path: resolvedPath, mode: mode, logLevel: logLevel)
}

// MARK: - Main

let commandArgs = Array(CommandLine.arguments.dropFirst())

if commandArgs.isEmpty {
    fputs("Error: a path argument is required.\n", stderr)
    printUsage()
    exit(1)
}

let parsed = parseArguments(commandArgs)

let logContext: LogContext = parsed.mode == .web ? .webServer : .tui
let logger = Logger(level: parsed.logLevel, context: logContext)

switch parsed.mode {
case .tui:
    _ = TUIRenderer(logger: logger)
case .web:
    _ = WebRenderer(logger: logger)
}

let fileManager = FileManager.default
var isDirectory: ObjCBool = false
_ = fileManager.fileExists(atPath: parsed.path, isDirectory: &isDirectory)

let pathKind: String
if isDirectory.boolValue {
    pathKind = "folder"
} else {
    pathKind = "single file"
}

let modeName: String
switch parsed.mode {
case .tui:
    modeName = "TUI"
case .web:
    modeName = "web"
}

print("Path: \(parsed.path)")
print("Mode: \(pathKind), \(modeName)")
print("Log level: \(parsed.logLevel.rawValue)")
