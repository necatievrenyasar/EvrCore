//
//  EvrLogger.swift
//  EvrCore
//
//  Created by Evren Yaşar on 21.10.2022.
//
import Foundation
public class EvrLogger {
    
    public var shouldPrintDateFor = Level.allCases
    
    public var shouldPrintEmojiFor = Level.allCases
    
    public var shouldPrintLevelNameFor = Level.allCases
    
    public var shouldPrintSystemInfoFor: [Level] = [.warning, .error]
    
    public var levelEmojis: [Level: String] = [:]
    
    public var dateFormat = "yyyy-MM-dd HH:mm:ss" {
        didSet {
            dateFormatter.dateFormat = dateFormat
        }
    }
    
    public static var shared = EvrLogger()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    
    public init() { }
    
    @discardableResult
    public convenience init(_ items: Any) {
        self.init()
        none(items)
    }
    
    public enum Level: Int, CaseIterable {
        case debug, info, warning, error
        
        public var icon: String {
            switch self {
            case .debug: return "✏️"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            }
        }
        
        public var name: String {
            switch self {
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            }
        }
    }
    
    public func debug(_ item: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print(item, level: .debug, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    public func info(_ item: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print(item, level: .info, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    public func warning(_ item: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print(item, level: .warning, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    public func error(_ item: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print(item, level: .error, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    public func none(_ item: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        print(item, level: nil, filename: filename, line: line, column: column, funcName: funcName)
    }
    
    private func getDateDescription() -> String {
        return dateFormatter.string(from: Date())
    }
    
    private func getSourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.last ?? ""
    }
    
    private func getFormattedItem(_ item: Any, level: Level?, filename: String, line: Int, column: Int, funcName: String) -> String {
        var stringToPrint = ""
        if let level = level {
            if shouldPrintDateFor.contains(level) { stringToPrint.append(getDateDescription(), withSeparator: true) }
            if shouldPrintEmojiFor.contains(level) { stringToPrint.append(getEmojiFor(level), withSeparator: true) }
            if shouldPrintLevelNameFor.contains(level) { stringToPrint.append(level.name, withSeparator: true) }
            if shouldPrintSystemInfoFor.contains(level) {
                let systemInfo = "[\(getSourceFileName(filePath: filename))]:\(line) \(funcName) ->"
                stringToPrint.append(systemInfo, withSeparator: true)
            }
        }
        stringToPrint.append("\(item)", withSeparator: true)
        return stringToPrint
    }
    
    private func getEmojiFor(_ level: Level) -> String {
        return levelEmojis[level] ?? level.icon
    }
}

extension EvrLogger {
    func print(_ item: Any, level: Level?, filename: String, line: Int, column: Int, funcName: String) {
        #if DEBUG
        Swift.print(getFormattedItem(item, level: level, filename: filename, line: line, column: column, funcName: funcName))
        #endif
    }
}

extension String {
    mutating func append(_ other: String, withSeparator: Bool, separator: String = " ") {
        self.append(withSeparator ? (self.isEmpty ? other : separator + other) : other)
    }
}


// REFERANCE: https://github.com/Kharauzov/PureLogger/blob/master/PureLogger/Source/Log.swift
