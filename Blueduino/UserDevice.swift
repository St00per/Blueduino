//
//  UserDevice.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 29/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

class UserDevices {
    
    public static let `default` = UserDevices()
    
    var userDevices: [UserDevice] = []
}

class UserDevice {
    
    var peripheral: CBPeripheral? = nil
    
    var color = UIColor.white
    
}
