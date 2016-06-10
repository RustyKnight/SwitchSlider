//
//  SwitchSlider.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 9/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

@IBDesignable class SwitchSlider: UIControl {
    @IBInspectable var image: UIImage? {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    @IBInspectable var buttonColor: UIColor = UIColor.whiteColor() {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            setNeedsDisplay()
        }
    }
    @IBInspectable var trackColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            setNeedsDisplay()
        }
    }
    @IBInspectable var textColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            setNeedsDisplay()
        }
    }
    @IBInspectable var text: String? {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    @IBInspectable var font: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
        didSet {
            trackLayer.setNeedsDisplay()
            buttonLayer.setNeedsDisplay()
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    let trackLayer = TrackLayer()
    let buttonLayer = ButtonLayer()

    let trackGap: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
//        layer.borderColor = UIColor.redColor().CGColor
//        layer.borderWidth = 1.0

        trackLayer.switchSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)

        buttonLayer.switchSlider = self
        buttonLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(buttonLayer)
    }

    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        trackLayer.frame = bounds
        trackLayer.setNeedsDisplay()

        let buttonBounds = CGRect(x: bounds.origin.x + (trackGap / 2.0), y: bounds.origin.y + (trackGap / 2.0),
                                  width: bounds.height - trackGap, height: bounds.height - trackGap)
        print(buttonBounds)
        buttonLayer.frame = buttonBounds
        buttonLayer.setNeedsDisplay()


        CATransaction.commit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        updateLayerFrames()
    }

    override func intrinsicContentSize() -> CGSize {
        var dimeter: CGFloat = 22.0
        if let image = image {
            let imageSize = max(image.size.width, image.size.height) * 1.5
            dimeter = max(dimeter, imageSize)

        }
        var textWidth = dimeter * 3
        if let text = text {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = font
            label.text = text

            label.sizeToFit()
            let size = label.frame
            dimeter = max(dimeter, size.height)
            textWidth = size.width
        }

        return CGSize(width: textWidth + dimeter + (trackGap * 3), height: dimeter + (trackGap * 2))
    }

}

class TrackLayer: CALayer {
    weak var switchSlider: SwitchSlider?

    override func drawInContext(ctx: CGContext) {
        if let slider = switchSlider {
            // Clip
            let cornerRadius = bounds.height / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            CGContextAddPath(ctx, path.CGPath)

            // Fill the track
            CGContextSetFillColorWithColor(ctx, slider.trackColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
//
//            // Fill the highlighted range
//            CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
//            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
//            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
//            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
//            CGContextFillRect(ctx, rect)
        }
    }
}

class ButtonLayer: CALayer {
    weak var switchSlider: SwitchSlider?

    override func drawInContext(ctx: CGContext) {
        if let slider = switchSlider {
            // Clip
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
                radius: CGFloat(min(bounds.width, bounds.height) / 2.0),
                startAngle: CGFloat(0),
                endAngle:CGFloat(M_PI * 2),
                clockwise: true)

            // Fill the track
            CGContextSetFillColorWithColor(ctx, slider.buttonColor.CGColor)
            CGContextAddPath(ctx, circlePath.CGPath)
            CGContextFillPath(ctx)

            if let image = slider.image {
                CGContextSaveGState(ctx);
                // Draw image
                let rect = CGRect(x: (bounds.width - image.size.width) / 2.0,
                                  y: -bounds.height + ((bounds.height - image.size.height) / 2.0),
                                  width: image.size.width,
                                  height: image.size.height)
                CGContextScaleCTM(ctx, 1.0, -1.0);
                CGContextDrawImage(ctx, rect, image.CGImage)
                CGContextScaleCTM(ctx, 1.0, 1.0);
                //                image.drawAtPoint(CGPoint(x: x, y: y))
                CGContextRestoreGState(ctx)
            }

        }
    }

}
