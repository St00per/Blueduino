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

    @IBOutlet weak var collectionView: UICollectionView!
    
    var centralManager: CBCentralManager!
    var multiLightPeripheral: CBPeripheral!
    var multiLightCharacteristic: CBCharacteristic!
    
    var foundDevices: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
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
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        foundDevices.append(peripheral)
        collectionView.reloadData()
//        if peripheral.name == "JDY-08" {
//            multiLightPeripheral = peripheral
//            multiLightPeripheral.delegate = self
//            centralManager.stopScan()
//            centralManager.connect(multiLightPeripheral)}
    }
    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Connected!")
//        multiLightPeripheral.discoverServices(nil)
//    }
}

extension DevicesSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let devicesCount = foundDevices.count else { return 0 }
        return foundDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightDeviceCollectionViewCell", for: indexPath) as? LightDeviceCollectionViewCell, let deviceName = foundDevices[indexPath.row].name else {
            return UICollectionViewCell ()
        }
        cell.setLabel(name: deviceName)
        return cell
    }
    
    
    
    
}
