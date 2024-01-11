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
			layoutIfNeeded()
			setNeedsDisplay()
		}
	}
	@IBInspectable var textFont: UIFont = UIFont.systemFont(ofSize: 24.0) {
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
	
	var trackGap: CGFloat = 8.0
	
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
		sliderLayer.contentsScale = UIScreen.main.scale
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
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
			label.numberOfLines = 0
			label.lineBreakMode = NSLineBreakMode.byWordWrapping
			label.font = textFont
			label.text = text
			
			label.sizeToFit()
			let size = label.frame
			dimeter = max(dimeter, size.height)
			textWidth = size.width
		}
		
		return CGSize(width: textWidth + dimeter + (trackGap * 3), height: dimeter + (trackGap * 2))
	}
	
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		return sliderLayer.beginTrackingWithTouch(location)
	}
	
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		return sliderLayer.continueTrackingWithTouch(location)
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		endTouch()
	}
	
	func endTouch() {
		if sliderLayer.progress < 1.0 {
			let delay = Double(sliderLayer.progress * 0.5)
			sliderLayer.animate(progressTo: 0.0, forDuration: delay, withDelegate: self)
		}
	}
}

extension SwitchLayerSlider: CAAnimationDelegate {
    
}

class SliderLayer: ProgressLayer {
	
	var buttonLayer: ButtonLayer = ButtonLayer()
	var trackLayer: TrackLayer = TrackLayer()
	
	override var progress: CGFloat {
		didSet {
			trackLayer.progress = progress
			buttonLayer.progress = progress
//			trackLayer.opacity = Float(1.0 - progress)
			updateLayout()
		}
	}
	
	var switchSlider: SliderDelegate? {
		didSet {
			buttonLayer.switchSlider = switchSlider
			trackLayer.switchSlider = switchSlider
		}
	}
	
	var buttonSize: CGSize {
		return CGSize(width: bounds.height - (trackGap * 2.0), height: bounds.height - (trackGap * 2.0))
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
	
	override init(layer: Any) {
		super.init(layer: layer)
		if let layer = layer as? SliderLayer {
			buttonLayer = layer.buttonLayer
			trackLayer = layer.trackLayer
			progress = layer.progress
		}
	}

	class override func needsDisplay(forKey key: String) -> Bool {
		if key == "buttonLayer" || key == "trackLayer" {
			return true
		} else {
			print(key)
			return super.needsDisplay(forKey: key)
		}
	}
	
	override func action(forKey event: String) -> CAAction? {
		var action: CAAction?
		if event == "buttonLayer" || event == "trackLayer" {
			action = self.animation(forKey: event)
		} else {
			action = super.action(forKey: event)
		}
		return action
	}
	
	func setup() {
		addSublayer(trackLayer)
		addSublayer(buttonLayer)
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
		return maxRange - minRange
	}
	
	func originAlongTrack(forProgress progress: CGFloat) -> CGPoint {
		let pos = dragRange * progress
		return CGPoint(x: pos + bounds.origin.x + (trackGap),
		               y: bounds.origin.y + (trackGap))
	}
	
	func updateLayout() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		trackLayer.frame = bounds
		trackLayer.setNeedsDisplay()
		
		let buttonOrigin = originAlongTrack(forProgress: progress)
		buttonLayer.frame.origin = buttonOrigin
		buttonLayer.bounds.size = buttonSize
		buttonLayer.setNeedsDisplay()
		CATransaction.commit()
	}
	
	override func layoutSublayers() {
		super.layoutSublayers()
		updateLayout()
	}

	func beginTrackingWithTouch(_ location: CGPoint) -> Bool {
		return buttonLayer.frame.contains(location)
	}
	
	func continueTrackingWithTouch(_ location: CGPoint) -> Bool {
		let xPos = min(max(location.x, minRange), maxRange) - minRange
		progress = min(max(0, xPos / dragRange), 1.0)
		return true
	}

}
