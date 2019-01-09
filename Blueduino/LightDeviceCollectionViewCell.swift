//
//  LightDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol DevicesSearchDelegate {
    func addDevices(addedDevices: [CBPeripheral])
    
}

class LightDeviceCollectionViewCell: UICollectionViewCell {
    
    var viewController: DevicesSearchViewController?
    var peripheral: CBPeripheral?
    
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    
    @IBAction func connect(_ sender: UIButton) {
        guard let selectedPeripheral = peripheral else { return }
        if connectButton.titleLabel?.text == "DISCONNECT" {
            CentralBluetoothManager.default.disconnect(peripheral: selectedPeripheral)
            connectButton.setTitle("CONNECT", for: .normal)
            connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        } else {
            CentralBluetoothManager.default.connect(peripheral: selectedPeripheral)
            connectButton.backgroundColor = UIColor(hexString: "#CC4242", alpha: 0.6)
            connectButton.setTitle("DISCONNECT", for: .normal)
        }
    }
    
    @IBAction func addToList(_ sender: UIButton) {
        guard  let selectedPeripheral = peripheral else { return }
        let appendedDevice = UserDevice()
        appendedDevice.peripheral = selectedPeripheral
        
        UserDevicesManager.default.userDevices.append(appendedDevice)
        
        addToListButton.setImage(UIImage(named: "check"), for: .normal)
    }
    
    func configure(name: String) {

        connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
        deviceName.text = name
//        if UserDevices.default.userDevices.contains(selectedPeripheral) {
//            addToListButton.setImage(UIImage(named: "check"), for: .normal)
//        }
    }
}
