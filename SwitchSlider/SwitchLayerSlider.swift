//
//  SwitchLayerSlider.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 12/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

@IBDesignable class SwitchLayerSlider: UIControl, SliderDelegate {
	@IBInspectable var image: UIImage? {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			layoutIfNeeded()
			setNeedsDisplay()
		}
	}
	@IBInspectable var buttonColor: UIColor = UIColor.redColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	@IBInspectable var trackColor: UIColor = UIColor.darkGrayColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	@IBInspectable var textColor: UIColor = UIColor.lightGrayColor() {
		didSet {
			setNeedsDisplay()
		}
	}
	@IBInspectable var text: String? {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			layoutIfNeeded()
			setNeedsDisplay()
		}
	}
	@IBInspectable var font: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize()) {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			layoutIfNeeded()
			setNeedsDisplay()
		}
	}
	
	let sliderLayer: SliderLayer = SliderLayer()
	
	override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}
	
	let trackGap: CGFloat = 8.0
	
//	var positionAlongTrack: CGFloat = 0.0 {
//		didSet {
//			sliderLayer.progress = positionAlongTrack
//			setNeedsLayout()
//			layoutIfNeeded()
//			setNeedsDisplay()
//		}
//	}
	
	internal var animationCount: Int = 0 {
		didSet {
			if animationCount <= 0 {
//				positionAlongTrack = 0.0
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
		sliderLayer.switchSlider = self
		sliderLayer.contentsScale = UIScreen.mainScreen().scale
		layer.addSublayer(sliderLayer)
	}
	
	func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
		let pos = dragRange * progress
		return CGPoint(x: pos + bounds.origin.x + (trackGap / 2.0),
		               y: bounds.origin.y + (trackGap / 2.0))
	}
	
	func updateLayerFrames() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		sliderLayer.frame = bounds
		sliderLayer.setNeedsDisplay()
		
		CATransaction.commit()
	}
	
	var buttonSize: CGSize {
		return CGSize(width: bounds.height - trackGap, height: bounds.height - trackGap)
	}
	
	var minRange: CGFloat {
		return (max(buttonSize.height, buttonSize.width) + trackGap) / 2.0
	}
	
	var maxRange: CGFloat {
		return bounds.width - ((max(buttonSize.height, buttonSize.width) + trackGap) / 2.0)
	}
	
	var dragRange: CGFloat {
		return maxRange - minRange
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
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let location = touch.locationInView(self)
		return sliderLayer.beginTrackingWithTouch(location)
	}
	
	override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let location = touch.locationInView(self)
		return sliderLayer.continueTrackingWithTouch(location)
	}
	
	override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
		endTouch()
	}
	
	func endTouch() {
//		trackLayer.animate(progressTo: 0.0, forDuration: 0.5, withDelegate: self)
//		
//		let buttonOrigin = originAlongTrack(forProgress: 0.0)
//		buttonLayer.animate(positionTo: buttonOrigin, forDuration: 0.5, withDelegate: self)
	}
//	
//	override func animationDidStart(anim: CAAnimation) {
//		animationCount += 1
//	}
//	
//	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//		animationCount -= 0
//	}
	
}

class SliderLayer: TrackLayer {
	
	let buttonLayer: ButtonLayer = ButtonLayer()
	
	override var progress: CGFloat {
		didSet {
			updateButtonPosition()
		}
	}
	
	override var switchSlider: SliderDelegate? {
		didSet {
			buttonLayer.switchSlider = switchSlider
		}
	}
	
	var buttonSize: CGSize {
		return CGSize(width: bounds.height - trackGap, height: bounds.height - trackGap)
	}

	var trackGap: CGFloat = 8.0 {
		didSet {
			setNeedsLayout()
			setNeedsDisplay()
		}
	}

	override init() {
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override init(layer: AnyObject) {
		super.init(layer: layer)
		setup()
	}
	
	func setup() {
		addSublayer(buttonLayer)
	}
	
	var minRange: CGFloat {
		return (max(buttonSize.height, buttonSize.width) + trackGap) / 2.0
	}
	
	var maxRange: CGFloat {
		return bounds.width - ((max(buttonSize.height, buttonSize.width) + trackGap) / 2.0)
	}
	
	var dragRange: CGFloat {
		return maxRange - minRange
	}
	
	func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
		let pos = dragRange * progress
		return CGPoint(x: pos + bounds.origin.x + (trackGap / 2.0),
		               y: bounds.origin.y + (trackGap / 2.0))
	}
	
	func updateButtonPosition() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		let buttonOrigin = originAlongTrack(forProgress: progress)
		print("updateButtonPosition: \(buttonOrigin) x \(buttonSize)")
		buttonLayer.frame.origin = buttonOrigin
		buttonLayer.bounds.size = buttonSize
		buttonLayer.setNeedsDisplay()
		CATransaction.commit()
	}
	
	override func layoutSublayers() {
		super.layoutSublayers()
		updateButtonPosition()
	}

	func beginTrackingWithTouch(location: CGPoint) -> Bool {
		return buttonLayer.frame.contains(location)
	}
	
	func continueTrackingWithTouch(location: CGPoint) -> Bool {
		let xPos = min(max(location.x, minRange), maxRange) - minRange
		progress = min(max(0, xPos / dragRange), 1.0)
		opacity = Float(1.0 - progress)
		return true
	}

}
