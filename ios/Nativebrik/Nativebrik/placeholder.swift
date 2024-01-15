//
//  placeholder.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2023/03/29.
//

import Foundation

struct TemplatePlaceholder {
    let path: String
    let formatter: String
}

func getPlaceholderRegex() -> NSRegularExpression? {
    return try? NSRegularExpression(pattern: "\\{\\{[a-zA-Z0-9_\\.-| ]{1,300}\\}\\}", options: .dotMatchesLineSeparators)
}

func isPlaceholder(value: String) -> Bool {
    return getPlaceholderRegex()?.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count)) != nil
}

func getPlaceholder(placeholder: String) -> TemplatePlaceholder? {
    guard isPlaceholder(value: placeholder) else {
        return nil
    }
    let rawIdentifiers = placeholder.dropFirst(2).dropLast(2)
    let identifiers = rawIdentifiers.split(separator: "|")
    
    var path = ""
    if identifiers.count >= 1 {
        path = String(identifiers[0]).trimmingCharacters(in: CharacterSet([" "]))
    }
    
    var formatter: String = ""
    if identifiers.count >= 2 {
        formatter = String(identifiers[1]).trimmingCharacters(in: CharacterSet([" "]))
    }
    return TemplatePlaceholder(path: path, formatter: formatter)
}

func defaultFormatter(_ value: Any?) -> String {
    return value.flatMap({ String.init(describing: $0 )}) ?? ""
}

func jsonFormatter(_ value: Any?) -> String {
    do {
        guard let value = value else {
            return ""
        }
        let jsonData = try JSONSerialization.data(withJSONObject: value)
        return String(decoding: jsonData, as: UTF8.self)
    } catch {
        return defaultFormatter(value)
    }
}

func uppercaseFormatter(_ value: Any?) -> String {
    let str = defaultFormatter(value)
    return str.uppercased()
}

func lowercaseFormatter(_ value: Any?) -> String {
    let str = defaultFormatter(value)
    return str.lowercased()
}

func hasPlaceholderPath(template: String) -> Bool {
    guard let regex = getPlaceholderRegex() else {
        return false
    }
    let templateAsNsstring = template as NSString
    return regex.numberOfMatches(in: template, range: NSRange(location: 0, length: templateAsNsstring.length)) > 0
}

func compileTemplate(template: String, getByPath: (String) -> Any?) -> String {
    guard let regex = getPlaceholderRegex() else {
        return template
    }
    var result = template as NSString
    for _ in 1...20 { // not to loop infinitly, limit to the 20 loops at maximum.
        // search the first matched {{palceholder}}, and replace it by a value.
        let range = NSRange(location: 0, length: result.length)
        guard let match = regex.firstMatch(in: result as String, range: range) else {
            break
        }
        let rawPlaceholder = result.substring(with: match.range)
        guard let placeholder = getPlaceholder(placeholder: rawPlaceholder) else {
            break
        }
        if placeholder.path == "" {
            break
        }
        let value = getByPath(placeholder.path)
        
        // format value when the placeholer is like {{ path | formatter }}
        var valueStr = ""
        switch placeholder.formatter {
        case "json":
            valueStr = jsonFormatter(value)
            break
        case "upper":
            valueStr = uppercaseFormatter(value)
            break
        case "lower":
            valueStr = lowercaseFormatter(value)
            break
        default:
            valueStr = defaultFormatter(value)
            break
        }
        
        result = result.replacingOccurrences(of: rawPlaceholder, with: valueStr) as NSString
    }
    return result as String
}

