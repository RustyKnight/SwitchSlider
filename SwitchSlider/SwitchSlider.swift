//
//  SwitchSlider.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 9/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

//@IBDesignable class SwitchSlider: UIControl, SliderDelegate {
//	@IBInspectable var image: UIImage? {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			invalidateIntrinsicContentSize()
//			setNeedsLayout()
//			layoutIfNeeded()
//		}
//	}
//	@IBInspectable var buttonColor: UIColor = UIColor.whiteColor() {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			setNeedsDisplay()
//		}
//	}
//	@IBInspectable var trackColor: UIColor = UIColor.darkGrayColor() {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			setNeedsDisplay()
//		}
//	}
//	@IBInspectable var textColor: UIColor = UIColor.lightGrayColor() {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			setNeedsDisplay()
//		}
//	}
//	@IBInspectable var text: String? {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			invalidateIntrinsicContentSize()
//			setNeedsLayout()
//			layoutIfNeeded()
//		}
//	}
//	@IBInspectable var textFont: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
//		didSet {
//			trackLayer.setNeedsDisplay()
//			buttonLayer.setNeedsDisplay()
//			invalidateIntrinsicContentSize()
//			setNeedsLayout()
//			layoutIfNeeded()
//		}
//	}
//	
//	override var frame: CGRect {
//		didSet {
//			updateLayerFrames()
//		}
//	}
//	
//	let trackLayer = TrackLayer()
//	let buttonLayer = ButtonLayer()
//	
//	let trackGap: CGFloat = 8.0
//	
//	var positionAlongTrack: CGFloat = 0.0 {
//		didSet {
//			trackLayer.progress = positionAlongTrack
//			buttonLayer.progress = positionAlongTrack
//			setNeedsLayout()
//			layoutIfNeeded()
//			setNeedsDisplay()
//		}
//	}
//	
//	internal var animationCount: Int = 0 {
//		didSet {
//			if animationCount <= 0 {
//				positionAlongTrack = 0.0
//				animationCount = 0
//			}
//		}
//	}
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		setup()
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		setup()
//	}
//	
//	func setup() {
//		//        layer.borderColor = UIColor.redColor().CGColor
//		//        layer.borderWidth = 1.0
//		
//		trackLayer.switchSlider = self
//		trackLayer.contentsScale = UIScreen.mainScreen().scale
//		layer.addSublayer(trackLayer)
//		
//		buttonLayer.switchSlider = self
//		buttonLayer.contentsScale = UIScreen.mainScreen().scale
//		layer.addSublayer(buttonLayer)
//	}
//	
//	func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
//		let pos = dragRange * progress
//		return CGPoint(x: pos + bounds.origin.x + (trackGap / 2.0),
//		                           y: bounds.origin.y + (trackGap / 2.0))
//	}
//	
//	func updateLayerFrames() {
//		CATransaction.begin()
//		CATransaction.setDisableActions(true)
//		
//		trackLayer.frame = bounds
//		trackLayer.setNeedsDisplay()
//		
//		let buttonOrigin = originAlongTrack(forProgress: positionAlongTrack)
//		buttonLayer.frame.origin = buttonOrigin
//		buttonLayer.bounds.size = buttonSize
//		buttonLayer.setNeedsDisplay()
//		
//		CATransaction.commit()
//	}
//
//	var buttonSize: CGSize {
//		return CGSize(width: bounds.height - trackGap, height: bounds.height - trackGap)
//	}
//	
//	var minRange: CGFloat {
//		return (max(buttonSize.height, buttonSize.width) + trackGap) / 2.0
//	}
//	
//	var maxRange: CGFloat {
//		return bounds.width - ((max(buttonSize.height, buttonSize.width) + trackGap) / 2.0)
//	}
//	
//	var dragRange: CGFloat {
////		return bounds.width - max(buttonSize.height, buttonSize.width) - trackGap
//		return maxRange - minRange
//	}
//	
//	override func layoutSubviews() {
//		super.layoutSubviews()
//	}
//	
//	override func layoutSublayersOfLayer(layer: CALayer) {
//		super.layoutSublayersOfLayer(layer)
//		updateLayerFrames()
//	}
//	
//	override func intrinsicContentSize() -> CGSize {
//		var dimeter: CGFloat = 22.0
//		if let image = image {
//			let imageSize = max(image.size.width, image.size.height) * 1.5
//			dimeter = max(dimeter, imageSize)
//			
//		}
//		var textWidth = dimeter * 3
//		if let text = text {
//			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//			label.numberOfLines = 0
//			label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//			label.font = textFont
//			label.text = text
//			
//			label.sizeToFit()
//			let size = label.frame
//			dimeter = max(dimeter, size.height)
//			textWidth = size.width
//		}
//		
//		return CGSize(width: textWidth + dimeter + (trackGap * 3), height: dimeter + (trackGap * 2))
//	}
//	
//	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
//		let location = touch.locationInView(self)
//		return buttonLayer.frame.contains(location)
//	}
//	
//	override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
//		let location = touch.locationInView(self)
//		let xPos = min(max(location.x, minRange), maxRange) - minRange
//		positionAlongTrack = min(max(0, xPos / dragRange), 1.0)
//		endTouch()
//		return positionAlongTrack < 1.0
//	}
//	
//	override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
//		endTouch()
//	}
//	
//	func endTouch() {
//		trackLayer.animate(progressTo: 0.0, forDuration: 0.5, withDelegate: self)
//		
//		let buttonOrigin = originAlongTrack(forProgress: 0.0)
//		buttonLayer.animate(positionTo: buttonOrigin, forDuration: 0.5, withDelegate: self)
//	}
//	
//	override func animationDidStart(anim: CAAnimation) {
//		animationCount += 1
//	}
//	
//	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//		animationCount -= 0
//	}
//	
//}

class ProgressLayer: CALayer {
	
	var progress: CGFloat = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var isRTL: Bool {
		return UIApplication.sharedApplication().userInterfaceLayoutDirection == .RightToLeft
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		if isRTL {
			progress = 1.0
		}
	}
	
	override init() {
		super.init()
		if isRTL {
			progress = 1.0
		}
	}
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? ProgressLayer {
			progress = layer.progress
		}
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the progress property.
	*/
	override func actionForKey(event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" {
			action = self.animationForKey(event)
		} else {
			action = super.actionForKey(event)
		}
		return action
	}
	
	class override func needsDisplayForKey(key: String) -> Bool {
		if key == "progress" {
			return true
		} else {
			return super.needsDisplayForKey(key)
		}
	}
	
	func animate(progressTo value: CGFloat, forDuration duration: Double, withDelegate: AnyObject?) {
		removeAnimationForKey("progress")
		var toValue = value
		let fromValue = progress
		if isRTL {
			toValue = 1.0 - value
		}
		let anim = CABasicAnimation(keyPath: "progress")
		anim.delegate = withDelegate
		anim.toValue = toValue
		anim.fromValue = fromValue
		anim.duration = duration
		
		addAnimation(anim, forKey: "progress")
		
		self.progress = toValue
	}
}

class SwitchLayer: ProgressLayer {
	
	var switchSlider: SliderDelegate?
	
	override init() {
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
		if let layer = layer as? TrackLayer {
			switchSlider = layer.switchSlider
		}
	}
	
}


class TrackLayer: SwitchLayer {
	
	override init() {
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
	}
	
	override func drawInContext(ctx: CGContext) {
		super.drawInContext(ctx)
		if let slider = switchSlider {
			
			CGContextSaveGState(ctx)
			// Clip
			let cornerRadius = bounds.height / 2.0
			
			var width = bounds.size.width - (cornerRadius * 2)
			var x = bounds.origin.x
			
			x = x + width * progress
			width = width - x
			
			let fillBounds = CGRect(origin: CGPoint(x: x, y: bounds.origin.y),
			                        size: CGSize(width: width + (cornerRadius * 2),
																height: bounds.height))
			let path = UIBezierPath(roundedRect: fillBounds, cornerRadius: cornerRadius)
			CGContextAddPath(ctx, path.CGPath)
			
			// Fill the track
			CGContextSetFillColorWithColor(ctx, slider.trackColor.CGColor)
			CGContextFillPath(ctx)
			
			let clipBounds = CGRect(x: x + cornerRadius, y: 0,
			                        width: bounds.width - (x + cornerRadius), height: bounds.height)
			CGContextAddPath(ctx, UIBezierPath(rect: clipBounds).CGPath)
			CGContextClip(ctx)
			
			CGContextTranslateCTM(ctx, 0.0, bounds.height)
			CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1.0, -1.0))
			let aFont = slider.textFont
			// create a dictionary of attributes to be applied to the string
			let color = slider.textColor.CGColor
			let attr = [NSFontAttributeName:aFont, NSForegroundColorAttributeName:color]
			// create the attributed string
			let text = CFAttributedStringCreate(nil, slider.text == nil ? "" : slider.text, attr)
			// create the line of text
			let line = CTLineCreateWithAttributedString(text)
			// retrieve the bounds of the text
			let lineBounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
			// set the line width to stroke the text with
			CGContextSetLineWidth(ctx, 1.5)
			// set the drawing mode to stroke
			CGContextSetTextDrawingMode(ctx, CGTextDrawingMode.Fill)
			// Set text position and draw the line into the graphics context, text length and height is adjusted for
			let xn = bounds.width - lineBounds.width - cornerRadius
			let yn = -(bounds.centerOf.y - lineBounds.midY)
			CGContextSetTextPosition(ctx, xn, yn)
			// the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
			// draw the line of text
			CGContextSetFillColorWithColor(ctx, slider.textColor.CGColor)
			CTLineDraw(line, ctx)
			
			CGContextRestoreGState(ctx)
		}
	}
	
}

class ButtonLayer: SwitchLayer {
	
	override init() {
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
	}
	
//	func animate(positionTo value: CGPoint, forDuration duration: Double, withDelegate: AnyObject?) {
//		removeAnimationForKey("position")
//		
//		let adjustedOrigin = CGPoint(x: value.x + bounds.width / 2.0, y: value.y + bounds.height / 2.0)
//		
//		let anim = CABasicAnimation(keyPath: "position")
//		anim.delegate = withDelegate
//		anim.toValue = NSValue(CGPoint: adjustedOrigin)
//		anim.fromValue = NSValue(CGPoint: position)
//		anim.duration = duration
//		
//		addAnimation(anim, forKey: "position")
//		
//		CATransaction.begin()
//		CATransaction.setDisableActions(true)
//		position = adjustedOrigin
//		CATransaction.commit()
//	}
	
	var angle: CGFloat {
		return (180.0 * progress).toRadians
	}
	
	override func drawInContext(ctx: CGContext) {
		super.drawInContext(ctx)
		if let slider = switchSlider {
			CGContextSaveGState(ctx)
			
			//		buttonLayer.transform = CATransform3DRotate(buttonLayer.transform, angle, 0.0, 0.0, 1.0)
			// Clip
			let radius = CGFloat(min(bounds.width, bounds.height) / 2.0)
			let circlePath = UIBezierPath(
				arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
				radius: radius,
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
			
			CGContextRestoreGState(ctx)
			
		}
	}
	
}

extension Int {
	var toRadians: Double { return Double(self) * M_PI / 180 }
	var toDegrees: Double { return Double(self) * 180 / M_PI }
}

extension Double {
	var toRadians: Double { return self * M_PI / 180 }
	var toDegrees: Double { return self * 180 / M_PI }
	var cgFloat: CGFloat { return CGFloat(self) }
}

extension CGFloat {
	var doubleValue:      Double  { return Double(self) }
	var toRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
	var toDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

extension Float  {
	var doubleValue:      Double { return Double(self) }
	var toRadians: Float  { return Float(doubleValue * M_PI / 180) }
	var toDegrees: Float  { return Float(doubleValue * 180 / M_PI) }
	var cgFloat: CGFloat { return CGFloat(self) }
}

public extension CGRect {
	func withInsets(insets: UIEdgeInsets) -> CGRect {
		return CGRect(x: CGRectGetMinX(self) + insets.left,
		              y: CGRectGetMinY(self) + insets.top,
		              width: CGRectGetWidth(self) - (insets.right + insets.left),
		              height: CGRectGetHeight(self) - (insets.bottom + insets.top))
	}
	
	var maxDimension: CGFloat {
		return max(CGRectGetWidth(self), CGRectGetHeight(self))
	}
	
	var minDimension: CGFloat {
		return min(CGRectGetWidth(self), CGRectGetHeight(self))
	}
	
	var centerOf: CGPoint {
		return CGPoint(
			x: CGRectGetMinX(self) + (CGRectGetWidth(self) / 2),
			y: CGRectGetMinY(self) + (CGRectGetHeight(self) / 2))
	}
	
}
