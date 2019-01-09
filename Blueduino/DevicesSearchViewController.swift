//
//  DevicesSearchViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

let multiLightCBUUID = CBUUID(string: "0xFFE0")
let moduleFunctionConfigurationCBUUID = CBUUID(string: "FFE2")



class DevicesSearchViewController: UIViewController {

    @IBOutlet weak var noDevicesView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func scanForDevices(_ sender: UIButton) {
        centralManager.scanForPeripherals(withServices: [multiLightCBUUID])
    }
    
    @IBAction func back(_ sender: UIButton) {
        print (UserDevices.default.userDevices.count)
        
        //show(UserDevicesViewController, sender: nil)
        performSegue(withIdentifier: "ShowUserDevices", sender: nil)
    }
    
    
    var centralManager: CBCentralManager!
    var multiLightPeripheral: CBPeripheral!
    var multiLightCharacteristic: CBCharacteristic!
    //var userDevicesController: UserDevicesViewController!
    
    var foundDevices: [CBPeripheral] = []
    var addedDevices: [CBPeripheral] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDevicesView.isHidden = true
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension DevicesSearchViewController: CBCentralManagerDelegate {
    
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
        if foundDevices.isEmpty {
            noDevicesView.isHidden = false
        } else {
            noDevicesView.isHidden = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        if !foundDevices.contains(peripheral) {
                foundDevices.append(peripheral)
        }
        collectionView.reloadData()
        if foundDevices.isEmpty {
            noDevicesView.isHidden = false
        } else {
            noDevicesView.isHidden = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        //multiLightPeripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected!")
    }
    
    func connect(peripheral: CBPeripheral) {
        centralManager.stopScan()
        multiLightPeripheral = peripheral
        multiLightPeripheral.delegate = self
        centralManager.connect(multiLightPeripheral)
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
}

extension DevicesSearchViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            //peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    

    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
//                    error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//
//        for characteristic in characteristics {
//            print(characteristic)
//
//            if characteristic.properties.contains(.write) {
//                print("\(characteristic.uuid): properties contains .write")
//                if characteristic.uuid == moduleFunctionConfigurationCBUUID {
//                    multiLightCharacteristic = characteristic
//                    peripheral.writeValue(OnOff(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
//                    peripheral.writeValue(frequency1000(), for: characteristic, type: CBCharacteristicWriteType.withResponse)
//                    print ("Characteristic FFE2 is found! READY TO WRITE...")
//                }
//            }
//        }
//    }
//
//
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard error == nil else {
//            print("Error discovering services: error")
//            return
//        }
//        print("Message sent")
//    }
}

extension DevicesSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightDeviceCollectionViewCell", for: indexPath) as? LightDeviceCollectionViewCell, let deviceName = foundDevices[indexPath.row].name else {
            return UICollectionViewCell ()
        }
        //cell.delegate = userDevicesController
        cell.viewController = self
        cell.peripheral = foundDevices[indexPath.row]
        cell.configure(name: deviceName)
        return cell
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

