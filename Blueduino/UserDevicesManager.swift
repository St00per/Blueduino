//
//  UserDevice.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 29/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

class UserDevicesManager {
    
    public static let `default` = UserDevicesManager()
    
    var userDevices: [UserDevice] = []
    
    init() {}
    
    func userDeviceInitialFilter() {
        
        let foundDevices = CentralBluetoothManager.default.foundDevices
        let defaults = UserDefaults.standard
        let addedDevicesNamesArray = defaults.stringArray(forKey: "AddedDevicesNames") ?? [String]()
        
        if addedDevicesNamesArray.count != 0 {
            for device in foundDevices {
                guard let deviceName = device.name else { return }
                if addedDevicesNamesArray.contains(deviceName) {
                    let userDevice = UserDevice()
                    userDevice.peripheral = device
                    UserDevicesManager.default.userDevices.append(userDevice)
                }
            }
        }
    }
}

class UserDevice: Equatable {
    
    var peripheral: CBPeripheral? = nil
    var color = UIColor.lightGray
    var deviceConnectionState: DeviceConnectionState = .disconnected
    
    static func == (lhs: UserDevice, rhs: UserDevice) -> Bool {
        guard let first = lhs.peripheral, let second = rhs.peripheral else {
            return false
        }
        return first.identifier == second.identifier
    }
}
