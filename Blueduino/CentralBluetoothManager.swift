//
//  CentralBluetoothManager.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 09/01/2019.
//  Copyright © 2019 BlackBricks. All rights reserved.
//

import Foundation
import CoreBluetooth

let multiLightCBUUID = CBUUID(string: "0xFFE0")
let moduleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")

class CentralBluetoothManager: NSObject {
    
    public static let `default` = CentralBluetoothManager()
    
    var centralManager: CBCentralManager!
    var foundDevices: [CBPeripheral] = []
    var multiLightCharacteristic: CBCharacteristic!
    var userDevicesViewController: UserDevicesViewController?
    var searchViewController: DevicesSearchViewController?
    var isFirstDidLoad = true
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
}

extension CentralBluetoothManager: CBCentralManagerDelegate {
    
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
            if isFirstDidLoad {
                centralManager.scanForPeripherals(withServices: [multiLightCBUUID])
                
            }
        }

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if !CentralBluetoothManager.default.foundDevices.contains(peripheral) {
            CentralBluetoothManager.default.foundDevices.append(peripheral)
        }
        if isFirstDidLoad {
            UserDevicesManager.default.userDeviceInitialFilter()
            isFirstDidLoad = false
        }
        
        if UserDevicesManager.default.userDevices.count != 0 {
            userDevicesViewController?.collectionView.reloadData()
            userDevicesViewController?.noUserDevices.isHidden = true
            userDevicesViewController?.devicesCountLabel.text = "Devices: \(String(UserDevicesManager.default.userDevices.count))"
            userDevicesViewController?.pageControl.numberOfPages = UserDevicesManager.default.userDevices.count
        }
        
        print("\(CentralBluetoothManager.default.foundDevices.count) devices have found")
        guard let collectionView = searchViewController?.collectionView else { return }
        if CentralBluetoothManager.default.foundDevices.count != 0 {
            searchViewController?.noDevicesView.isHidden = true
        }
        collectionView.reloadData()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
    }
    
    func connect(peripheral: CBPeripheral) {
        
        centralManager.stopScan()
        print ("Scan stopped")
//        multiLightPeripheral = peripheral
        peripheral.delegate = self
        centralManager.connect(peripheral)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

extension CentralBluetoothManager: CBPeripheralDelegate {
    
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
                        CentralBluetoothManager.default.multiLightCharacteristic = characteristic
                        peripheral.writeValue(OnOff(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
                        peripheral.writeValue(frequency1000(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
//                        print ("Characteristic FFE2 is found! READY TO WRITE...")
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
}
