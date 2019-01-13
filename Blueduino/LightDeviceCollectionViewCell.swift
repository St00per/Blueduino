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
        guard  let selectedPeripheral = peripheral, addToListButton.titleLabel?.text == "ADD DEVICE" else { return }
        let appendedDevice = UserDevice()
        appendedDevice.peripheral = selectedPeripheral
        
        if !UserDevicesManager.default.userDevices.contains(appendedDevice) {
            UserDevicesManager.default.userDevices.append(appendedDevice)
        }
        let defaults = UserDefaults.standard
        var namesArray: [String] = []
        let userDevices = UserDevicesManager.default.userDevices
        for device in userDevices {
            guard let deviceName = device.peripheral?.name else { return }
            namesArray.append(deviceName)
        }
        defaults.set(namesArray, forKey: "AddedDevicesNames")
        addToListButton.setTitle("ADDED", for: .normal)
        addToListButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.6)
    }
    
    func configure(name: String) {
        deviceName.text = name
        let userDevices = UserDevicesManager.default.userDevices
        let foundDevices = CentralBluetoothManager.default.foundDevices
        var checkingDevices: [UserDevice] = []
            for device in foundDevices {
            let appendedDevice = UserDevice()
                appendedDevice.peripheral = device
                checkingDevices.append(appendedDevice)
            }
        for device in checkingDevices {
        if userDevices.contains(device) {
            addToListButton.setTitle("ADDED", for: .normal)
            addToListButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.6)
            }
        }
    }
}
