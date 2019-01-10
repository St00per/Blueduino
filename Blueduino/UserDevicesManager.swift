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
}

class UserDevice: NSObject {
    
    var peripheral: CBPeripheral? = nil
    
    var color = UIColor.lightGray
    
}
