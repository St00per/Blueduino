//
//  LightDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class LightDeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    
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
    
    @IBAction func addToList(_ sender: UIButton) {
        guard let controller = viewController, let selectedPeripheral = peripheral else { return }
        controller.addedDevices.append(selectedPeripheral)
        addToListButton.setImage(UIImage(named: "check"), for: .normal)
    }
    
    
    var viewController: DevicesSearchViewController?
    var peripheral: CBPeripheral?
    
    
    
    func configure(name: String) {
        guard let controller = viewController, let selectedPeripheral = peripheral else { return }
        connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        deviceName.text = name
        if controller.addedDevices.contains(selectedPeripheral) {
            addToListButton.setImage(UIImage(named: "check"), for: .normal)
        }
    }
}
