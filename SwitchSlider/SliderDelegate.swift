//
//  SliderDelegate.swift
//  SwitchSlider
//
//  Created by Shane Whitehead on 12/06/2016.
//  Copyright © 2016 Beam Communications. All rights reserved.
//

import UIKit

protocol SliderDelegate {
	
	var text: String? {get set}
	var textColor: UIColor {get set}
	var trackColor: UIColor {get set}
	var buttonColor: UIColor {get set}
	var image: UIImage? {get set}
	
	var textFont: UIFont {get set}

}