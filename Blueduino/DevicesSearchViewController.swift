//
//  DevicesSearchViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class DevicesSearchViewController: UIViewController {

    @IBOutlet weak var noDevicesView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func scanForDevices(_ sender: UIButton) {
        CentralBluetoothManager.default.foundDevices = []
        collectionView.reloadData()
        noDevicesView.isHidden = false
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [multiLightCBUUID])
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "ShowUserDevices", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CentralBluetoothManager.default.foundDevices = []
        CentralBluetoothManager.default.viewController = self
        CentralBluetoothManager.default.centralManager.scanForPeripherals(withServices: [multiLightCBUUID])
        if CentralBluetoothManager.default.foundDevices.count != 0 {
            noDevicesView.isHidden = true
            collectionView.reloadData()
        }
//        noDevicesView.isHidden = true
    }
    
}

extension DevicesSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CentralBluetoothManager.default.foundDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LightDeviceCollectionViewCell", for: indexPath) as? LightDeviceCollectionViewCell, let deviceName = CentralBluetoothManager.default.foundDevices[indexPath.row].name else {
            return UICollectionViewCell ()
        }
        //cell.delegate = userDevicesController
        cell.viewController = self
        cell.peripheral = CentralBluetoothManager.default.foundDevices[indexPath.row]
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

extension UIColor {
    
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

