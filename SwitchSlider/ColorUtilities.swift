//
//  ColorUtilities.swift
//  KZCoreUILibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

public extension UIColor {
	public func blend(with color: UIColor) -> UIColor {
		return UIColor.blend(self, with: color, by: 0.5)
	}
	
	public func blend(with color: UIColor, by ratio: Double) -> UIColor {
		return UIColor.blend(self, with: color, by: ratio)
	}
	
	public class func blend(color: UIColor, with: UIColor, by ratio: Double) -> UIColor {
		let inverseRatio: CGFloat = 1.0 - ratio.toCGFloat
		
		let fromComponents = CGColorGetComponents(color.CGColor)
		let toComponents = CGColorGetComponents(with.CGColor)
		
		var red = toComponents[0] * ratio.toCGFloat + fromComponents[0] * inverseRatio
		var green = toComponents[1] * ratio.toCGFloat + fromComponents[1] * inverseRatio
		var blue = toComponents[2] * ratio.toCGFloat + fromComponents[2] * inverseRatio
		var alpha = CGColorGetAlpha(with.CGColor) * ratio.toCGFloat +
			CGColorGetAlpha(color.CGColor) * inverseRatio
		
		red = max(0.0, min(1.0, red))
		green = max(0.0, min(1.0, green))
		blue = max(0.0, min(1.0, blue))
		alpha = max(0.0, min(1.0, alpha))
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	public func darken(by by: Double) -> UIColor {
		let rgb = CGColorGetComponents(CGColor)
		
		let red = max(0, rgb[0] - 1.0.toCGFloat * by.toCGFloat)
		let green = max(0, rgb[1] - 1.0.toCGFloat * by.toCGFloat)
		let blue = max(0, rgb[2] - 1.0.toCGFloat * by.toCGFloat)
		let alpha = CGColorGetAlpha(CGColor)
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	public func brighten(by by:Double) -> UIColor {
		let rgb = CGColorGetComponents(CGColor)
		
		let red = min(1.0, rgb[0] + 1.0.toCGFloat * by.toCGFloat)
		let green = min(1.0, rgb[1] + 1.0.toCGFloat * by.toCGFloat)
		let blue = min(1.0, rgb[2] + 1.0.toCGFloat * by.toCGFloat)
		let alpha = CGColorGetAlpha(CGColor)
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
	
	//	class func distance(from from: UIColor, to: UIColor) -> Double {
	//		let fromComponents = CGColorGetComponents(from.CGColor)
	//		let toComponents = CGColorGetComponents(to.CGColor)
	//
	//		let red = toComponents[0] - fromComponents[0]
	//		let green = toComponents[1] - fromComponents[1]
	//		let blue = toComponents[2] - fromComponents[2]
	//
	//		return sqrt(red.toDouble * red.toDouble +
	//			green.toDouble * green.toDouble +
	//			blue.toDouble * blue.toDouble)
	//	}
	
	public func applyAlpha(alpha: Double) -> UIColor {
		let rgb = CGColorGetComponents(CGColor)
		return UIColor(red: rgb[0], green: rgb[0], blue: rgb[0], alpha: alpha.toCGFloat)
	}
	
	public func invert() -> UIColor {
		let rgb = CGColorGetComponents(CGColor)
		let alpha = CGColorGetAlpha(CGColor)
		return UIColor(red: 1.0 - rgb[0], green: 1.0 - rgb[0], blue: 1.0 - rgb[0], alpha: alpha)
	}
}

public struct ColorBandEntry {
	public let color: UIColor
	public let location: Double
	
	public init(withColor: UIColor, at: Double) {
		self.color = withColor
		self.location = at
	}
}

public struct ColorBandBuilder {
	private var entries: [ColorBandEntry] = []
	
	public init() {
	}
	
	public mutating func add(color color:UIColor, at: Double) -> ColorBandBuilder {
		entries.append(ColorBandEntry(withColor: color, at: at))
		return self
	}
	
	public mutating func build() -> ColorBand {
		entries.sortInPlace { (entry1, entry2) -> Bool in
			return entry1.location > entry2.location
		}
		
		return ColorBand(with: entries)
	}
}

/**
A ColorBand is a group of colors and locations, which can be blended
over a normalised period (0-1)

This is basically a color gradient generator
*/
public struct ColorBand {
	public let entries: [ColorBandEntry]
	
	public init(withColors colors: [UIColor], andLocations locations: [Double]) {
		var tempEntries: [ColorBandEntry] = []
		for index in 0...colors.count {
			tempEntries.append(ColorBandEntry(withColor: colors[index], at: locations[index]))
		}
		tempEntries.sortInPlace { (entry1, entry2) -> Bool in
			return entry1.location < entry2.location
		}
		entries = tempEntries
	}
	
	public init(with entries: [ColorBandEntry]) {
		var tempEntries = entries
		tempEntries.sortInPlace { (entry1, entry2) -> Bool in
			return entry1.location < entry2.location
		}
		self.entries = tempEntries;
	}
	
	/**
	Returns the start/end indicies which bracket the given progress
	*/
	func locationIndiciesFrom(forProgress progress:Double) -> [Int] {
		var range: [Int] = []
		var startPoint = 0
		while startPoint < entries.count && entries[startPoint].location <= progress {
			startPoint += 1
		}
		
		if startPoint >= entries.count {
			startPoint = entries.count - 1
		} else if (startPoint == 0) {
			startPoint = 1
		}
		
		range.append(startPoint - 1)
		range.append(startPoint)
		
		return range
	}
	
	/**
	Given an array of colors and an equal number of fractions (0-1) and a progress value (0-1)
	this returns the blending of the colors between the points
	
	The fractions should be ordered from lowest or highest
	*/
	public func colorAt(progress: Double) -> UIColor {
		var blend = UIColor.blackColor()
		if entries.count > 1 {
			let indicies = locationIndiciesFrom(forProgress: progress)
			let fromFraction = entries[indicies[0]].location
			let toFraction = entries[indicies[1]].location
			
			let fromColor = entries[indicies[0]].color
			let toColor = entries[indicies[1]].color
			
			let max = toFraction - fromFraction
			let value = progress - fromFraction
			let weight = Double(value) / Double(max)
			
			blend = fromColor.blend(with: toColor, by: weight)
		} else if entries.count == 1 {
			blend = entries[0].color
		}
		return blend
	}
	
}

public extension Float {
	public var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension Double {
	public var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension CGFloat {
	
	public var toDouble: Double {
		return Double(self)
	}
	
	public var toFloat: Float {
		return Float(self)
	}
}

