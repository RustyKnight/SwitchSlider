//
//  SingleSwitchLayer.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 13/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

@IBDesignable class SingleSwitchLayerSlider: UIControl, SliderDelegate {
    @IBInspectable var image: UIImage? {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    @IBInspectable var buttonColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var trackColor: UIColor = UIColor.darkGray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var textColor: UIColor = UIColor.lightGray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var text: String? {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    @IBInspectable var textFont: UIFont = UIFont.systemFont(ofSize: 24.0) {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    @IBInspectable var trackGap: CGFloat = 8.0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    let sliderLayer: SingleSwitchLayer = SingleSwitchLayer()
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    internal var animationCount: Int = 0 {
        didSet {
            if animationCount <= 0 {
                animationCount = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        accessibilityValue = "This is a value"
        sliderLayer.switchSlider = self
        sliderLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(sliderLayer)
    }
    
    func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
        let pos = dragRange * progress
        return CGPoint(
            x: pos + bounds.origin.x + (trackGap / 2.0),
            y: bounds.origin.y + (trackGap / 2.0)
        )
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        sliderLayer.frame = bounds
        sliderLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    var buttonSize: CGSize {
        CGSize(width: bounds.height - trackGap, height: bounds.height - trackGap)
    }
    
    var minRange: CGFloat {
        (max(buttonSize.height, buttonSize.width) + trackGap) / 2.0
    }
    
    var maxRange: CGFloat {
        bounds.width - ((max(buttonSize.height, buttonSize.width) + trackGap) / 2.0)
    }
    
    var dragRange: CGFloat {
        maxRange - minRange
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateLayerFrames()
    }
    
    override var intrinsicContentSize: CGSize {
        var dimeter: CGFloat = 22.0
        if let image = image {
            let imageSize = max(image.size.width, image.size.height) * 1.5
            dimeter = max(dimeter, imageSize)
            
        }
        var textWidth = dimeter * 3
        if let text = text {
            let string = NSString(string: text)
            let attributes = [NSAttributedString.Key.font: textFont]
            let size = string.size(withAttributes: attributes)
            
            textWidth = ceil(size.width)
        }
        
        return CGSize(width: textWidth + (dimeter * 2.0) + (trackGap * 3), height: dimeter + (trackGap * 2))
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var location = touch.location(in: self)
        if UIAccessibility.isVoiceOverRunning {
            location = convert(location, to: self)
        }
        let result = sliderLayer.beginTrackingWithTouch(location)
        return result
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: self)
        let result = sliderLayer.continueTrackingWithTouch(location)
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        endTouch()
    }
    
    func endTouch() {
        var progress = sliderLayer.progress
        if sliderLayer.isRTL {
            progress = 1.0 - progress
        }
        if progress < 1.0 {
            let delay = Double(progress * 0.5)
            sliderLayer.animate(progressTo: 0.0, forDuration: delay, withDelegate: self)
        }
    }
}

extension SingleSwitchLayerSlider: CAAnimationDelegate {
    
}

class SingleSwitchLayer: ProgressLayer {
    
    var switchSlider: SliderDelegate?
    
    var trackGap: CGFloat {
        guard let slider = switchSlider else {
            return 0.0
        }
        return slider.trackGap
    }
    
    var buttonSize: CGSize {
        CGSize(width: bounds.height - (trackGap * 2.0), height: bounds.height - (trackGap * 2.0))
    }
    
    var minRange: CGFloat {
        let gap = trackGap * 2.0
        return (max(buttonSize.height, buttonSize.width) + gap) / 2.0
    }
    
    var maxRange: CGFloat {
        let gap = trackGap * 2.0
        return bounds.width - ((max(buttonSize.height, buttonSize.width) + gap) / 2.0)
    }
    
    var dragRange: CGFloat {
        maxRange - minRange
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? SingleSwitchLayer {
            progress = layer.progress
            switchSlider = layer.switchSlider
        }
    }
    
    func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
        let pos = dragRange * progress
        var point: CGPoint!
        point = CGPoint(x: pos + bounds.origin.x + (trackGap),
                        y: bounds.origin.y + (trackGap))
        return point
    }
    
    func beginTrackingWithTouch(_ location: CGPoint) -> Bool {
        buttonBounds.contains(location)
    }
    
    func continueTrackingWithTouch(_ location: CGPoint) -> Bool {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let xPos = min(max(location.x, minRange), maxRange) - minRange
        let value = min(max(0, xPos / dragRange), 1.0)
        progress = value
        CATransaction.commit()
        return true
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        drawTrackIn(context: ctx)
        drawTextIn(context: ctx)
        drawButtonIn(context: ctx)
    }
    
    var xoffset: CGFloat {
        let cornerRadius = bounds.height / 2.0
        if !isRTL {
            let width = bounds.width - (cornerRadius * 2)
            return bounds.origin.x + (width * progress)
        } else {
            return bounds.origin.x
        }
    }
    
    var widthOffset: CGFloat {
        let cornerRadius = bounds.height / 2.0
        var offset = bounds.size.width - (cornerRadius * 2)
        if isRTL {
            offset *= progress
        }
        
        return offset
    }
    
    var alpha: CGFloat {
        if isRTL {
            return progress
        } else {
            return progress - 1.0
        }
    }
    
    func drawTrackIn(context ctx: CGContext) {
        if let slider = switchSlider {
            
            ctx.saveGState()
            // Clip
            let cornerRadius = bounds.height / 2.0
            
            var width = widthOffset //bounds.size.width - (cornerRadius * 2)
            let x = xoffset
            width = width - x
            
            let fillBounds = CGRect(
                origin: CGPoint(x: x, y: bounds.origin.y),
                size: CGSize(
                    width: width + (cornerRadius * 2),
                    height: bounds.height
                )
            )
            let path = UIBezierPath(roundedRect: fillBounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            var color = slider.trackColor
            color = color.applyAlpha(alpha.toDouble)
            
            ctx.setFillColor(color.cgColor)
            ctx.fillPath()
            
            ctx.restoreGState()
        }
    }
    
    func drawTextIn(context ctx: CGContext) {
        if let slider = switchSlider {
            
            ctx.saveGState()
            
            let cornerRadius = bounds.height / 2.0
            let x = xoffset + cornerRadius
            let width = widthOffset
            
            let clipBounds = CGRect(x: x, y: 0,
                                    width: width, height: bounds.height)
            ctx.addPath(UIBezierPath(rect: clipBounds).cgPath)
            ctx.clip()
            
            ctx.translateBy(x: 0.0, y: bounds.height)
            ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            let aFont = slider.textFont
            // create a dictionary of attributes to be applied to the string
            let color = slider.textColor.cgColor
            let attr = [NSAttributedString.Key.font:aFont, NSAttributedString.Key.foregroundColor:color] as [NSAttributedString.Key : Any]
            // create the attributed string
            let text = CFAttributedStringCreate(nil, slider.text == nil ? "" as CFString : slider.text as CFString?, attr as CFDictionary)
            // create the line of text
            let line = CTLineCreateWithAttributedString(text!)
            // retrieve the bounds of the text
            let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
            // set the line width to stroke the text with
            ctx.setLineWidth(1.5)
            // set the drawing mode to stroke
            ctx.setTextDrawingMode(CGTextDrawingMode.fill)
            // Set text position and draw the line into the graphics context, text length and height is adjusted for
            
            var xn = 0.0.cgFloat
            if isRTL {
                xn = bounds.origin.x + cornerRadius
            } else {
                xn = bounds.width - lineBounds.width - cornerRadius
            }
            
            let yn = -(bounds.centerOf.y - lineBounds.midY)
            ctx.textPosition = CGPoint(x: xn, y: yn)
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            // draw the line of text
            ctx.setFillColor(slider.textColor.cgColor)
            CTLineDraw(line, ctx)
            
            ctx.restoreGState()
        }
    }
    
    var buttonBounds: CGRect {
        var buttonBounds = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.height,
            height: bounds.height
        )
        let positionAlongTrack = dragRange * progress
        buttonBounds.origin.x = positionAlongTrack
        return buttonBounds.insetBy(dx: trackGap, dy: trackGap)
    }
    
    func drawButtonIn(context ctx: CGContext) {
        if let slider = switchSlider {
            ctx.saveGState()
            
            // Clip
            let radius = CGFloat(min(buttonBounds.width, buttonBounds.height) / 2.0)
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: buttonBounds.centerOf.x, y: buttonBounds.centerOf.y),
                radius: radius,
                startAngle: CGFloat(0),
                endAngle: CGFloat(Double.pi * 2),
                clockwise: true
            )
            
            // Fill the track
            ctx.setFillColor(slider.buttonColor.cgColor)
            ctx.addPath(circlePath.cgPath)
            ctx.fillPath()
            
            if let image = slider.image {
                ctx.saveGState();
                ctx.translateBy(x: buttonBounds.origin.x, y: buttonBounds.origin.y)
                // Draw image
                let rect = CGRect(
                    x: (buttonBounds.width - image.size.width) / 2.0,
                    y: -buttonBounds.height + ((buttonBounds.height - image.size.height) / 2.0),
                    width: image.size.width,
                    height: image.size.height
                )
                //				let rect = CGRect(x: (buttonBounds.width - image.size.width) / 2.0,
                //				                  y: 0, width: image.size.width, height: image.size.height)
                ctx.scaleBy(x: 1.0, y: -1.0);
                ctx.draw(image.cgImage!, in: rect)
                ctx.scaleBy(x: 1.0, y: 1.0);
                ctx.restoreGState()
            }
            
            ctx.restoreGState()
        }
    }
    
}
