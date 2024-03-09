//
//  formatter.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2024/03/07.
//

import Foundation

fileprivate func defaultFormatter(_ value: Any?) -> String {
    return value.flatMap({ String.init(describing: $0 )}) ?? ""
}

fileprivate func jsonFormatter(_ value: Any?) -> String {
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

fileprivate func uppercaseFormatter(_ value: Any?) -> String {
    let str = defaultFormatter(value)
    return str.uppercased()
}

fileprivate func lowercaseFormatter(_ value: Any?) -> String {
    let str = defaultFormatter(value)
    return str.lowercased()
}

func formatValue(formatter: String, value: Any?) -> String {
    switch (formatter) {
    case "json":
        return jsonFormatter(value)
    case "upper":
        return uppercaseFormatter(value)
    case "lower":
        return lowercaseFormatter(value)
    default:
        return defaultFormatter(value)
    }
}
