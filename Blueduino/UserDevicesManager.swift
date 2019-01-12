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
    
    var userDevices: [UserDevice] = [UserDevice(),UserDevice(),UserDevice()]
}

class UserDevice: Equatable {
    static func == (lhs: UserDevice, rhs: UserDevice) -> Bool {
        guard let first = lhs.peripheral, let second = rhs.peripheral else {
            return false
        }
        return first.identifier == second.identifier
    }
    
    
    
    
    var peripheral: CBPeripheral? = nil
    
    var color = UIColor.lightGray
    
}
