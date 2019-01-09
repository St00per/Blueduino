//
//  UserDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 20/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class UserDeviceCollectionViewCell: UICollectionViewCell {
    
    var viewController: DevicesSearchViewController?
    var peripheral: CBPeripheral?
    var deviceColor = UIColor.white
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var switchView: UIView!
    
    
    @IBAction func connect(_ sender: UIButton) {
        guard let controller = viewController, let selectedPeripheral = peripheral else { return }
        if connectButton.titleLabel?.text == "DISCONNECT" {
            controller.disconnect(peripheral: selectedPeripheral)
            connectButton.setTitle("CONNECT", for: .normal)
            connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        } else {
            controller.connect(peripheral: selectedPeripheral)
            connectButton.backgroundColor = UIColor(hexString: "#CC4242", alpha: 0.6)
            connectButton.setTitle("DISCONNECT", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let customSwitch = CustomSwitch(frame: CGRect(x: 0, y: 5, width: 55, height: 25))
        customSwitch.isOn = false
        customSwitch.onTintColor = deviceColor
        customSwitch.offTintColor = UIColor.lightGray
        customSwitch.cornerRadius = 0.5
        customSwitch.thumbCornerRadius = 0.5
        customSwitch.thumbSize = CGSize(width: 30, height: 30)
        customSwitch.thumbTintColor = UIColor.white
        customSwitch.padding = 0
        customSwitch.animationDuration = 0.25
        
        switchView.addSubview(customSwitch)
    }
    
    func configure(name: String, color: UIColor) {
        connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        pickColorButton.backgroundColor = color
        deviceName.text = name
    }
}
