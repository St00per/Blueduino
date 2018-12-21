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
    
    var device: CBPeripheral?
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    
    var viewController: DevicesSearchViewController?
    var peripheral: CBPeripheral?
    
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
    
    func configure(name: String) {
        connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        pickColorButton.backgroundColor = UIColor(hexString: "#B7D293", alpha: 0.4)
        deviceName.text = name
    }
}
