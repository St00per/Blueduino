//
//  ViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 18/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

//let multiLightCBUUID = CBUUID(string: "0xFFE0")
//let moduleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")


class MultiLightViewController: UIViewController {

    var centralManager: CBCentralManager!
    var multiLightPeripheral: CBPeripheral!
    var multiLightCharacteristic: CBCharacteristic!
    
    @IBAction func lightOn(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lightsOn(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    @IBAction func lightOff(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lightsOff(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    @IBAction func light10(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lights10(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    @IBAction func light30(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lights30(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    @IBAction func light50(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lights50(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    @IBAction func light90(_ sender: UIButton) {
        multiLightPeripheral.writeValue(lights90(), for: multiLightCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
    
    func OnOff() -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA1)
        dataToWrite.append(0x02)
        
        return dataToWrite
    }
    
    func frequency1000() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA2)
        dataToWrite.append(0x03)
        dataToWrite.append(0xE8)
        
        return dataToWrite
    }
    
    func lightsOn() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0x00)
        
        return dataToWrite
    }
    
    func lightsOff() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0xFF)
        
        return dataToWrite
    }
    
    func lights10() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0xCA)
        
        return dataToWrite
    }
    
    func lights30() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0x7D)
        
        return dataToWrite
    }
    
    func lights50() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0x4C)
        
        return dataToWrite
    }
    
    func lights90() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0x19)
        
        return dataToWrite
    }
    
}


