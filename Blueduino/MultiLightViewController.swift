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
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
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

extension MultiLightViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
       
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [multiLightCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if peripheral.name == "JDY-08" {
        multiLightPeripheral = peripheral
        multiLightPeripheral.delegate = self
        centralManager.stopScan()
            centralManager.connect(multiLightPeripheral)}
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        multiLightPeripheral.discoverServices(nil)
    }
}

extension MultiLightViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)

            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
            if characteristic.uuid == moduleFunctionConfigurationCBUUID {
                multiLightCharacteristic = characteristic
                peripheral.writeValue(OnOff(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
                peripheral.writeValue(frequency1000(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
                print ("Characteristic FFE2 is found! READY TO WRITE...")
                }
            }
        }
    }
    

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Message sent")
    }
}
