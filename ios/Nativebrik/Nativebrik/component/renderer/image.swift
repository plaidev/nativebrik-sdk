//
//  image.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2023/03/28.
//

import Foundation
import UIKit
import YogaKit

class ImageView: AnimatedUIControl {
    private let image: UIImageView = UIImageView()
    private var block: UIImageBlock = UIImageBlock()
    private var context: UIBlockContext?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(block: UIImageBlock, context: UIBlockContext) {
        super.init(frame: .zero)
        self.block = block
        self.context = context

        let showSkelton = context.isLoading() && hasPlaceholderPath(template: block.data?.src ?? "")

        self.configureLayout { layout in
            layout.isEnabled = true

            configurePadding(layout: layout, frame: block.data?.frame)
            configureSize(layout: layout, frame: block.data?.frame, parentDirection: context.getParentDireciton())

            configureSkelton(view: self, showSkelton: showSkelton)
        }

        let compiledSrc = compile(block.data?.src ?? "", context.getVariable())

        let fallbackSetting = parseImageFallbackToBlurhash(compiledSrc)
        let fallback = fallbackSetting.blurhash == "" ? UIImage() : UIImage(
            blurHash: fallbackSetting.blurhash,
            size: CGSize(width: CGFloat(fallbackSetting.width), height: CGFloat(fallbackSetting.height))
        )
        self.image.image = fallback
        self.image.configureLayout { layout in
            layout.isEnabled = true

            layout.maxWidth = 100%
            layout.maxHeight = 100%
            layout.width = 100%
            layout.height = 100%
            layout.minWidth = 100%
            layout.minHeight = 100%
        }
        self.image.contentMode = parseImageContentMode(block.data?.contentMode)
        self.image.clipsToBounds = true
        self.layer.masksToBounds = true

        self.addSubview(self.image)

        _ = configureOnClickGesture(
            target: self,
            action: #selector(onClicked(sender:)),
            context: context,
            event: block.data?.onClick
        )

        loadAsyncImage(url: compiledSrc, view: self, image: self.image)
        
        let handleDisabled = configureDisabled(target: self, context: context, requiredFields: block.data?.onClick?.requiredFields)
        
        guard let id = block.id, let handleDisabled = handleDisabled else {
            return
        }
        context.addFormValueListener(id, { values in
            handleDisabled(values)
        })
    }
    
    deinit {
        self.context?.removeFormValueListener(self.block.id ?? "")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureBorder(view: self, frame: self.block.data?.frame)
    }
}

func loadAsyncImageToBackgroundSrc(url: String, view: UIView) {
    guard let requestUrl = URL(string: url) else {
        return
    }
    
    let fallbackSetting = parseImageFallbackToBlurhash(url)
    let fallback = fallbackSetting.blurhash == "" ? UIImage() : UIImage(
        blurHash: fallbackSetting.blurhash,
        size: CGSize(width: CGFloat(fallbackSetting.width), height: CGFloat(fallbackSetting.height))
    )
    
    if let fallback = fallback {
        view.layer.contents = fallback.cgImage
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
    }
    
    nativebrikSession.dataTask(with: requestUrl) { (data, response, error) in
        if error != nil {
            return
        }

        DispatchQueue.main.async {
            if let imageData = data {
                if isGif(response) {
                    guard let image = UIImage.gifImageWithData(imageData) else {
                        return
                    }
                    UIView.transition(
                        with: view,
                        duration: 0.2,
                        options: .transitionCrossDissolve) {
                            view.layer.contents = image.cgImage
                            view.contentMode = UIView.ContentMode.scaleAspectFill
                            view.clipsToBounds = true
                        }
                } else {
                    guard let image = UIImage(data: imageData) else {
                        return
                    }
                    UIView.transition(
                        with: view,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations: {
                            view.layer.contents = image.cgImage
                            view.contentMode = UIView.ContentMode.scaleAspectFill
                            view.clipsToBounds = true
                        },
                        completion: nil)
                }
                view.layoutSubviews()
            }
        }
    }.resume()
}

func loadAsyncImage(url: String, view: UIView, image: UIImageView) {
    guard let requestUrl = URL(string: url) else {
        return
    }
    nativebrikSession.dataTask(with: requestUrl) { (data, response, error) in
        DispatchQueue.main.async {
            if error != nil {
                return
            }
            
            if let imageData = data {
                if isGif(response) {
                    UIView.transition(
                        with: image,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations: {
                            image.image = UIImage.gifImageWithData(imageData)
                        },
                        completion: nil)
                } else {
                    UIView.transition(
                        with: image,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations: {
                            image.image = UIImage(data: imageData)
                        },
                        completion: nil)
                }
                view.layoutSubviews()
            } else {
                return
            }
        }
    }.resume()
}

func isGif(_ response: URLResponse?) -> Boolean {
    guard let response = response else {
        return false
    }
    let contentType = (response as! HTTPURLResponse).allHeaderFields["Content-Type"] as? String
    guard let contentType = contentType else {
        return false
    }
    return contentType.hasSuffix("gif")
}
