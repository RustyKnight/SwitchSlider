//
//  SwitchSlider.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 9/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

class ProgressLayer: CALayer {
	
	var progress: CGFloat = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	var isRTL: Bool {
		return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
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
    
    override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? ProgressLayer {
			progress = layer.progress
		}
	}
	
	/*
	Override actionForKey: and return a CAAnimation that prepares the animation for that property.
	In our case, we will return an animation for the progress property.
	*/
	override func action(forKey event: String) -> CAAction? {
		var action: CAAction?
		if event == "progress" {
			action = self.animation(forKey: event)
		} else {
			action = super.action(forKey: event)
		}
		return action
	}
	
	class override func needsDisplay(forKey key: String) -> Bool {
		if key == "progress" {
			return true
		} else {
			return super.needsDisplay(forKey: key)
		}
	}
	
	func animate(progressTo value: CGFloat, forDuration duration: Double, withDelegate: CAAnimationDelegate?) {
		removeAnimation(forKey: "progress")
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
		
		add(anim, forKey: "progress")
		
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
	
	override init(layer: Any) {
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
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	override func draw(in ctx: CGContext) {
		super.draw(in: ctx)
		if let slider = switchSlider {
			
			ctx.saveGState()
			// Clip
			let cornerRadius = bounds.height / 2.0
			
			var width = bounds.size.width - (cornerRadius * 2)
			var x = bounds.origin.x
			
			x = x + width * progress
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
			ctx.setFillColor(slider.trackColor.cgColor)
			ctx.fillPath()
			
			let clipBounds = CGRect(x: x + cornerRadius, y: 0,
			                        width: bounds.width - (x + cornerRadius), height: bounds.height)
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
			let xn = bounds.width - lineBounds.width - cornerRadius
			let yn = -(bounds.centerOf.y - lineBounds.midY)
            ctx.textPosition = CGPoint(x: xn, y: yn)
			// the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
			// draw the line of text
			ctx.setFillColor(slider.textColor.cgColor)
			CTLineDraw(line, ctx)
			
			ctx.restoreGState()
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
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	var angle: CGFloat {
		return (180.0 * progress).toRadians
	}
	
	override func draw(in ctx: CGContext) {
		super.draw(in: ctx)
		if let slider = switchSlider {
			ctx.saveGState()
			
			//		buttonLayer.transform = CATransform3DRotate(buttonLayer.transform, angle, 0.0, 0.0, 1.0)
			// Clip
			let radius = CGFloat(min(bounds.width, bounds.height) / 2.0)
			let circlePath = UIBezierPath(
				arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
				radius: radius,
				startAngle: CGFloat(0),
				endAngle:CGFloat(Double.pi * 2),
				clockwise: true
            )
			
			// Fill the track
			ctx.setFillColor(slider.buttonColor.cgColor)
			ctx.addPath(circlePath.cgPath)
			ctx.fillPath()
			
			if let image = slider.image {
				ctx.saveGState();
				// Draw image
				let rect = CGRect(x: (bounds.width - image.size.width) / 2.0,
				                  y: -bounds.height + ((bounds.height - image.size.height) / 2.0),
				                  width: image.size.width,
				                  height: image.size.height)
				ctx.scaleBy(x: 1.0, y: -1.0);
                ctx.draw(image.cgImage!, in: rect)
				ctx.scaleBy(x: 1.0, y: 1.0);
				ctx.restoreGState()
			}
			
			ctx.restoreGState()
			
		}
	}
	
}

extension Int {
	var toRadians: Double { return Double(self) * Double.pi / 180 }
	var toDegrees: Double { return Double(self) * 180 / Double.pi }
}

extension Double {
	var toRadians: Double { return self * Double.pi / 180 }
	var toDegrees: Double { return self * 180 / Double.pi }
	var cgFloat: CGFloat { return CGFloat(self) }
}

extension CGFloat {
	var doubleValue:      Double  { return Double(self) }
	var toRadians: CGFloat { return CGFloat(doubleValue * Double.pi / 180) }
	var toDegrees: CGFloat { return CGFloat(doubleValue * 180 / Double.pi) }
}

extension Float  {
	var doubleValue:      Double { return Double(self) }
	var toRadians: Float  { return Float(doubleValue * Double.pi / 180) }
	var toDegrees: Float  { return Float(doubleValue * 180 / Double.pi) }
	var cgFloat: CGFloat { return CGFloat(self) }
}

public extension CGRect {
	func withInsets(_ insets: UIEdgeInsets) -> CGRect {
		return CGRect(x: self.minX + insets.left,
		              y: self.minY + insets.top,
		              width: self.width - (insets.right + insets.left),
		              height: self.height - (insets.bottom + insets.top))
	}
	
	var maxDimension: CGFloat {
		return max(self.width, self.height)
	}
	
	var minDimension: CGFloat {
		return min(self.width, self.height)
	}
	
	var centerOf: CGPoint {
		return CGPoint(
			x: self.minX + (self.width / 2),
			y: self.minY + (self.height / 2))
	}
	
}
