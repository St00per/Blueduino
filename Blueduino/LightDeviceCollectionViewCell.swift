//
//  LightDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 19/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class LightDeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    
    @IBOutlet weak var connectButton: UIButton!
    @IBAction func connect(_ sender: UIButton) {
        guard let controller = viewController, let selectedPeripheral = peripheral else { return }
        controller.connect(peripheral: selectedPeripheral)
        connectButton.backgroundColor = UIColor(hexString: "#CC4242", alpha: 0.6)
        connectButton.setTitle("DISCONNECT", for: .normal)
    }
    
    var viewController: DevicesSearchViewController?
    var peripheral: CBPeripheral?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
    }
    
    func setLabel(name: String) {
        deviceName.text = name
    }
}
