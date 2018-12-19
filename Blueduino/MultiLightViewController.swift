//
//  ViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 18/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

let multiLightCBUUID = CBUUID(string: "0xFFE0")
let moduleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")
//let unhandledCharacteristicCBUUID = CBUUID(string: "0xFEC2")

class MultiLightViewController: UIViewController {

    var centralManager: CBCentralManager!
    var multiLightPeripheral: CBPeripheral!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func dataToWrite(data: String) -> Data {
        guard let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue) else { return Data()}
        return valueString
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

            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
            if characteristic.uuid == moduleFunctionConfigurationCBUUID {
                print ("Characteristic FFE2 is found! TRY TO WRITE...")
                peripheral.writeValue(dataToWrite(data: "E8A101"), for: characteristic, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
//                    error: Error?) {
//        switch characteristic.uuid {
//        case moduleFunctionConfigurationCBUUID:
//            print("FFE2 Properties: \(characteristic.properties)")
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
//    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Message sent")
    }

}
