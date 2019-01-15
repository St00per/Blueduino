//
//  UserDevicesViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 20/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth

class UserDevicesViewController: UIViewController {
    
    let slider = MTCircularSlider(frame: CGRect(x: 12, y: 55, width: 350, height: 350))
    let colorPicker = SwiftHSVColorPicker(frame: CGRect(x: -10, y: -10, width: 350, height: 350))
    var selectedColor = UIColor.lightGray
    var selectedCustomColor: UIColor?
    let checkImage = UIImage(named: "check")
    
    
    @IBOutlet weak var colorButtonsView: UIView!
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var customColorButton: UIButton!
    
    @IBOutlet var customColorView: UIView!
    @IBOutlet weak var customColorWheel: UIView!
    @IBOutlet weak var gradientRing: UIImageView!
    
    @IBOutlet weak var userDeviceView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noUserDevices: UIView!
    @IBOutlet weak var devicesCountLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBAction func toSearch(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let desVC = mainStoryboard.instantiateViewController(withIdentifier: "DevicesSearchViewController") as? DevicesSearchViewController else {
            return
        }
        show(desVC, sender: nil)
    }
    
    
    @IBAction func removeDevice(_ sender: UIButton) {
        showAlert(title: "Warning", message: "Remove Device?")
    }
    
    @IBAction func colorSelection(_ sender: UIButton) {
        guard let buttonColor = sender.backgroundColor else { return }
        setPaletteColor(color: buttonColor, pressedButton: sender)
    }
    
    @IBAction func pickColor(_ sender: UIButton) {
//        let currentDevice = pageControl.currentPage
//        guard UserDevicesManager.default.userDevices[currentDevice].peripheral?.state == .connected else {
//            return
//        }
        self.view.addSubview(popoverView)
        collectionView.isUserInteractionEnabled = false
        userDeviceView.alpha = 0.4
        popoverView.center = self.view.center
        customColorButton.addDashedBorder()
    }
    
    @IBAction func customColor(_ sender: UIButton) {
        popoverView.isUserInteractionEnabled = false
        self.view.addSubview(customColorView)
        customColorView.center = self.view.center
        
        colorPicker.setViewColor(UIColor.white)
        colorPicker.delegate = self
        customColorWheel.addSubview(colorPicker)
        
        сircleSliderConfigure()
        gradientRing.tintColor = colorPicker.color
        customColorView.insertSubview(slider, aboveSubview: customColorWheel)
    }
    
    @IBAction func closeCustomColor(_ sender: UIButton) {
        customColorView.removeFromSuperview()
        slider.removeFromSuperview()
        popoverView.isUserInteractionEnabled = true
    }
    
    
    @IBAction func customColorDone(_ sender: UIButton) {
        
        guard let buttons = colorButtonsView.subviews as? [UIButton] else { return }
        for button in buttons {
            button.setImage(nil, for: .normal)
        }
        
        sendColorToDevice(color: colorPicker.color)
        
        customColorView.removeFromSuperview()
        slider.removeFromSuperview()
        popoverView.removeFromSuperview()
        userDeviceView.alpha = 1
        popoverView.isUserInteractionEnabled = true
        collectionView.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        devicesCountLabel.text = "Devices: 0"
        pageControl.numberOfPages = 0
        CentralBluetoothManager.default.userDevicesViewController = self
        
        if UserDevicesManager.default.userDevices.count != 0 {
            noUserDevices.isHidden = true
            devicesCountLabel.text = "Devices: \(String(UserDevicesManager.default.userDevices.count))"
            pageControl.numberOfPages = UserDevicesManager.default.userDevices.count
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDevicesManager.default.userDevices.count != 0 {
            noUserDevices.isHidden = true
            devicesCountLabel.text = "Devices: \(String(UserDevicesManager.default.userDevices.count))"
            pageControl.numberOfPages = UserDevicesManager.default.userDevices.count
        }
        collectionView.reloadData()
    }

    
    fileprivate func showAlert(title: String?, message: String?) {
        guard
            let title = title,
            let message = message else {
                return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.removeDevice()
            }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func removeDevice() {
        let currentDevice = self.pageControl.currentPage
        
        var userDevices = UserDevicesManager.default.userDevices
        userDevices.remove(at: currentDevice)
        UserDevicesManager.default.userDevices = userDevices
        
        let defaults = UserDefaults.standard
        var addedDevicesNamesArray = defaults.stringArray(forKey: "AddedDevicesNames") ?? [String]()
        addedDevicesNamesArray.remove(at: currentDevice)
        defaults.set(addedDevicesNamesArray, forKey: "AddedDevicesNames")
        
        self.devicesCountLabel.text = "Devices: \(String(UserDevicesManager.default.userDevices.count))"
        self.pageControl.numberOfPages = UserDevicesManager.default.userDevices.count
        
        if UserDevicesManager.default.userDevices.count != 0 {
            self.noUserDevices.isHidden = true
        } else {
            self.noUserDevices.isHidden = false
        }
        self.collectionView.reloadData()
    }
    
    //Preparing colors to device sending
    struct ColorToSet {
        var redColor: UInt8 = 0
        var greenColor: UInt8 = 0
        var blueColor: UInt8 = 0
        var alpha: UInt8 = 0
    }
    
    func colorToHex(color: UIColor) -> ColorToSet {
        
        var сolorToSend = ColorToSet()
        let red = Int(color.redValue * 255)
        let green = Int(color.greenValue * 255)
        let blue = Int(color.blueValue * 255)
        let alpha = Int(color.alphaValue * 255)
 
        сolorToSend.redColor = UInt8(checkToZero(value: red))
        сolorToSend.greenColor = UInt8(checkToZero(value: green))
        сolorToSend.blueColor = UInt8(checkToZero(value: blue))
        сolorToSend.alpha = UInt8(checkToZero(value: alpha))
        return сolorToSend
    }
    
    func checkToZero(value: Int) -> Int {
        if value < 0 {
            return 0
        } else {
            return value
        }
    }
    
    func sendColorToDevice(color: UIColor) {
        UserDevicesManager.default.userDevices[pageControl.currentPage].color = color
        guard let peripheral = UserDevicesManager.default.userDevices[pageControl.currentPage].peripheral,
            let peripheralCharacteristic = CentralBluetoothManager.default.multiLightCharacteristic else { return }
        peripheral.writeValue(OnOff(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(frequency1000(), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        
        let sendedColor = colorToHex(color: color)
        
        peripheral.writeValue(colorRedCommand(colorValue: sendedColor.blueColor ), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(colorGreenCommand(colorValue: sendedColor.greenColor ), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
        peripheral.writeValue(colorBlueCommand(colorValue: sendedColor.redColor ), for: peripheralCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    
    func setPaletteColor(color: UIColor, pressedButton: UIButton) {
        

        guard let buttons = colorButtonsView.subviews as? [UIButton] else { return }
            for button in buttons {
                button.setImage(nil, for: .normal)
                    }
            UserDevicesManager.default.userDevices[pageControl.currentPage].color = color
            sendColorToDevice(color: color)
            pressedButton.setImage(checkImage, for: .normal)
            popoverView.removeFromSuperview()
            collectionView.isUserInteractionEnabled = true
            userDeviceView.alpha = 1
            collectionView.reloadData()
    }
    
    func сircleSliderConfigure()  {
        
        let attributes = [
            /* Track */
            Attributes.minTrackTint(UIColor.clear.withAlphaComponent(0.01)),
            Attributes.maxTrackTint(UIColor.clear.withAlphaComponent(0.01)),
            Attributes.trackWidth(CGFloat(35)),
            Attributes.trackShadowRadius(CGFloat(0)),
            Attributes.trackShadowDepth(CGFloat(0)),
            Attributes.trackMinAngle(CGFloat(-85)),
            Attributes.trackMaxAngle(CGFloat(265)),
            
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(UIColor.white),
            Attributes.thumbRadius(15),
            Attributes.thumbShadowRadius(16),
            Attributes.thumbShadowDepth(10)
        ]
        slider.isUserInteractionEnabled = true
        slider.applyAttributes(attributes)
        slider.addTarget(self, action: #selector(brightnessUpdate), for: .valueChanged)
    }
    
    @objc func brightnessUpdate() {
        
        let sliderAngle = slider.getThumbAngle()
        let brightness = (sliderAngle - 1.65)/6.11
        colorPicker.brightnessSelected(brightness)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != popoverView, popoverView.isUserInteractionEnabled != false {
            popoverView.removeFromSuperview()
            userDeviceView.alpha = 1
            collectionView.isUserInteractionEnabled = true
        }
        if touch?.view != customColorView, touch?.view != customColorWheel, touch?.view != slider, touch?.view != colorPicker {
            customColorView.removeFromSuperview()
            slider.removeFromSuperview()
            popoverView.isUserInteractionEnabled = true
        }
    }
    
    //Device commands functions
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
    
    func colorGreenCommand(colorValue: UInt8) -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA6)
        dataToWrite.append(colorValue)
        
        return dataToWrite
    }
    
    func colorRedCommand(colorValue: UInt8) -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA5)
        dataToWrite.append(colorValue)
        
        return dataToWrite
    }
    
    func colorBlueCommand(colorValue: UInt8) -> Data {
        
        var dataToWrite = Data()
        dataToWrite.append(0xE8)
        dataToWrite.append(0xA4)
        dataToWrite.append(colorValue)
        
        return dataToWrite
    }
    
}

extension UserDevicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDevicesManager.default.userDevices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDeviceCollectionViewCell", for: indexPath) as? UserDeviceCollectionViewCell else { return UICollectionViewCell() }
        cell.peripheral = UserDevicesManager.default.userDevices[indexPath.row].peripheral
        cell.peripheralCharacteristic = CentralBluetoothManager.default.multiLightCharacteristic
        cell.configure(name: UserDevicesManager.default.userDevices[indexPath.row].peripheral?.name ?? "Unnamed",
                       color: UserDevicesManager.default.userDevices[indexPath.row].color,
                       state: UserDevicesManager.default.userDevices[indexPath.row].deviceConnectionState)
        return cell
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.collectionView.indexPathsForVisibleItems
        indexes.sort()
        let index = indexes.first
        guard var localIndex = index else { return }
        let cell = self.collectionView.cellForItem(at: localIndex)
        let position = self.collectionView.contentOffset.x - (cell?.frame.origin.x ?? 0)
        let comparedCellWidth = (cell?.frame.size.width ?? 0)/2
        
        //fast swipe
        if velocity.x > 1, pageControl.currentPage < (UserDevicesManager.default.userDevices.count - 1) {
            pageControl.currentPage += 1
            localIndex.row = (localIndex.row) + 1
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
        }
        
        if velocity.x < -1, pageControl.currentPage > 0 {
            pageControl.currentPage -= 1
            self.collectionView.scrollToItem(at: localIndex, at: .left, animated: true)
        }
        
        //slow swipe
        if  velocity.x > -1 ,
            velocity.x < 1,
            position > comparedCellWidth {
            localIndex.row = (localIndex.row) + 1
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
            pageControl.currentPage = localIndex.row
        }
        
        if  velocity.x > -1 ,
            velocity.x < 1,
            position < comparedCellWidth {
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
            pageControl.currentPage = localIndex.row
        }
    }
}

extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension UserDevicesViewController: GradientRingDelegate {
    func updateGradientRingColor(color: UIColor) {
        gradientRing.tintColor = color
    }
}


