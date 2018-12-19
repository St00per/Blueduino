//
//  LightDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit

class LightDeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    
    func setLabel(name: String) {
        deviceName.text = name
    }
}
