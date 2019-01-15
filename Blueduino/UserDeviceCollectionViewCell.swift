//
//  UserDeviceCollectionViewCell.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 20/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class UserDeviceCollectionViewCell: UICollectionViewCell {
    
    
    var peripheral: CBPeripheral!
    var peripheralCharacteristic: CBCharacteristic!
    var deviceColor = UIColor.white
    let customSwitch = CustomSwitch(frame: CGRect(x: 0, y: 5, width: 55, height: 25))
    var connectionState: DeviceConnectionState = .disconnected

    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    @IBOutlet weak var switchView: UIView!
    
    
    @IBAction func ledOn(_ sender: UIButton) {
        guard peripheralCharacteristic != nil else { return }
        peripheralCharacteristic = CentralBluetoothManager.default.multiLightCharacteristic
//        peripheral.writeValue(OnOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
//        peripheral.writeValue(frequency1000(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        if customSwitch.isOn == true {
        peripheral.writeValue(lightsGreenOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(lightsRedOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(lightsBlueOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    @IBAction func ledOff(_ sender: UIButton) {
        guard peripheralCharacteristic != nil else { return }
        peripheralCharacteristic = CentralBluetoothManager.default.multiLightCharacteristic
//        peripheral.writeValue(OnOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
//        peripheral.writeValue(frequency1000(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        if customSwitch.isOn == false {
        peripheral.writeValue(lightsGreenOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(lightsRedOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(lightsBlueOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    
    @IBAction func connect(_ sender: UIButton) {
        guard let selectedPeripheral = peripheral else { return }
        if connectionState == .connecting {
            CentralBluetoothManager.default.disconnect(peripheral: selectedPeripheral)
            connectButton.setTitle("CONNECT", for: .normal)
            connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
            
        } else {
            CentralBluetoothManager.default.connect(peripheral: selectedPeripheral)
            
//            connectButton.backgroundColor = UIColor(hexString: "#EBC337", alpha: 0.8)
//            connectButton.setTitle("CONNECTING...", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //custom switch creating
        
        customSwitch.isOn = false
        customSwitch.onTintColor = deviceColor
        customSwitch.offTintColor = UIColor.lightGray
        customSwitch.cornerRadius = 0.5
        customSwitch.thumbCornerRadius = 0.5
        customSwitch.thumbSize = CGSize(width: 30, height: 30)
        customSwitch.thumbTintColor = UIColor.white
        customSwitch.padding = 0
        customSwitch.animationDuration = 0.25
        customSwitch.addTarget(self, action: #selector(ledSwitch), for: .valueChanged)
        
        switchView.addSubview(customSwitch)
    }
    
    @objc func ledSwitch() {
        peripheralCharacteristic = CentralBluetoothManager.default.multiLightCharacteristic
        guard peripheralCharacteristic != nil else { return }
        if customSwitch.isOn == true {
            peripheral.writeValue(lightsGreenOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
            peripheral.writeValue(lightsRedOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
            peripheral.writeValue(lightsBlueOn(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
        if customSwitch.isOn == false {
            peripheral.writeValue(lightsGreenOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
            peripheral.writeValue(lightsRedOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
            peripheral.writeValue(lightsBlueOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    func OnOff() -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA1)
        dataToWrite.append(0x02)
        
        return dataToWrite
    }
    
    func lightsGreenOn() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0x00)
        
        return dataToWrite
    }
    
    func lightsRedOn() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA5)
        dataToWrite.append(0x00)
        
        return dataToWrite
    }
    
    func lightsBlueOn() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA4)
        dataToWrite.append(0x00)
        
        return dataToWrite
    }
    
    func lightsBlueOff() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA4)
        dataToWrite.append(0xFF)
        
        return dataToWrite
    }
    
    func lightsRedOff() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA5)
        dataToWrite.append(0xFF)
        
        return dataToWrite
    }
    
    func lightsGreenOff() -> Data {
        
        var dataToWrite = Data()
        
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(0xFF)
        
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
    
    func configure(name: String, color: UIColor, state: DeviceConnectionState) {
        self.connectionState = state
        if state == .connected {
            connectButton.backgroundColor = UIColor(hexString: "#CC4242", alpha: 0.6)
            connectButton.setTitle("DISCONNECT", for: .normal)
        }
        if state == .connecting {
            connectButton.backgroundColor = UIColor(hexString: "#EBC337", alpha: 0.8)
            connectButton.setTitle("CONNECTING", for: .normal)
        }
        if state == .disconnected {
            connectButton.backgroundColor = UIColor(hexString: "#94ed74", alpha: 0.4)
            connectButton.setTitle("CONNECT", for: .normal)
        }
        
        pickColorButton.backgroundColor = color
        deviceName.text = name
        let compareColorBlueParameter = color.blueValue
        let compareColorGreenParameter = color.greenValue
        let compareColorRedParameter = color.redValue
        if (compareColorRedParameter > 0.8 && compareColorGreenParameter > 0.8) || (compareColorBlueParameter > 0.8 && compareColorGreenParameter > 0.8) {
            pickColorButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            pickColorButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
}
extension UserDeviceCollectionViewCell: BluetoothManagerConnectDelegate {
    
    func connectingStateSet() {
        connectButton.backgroundColor = UIColor(hexString: "#CC4242", alpha: 0.6)
        connectButton.setTitle("DISCONNECT", for: .normal)
    }
}
