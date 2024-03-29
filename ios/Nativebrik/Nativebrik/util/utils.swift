//
//  utils.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2023/03/28.
//

import Foundation
import YogaKit
import UIKit

func presentOnTop(window: UIWindow?, modal: UIViewController) {
    guard let root = window?.rootViewController else {
        return
    }
    guard let presented = root.presentedViewController else {
        root.present(modal, animated: true)
        return
    }
    presented.present(modal, animated: true)
}

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

func parseOverflow(_ data: Overflow?) -> YGOverflow {
    switch data {
    case .HIDDEN:
        return .hidden
    case .SCROLL:
        return .scroll
    case .VISIBLE:
        return .visible
    default:
        return .visible
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

func parseFontDesign(_ data: FontDesign?) -> UIFontDescriptor.SystemDesign {
    switch data {
    case .MONOSPACE:
        return .monospaced
    case .ROUNDED:
        return .rounded
    case .SERIF:
        return .serif
    default:
        return .default
    }
}

func parseTextBlockDataToUIFont(_ size: Int?, _ weight: FontWeight?, _ design: FontDesign?) -> UIFont {
    let size = CGFloat(size ?? 16)
    let systemFont = UIFont.systemFont(ofSize: size, weight: parseFontWeight(weight))
    let font: UIFont
    if let descriptor = systemFont.fontDescriptor.withDesign(parseFontDesign(design)) {
        font = UIFont(descriptor: descriptor, size: size)
    } else {
        font = systemFont
    }
    return font
}

func parseFrameDataToUIKitUIEdgeInsets(_ data: FrameData?) -> UIEdgeInsets {
    return UIEdgeInsets(
        top: CGFloat(data?.paddingTop ?? 0),
        left: CGFloat(data?.paddingLeft ?? 0),
        bottom: CGFloat(data?.paddingBottom ?? 0),
        right: CGFloat(data?.paddingRight ?? 0)
    )
}

func parseModalPresentationStyle(_ data: ModalPresentationStyle?) -> UIModalPresentationStyle {
    switch data {
    case .DEPENDS_ON_CONTEXT_OR_PAGE_SHEET:
        return .pageSheet
    default:
        return .overFullScreen
    }
}

@available(iOS 15.0, *)
func parseModalScreenSize(_ data: ModalScreenSize?) -> [UISheetPresentationController.Detent] {
    switch data {
    case .MEDIUM:
        return [.medium()]
    case .LARGE:
        return [.large()]
    default:
        return [.medium(), .large()]
    }
}

func parseTextAlign(_ data: TextAlign?) -> NSTextAlignment {
    switch data {
    case .LEFT:
        return .left
    case .CENTER:
        return .center
    case .RIGHT:
        return .right
    default:
        return .natural
    }
}

func parseTextAlignToHorizontalAlignment(_ data: TextAlign?) -> UIControl.ContentHorizontalAlignment {
    switch data {
    case .LEFT:
        return .left
    case .CENTER:
        return .center
    case .RIGHT:
        return .right
    default:
        return .left
    }
}

func parserKeyboardType(_ data: UITextInputKeyboardType?) -> UIKeyboardType {
    switch data {
    case .ALPHABET:
        return .alphabet
    case .ASCII:
        return .asciiCapable
    case .DECIMAL:
        return .decimalPad
    case .NUMBER:
        return .numberPad
    case .URI:
        return .URL
    case .EMAIL:
        return .emailAddress
    default:
        return .default
    }
}

func parseImageContentMode(_ data: ImageContentMode?) -> UIView.ContentMode {
    switch data {
    case .FIT:
        return .scaleAspectFit
    default:
        return .scaleAspectFill
    }
}

struct ImageFallback {
    let blurhash: String
    let width: Int
    let height: Int
}
func parseImageFallbackToBlurhash(_ src: String) -> ImageFallback {
    guard let url = URL(string: src) else {
        return ImageFallback(blurhash: "", width: 0, height: 0)
    }

    let width = url.value(for: "w")
    let height = url.value(for: "h")
    let blurhash = url.value(for: "b")

    if let width = width, let height = height, let blurhash = blurhash {
        return ImageFallback(blurhash: blurhash, width: Int(width) ?? 0, height: Int(height) ?? 0)
    } else {
        return ImageFallback(blurhash: "", width: 0, height: 0)
    }
}

extension URL {
    func value(for parameter: String) -> String? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return nil
        }

        return components.queryItems?.first(where: { $0.name == parameter })?.value
    }
}


func configurePadding(layout: YGLayout, frame: FrameData?) {
    layout.paddingTop = parseInt(frame?.paddingTop)
    layout.paddingLeft = parseInt(frame?.paddingLeft)
    layout.paddingRight = parseInt(frame?.paddingRight)
    layout.paddingBottom = parseInt(frame?.paddingBottom)
}

func configureSize(layout: YGLayout, frame: FrameData?, parentDirection: FlexDirection?) {
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
    layout.flexShrink = 0.0

    if parentDirection == FlexDirection.ROW && frame?.width == 0 {
        layout.width = YGValueAuto
        layout.minWidth = YGValueUndefined
        layout.flexGrow = 1.0
        layout.flexShrink = 1.0
    }

    if parentDirection == FlexDirection.COLUMN && frame?.height == 0 {
        layout.height = YGValueAuto
        layout.minHeight = YGValueUndefined
        layout.flexGrow = 1.0
        layout.flexShrink = 1.0
    }
}

func configureBorder(view: UIView, frame: FrameData?) {
    if let bg = frame?.background {
        view.layer.backgroundColor = parseColorToCGColor(bg)
    }
    view.layer.borderWidth = CGFloat(frame?.borderWidth ?? 0)
    if let bc = frame?.borderColor {
        view.layer.borderColor = parseColorToCGColor(bc)
    }
    view.layer.cornerRadius = CGFloat(frame?.borderRadius ?? 0)
}

func configureShadow(view: UIView, shadow: BoxShadow?) {
    if let shadow = shadow {
        view.layer.shadowColor = parseColorToCGColor(shadow.color)
        view.layer.shadowOffset = CGSize(width: shadow.offsetX ?? 0, height: shadow.offsetY ?? 0)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = CGFloat(shadow.radius ?? 0)
        view.layer.shouldRasterize = true
        view.layer.shadowPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 8).cgPath
    }
}

func configureSkelton(view: UIView, showSkelton: Bool) {
    if showSkelton == false {
        return
    }
    let gray = 0.5
    let alpha = 0.3
    view.layer.backgroundColor = .init(gray: gray, alpha: alpha)
    UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [.repeat, .calculationModeCubicPaced, .allowUserInteraction]) {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0) {
            view.layer.backgroundColor = .init(gray: gray, alpha: alpha)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            view.layer.backgroundColor = .init(gray: gray, alpha: alpha * 0.7)
        }
        UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.5) {
            view.layer.backgroundColor = .init(gray: gray, alpha: alpha)
        }
    }
}

func configureSkeltonText(view: UILabel, showSkelton: Bool) {
    if showSkelton == false {
        return
    }
    let text = view.text ?? ""
    if text.lengthOfBytes(using: .utf8) < 2 {
        view.text = "TRANSPARENT"
    }

    view.textColor = .init(white: 0, alpha: 0)
}
