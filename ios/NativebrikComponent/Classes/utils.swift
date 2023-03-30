//
//  utils.swift
//  NativebrikComponent
//
//  Created by Ryosuke Suzuki on 2023/03/28.
//

import Foundation
import YogaKit

func parseInt(_ data: Int?) -> YGValue {
    if let integer = data {
        return YGValue(value: Float(integer), unit: .point)
    } else {
        return YGValueZero
    }
}

func parseIntForFlex(_ data: Int?) -> YGValue? {
    if let integer = data {
        return YGValue(CGFloat(integer))
    } else {
        return YGValueUndefined
    }
}

func parseDirection(_ data: FlexDirection?) -> YGFlexDirection {
    switch data {
    case .COLUMN:
        return .column
    default:
        return .row
    }
}

func parseAlignItems(_ data: AlignItems?) -> YGAlign {
    switch data {
    case .CENTER:
        return .center
    case .END:
        return .flexEnd
    case .START:
        return .flexStart
    default:
        return .center
    }
}

func parseJustifyContent(_ data: JustifyContent?) -> YGJustify {
    switch data {
    case .CENTER:
        return .center
    case .START:
        return .flexStart
    case .END:
        return .flexEnd
    case .SPACE_BETWEEN:
        return .spaceBetween
    default:
        return .center
    }
}

func parseColor(_ data: Color?) -> UIColor {
    if let color = data {
        return UIColor.init(red: CGFloat(color.red ?? 0), green: CGFloat(color.green ?? 0), blue: CGFloat(color.blue ?? 0), alpha: CGFloat(color.alpha ?? 0))
    } else {
        return UIColor.black
    }
}

func parseColorToCGColor(_ data: Color?) -> CGColor {
    switch data {
    case .none:
        return CGColor.init(gray: 0, alpha: 0)
    case .some(let color):
        return CGColor.init(red: CGFloat(color.red ?? 0), green: CGFloat(color.green ?? 0), blue: CGFloat(color.blue ?? 0), alpha: CGFloat(color.alpha ?? 0))
    }
}

func parseFontWeight(_ data: FontWeight?) -> UIFont.Weight {
    switch data {
    case .some(data):
        switch data {
        case .ULTRA_LIGHT:
            return .ultraLight
        case .THIN:
            return .thin
        case .LIGHT:
            return .light
        case .REGULAR:
            return .regular
        case .MEDIUM:
            return .medium
        case .SEMI_BOLD:
            return .semibold
        case .BOLD:
            return .bold
        case .HEAVY:
            return .heavy
        case .BLACK:
            return .black
        default:
            return .regular
        }
    default:
        return .regular
    }
}

func parseTextBlockDataToUIFont(_ data: UITextBlockData?) -> UIFont {
    switch data {
    case .none:
        return UIFont.systemFont(ofSize: 16, weight: parseFontWeight(nil))
    case .some(let text):
        return UIFont.systemFont(ofSize: CGFloat(text.size ?? 16), weight: parseFontWeight(text.weight))
    }
}

struct ImageFallback {
    let blurhash: String
    let width: Int
    let height: Int
}
func parseImageFallbackToBlurhash(_ src: String) -> ImageFallback {
    let components = src.split(separator: ",", maxSplits: 2)
    if components.count == 3, let width = Int(components[0]), let height = Int(components[1]) {
        let blurhash = String(components[2])
        return ImageFallback(blurhash: blurhash, width: width, height: height)
    } else {
        return ImageFallback(blurhash: "", width: 0, height: 0)
    }
}

func configurePadding(layout: YGLayout, frame: FrameData?) {
    layout.paddingTop = parseInt(frame?.paddingTop)
    layout.paddingLeft = parseInt(frame?.paddingLeft)
    layout.paddingRight = parseInt(frame?.paddingRight)
    layout.paddingBottom = parseInt(frame?.paddingBottom)
}

func configureSize(layout: YGLayout, frame: FrameData?) {
    if let height = frame?.height {
        if height == 0 {
            layout.height = .init(value: 100.0, unit: .percent)
            layout.minHeight = .init(value: 100.0, unit: .percent)
        } else {
            layout.height = YGValue(value: Float(height), unit: .point)
        }
    }
    if let width = frame?.width {
        if width == 0 {
            layout.width = .init(value: 100.0, unit: .percent)
            layout.minWidth = .init(value: 100.0, unit: .percent)
        } else {
            layout.width = YGValue(value: Float(width), unit: .point)
        }
    }
        
    layout.maxWidth = .init(value: 100, unit: .percent)
    layout.maxHeight = .init(value: 100, unit: .percent)
}

func configureBorder(view: UIView, frame: FrameData?) {
    view.layer.backgroundColor = parseColorToCGColor(frame?.background)
    view.layer.borderWidth = CGFloat(frame?.borderWidth ?? 0)
    view.layer.borderColor = parseColorToCGColor(frame?.borderColor)
    view.layer.cornerRadius = CGFloat(frame?.borderRadius ?? 0)
}
