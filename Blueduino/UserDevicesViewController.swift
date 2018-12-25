//
//  UserDevicesViewController.swift
//  Blueduino
//
//  Created by Kirill Shteffen on 20/12/2018.
//  Copyright © 2018 BlackBricks. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftHSVColorPicker
import HGCircularSlider
import MTCircularSlider


class UserDevicesViewController: UIViewController {
    

    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var customColorButton: UIButton!
    @IBOutlet var customColorView: UIView!
    @IBOutlet weak var customColorWheel: UIView!
    
    @IBOutlet weak var userDeviceView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noUserDevices: UIView!
    @IBOutlet weak var devicesCountLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBAction func toSearch(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSearch", sender: nil)
    }
    
    @IBAction func pickColor(_ sender: UIButton) {
        
        self.view.addSubview(popoverView)
        userDeviceView.alpha = 0.4
        popoverView.center = self.view.center
        customColorButton.addDashedBorder()
    }
    
    @IBAction func customColor(_ sender: UIButton) {
        self.view.addSubview(customColorView)
        customColorView.center = self.view.center
//        let colorPicker = SwiftHSVColorPicker(frame: CGRect(x: -10, y: -10, width: 350, height: 350))
//        customColorWheel.addSubview(colorPicker)
//        colorPicker.setViewColor(UIColor.white)
        addCircleSlider(frame: CGRect(x: -10, y: -10, width: 350, height: 350))
    }
    
    @IBAction func closeCustomColor(_ sender: UIButton) {
        customColorView.removeFromSuperview()
        customColorWheel.removeFromSuperview()
    }
    
    var userDevices: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDevices.count != 0 {
            noUserDevices.isHidden = true
            devicesCountLabel.text = "Devices: \(String(userDevices.count))"
            
        }
    }
    
    func addCircleSlider(frame: CGRect) {
        let attributes = [
            /* Track */
            Attributes.minTrackTint(.lightGray),
            Attributes.maxTrackTint(.lightGray),
            Attributes.trackWidth(CGFloat(12)),
            Attributes.trackShadowRadius(CGFloat(0)),
            Attributes.trackShadowDepth(CGFloat(0)),
            Attributes.trackMinAngle(CGFloat(180)),
            Attributes.trackMaxAngle(CGFloat(270)),
            
            /* Thumb */
            Attributes.hasThumb(true),
            Attributes.thumbTint(UIColor.darkGray),
            Attributes.thumbRadius(8),
            Attributes.thumbShadowRadius(0),
            Attributes.thumbShadowDepth(0)
        ]
        
        let slider = MTCircularSlider(frame: frame)
        slider.applyAttributes(attributes)
        //self.slider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
        customColorView.addSubview(slider)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != popoverView {
            popoverView.removeFromSuperview()
            userDeviceView.alpha = 1
        }
    }
    
}

extension UserDevicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserDeviceCollectionViewCell", for: indexPath) as? UserDeviceCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(name: "DeviceName")
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
        if velocity.x > 1
             {
                pageControl.currentPage += 1
            localIndex.row = (localIndex.row) + 1
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
            
        }
        
        if velocity.x < -1 {
            pageControl.currentPage -= 1
            self.collectionView.scrollToItem(at: localIndex, at: .left, animated: true)
            
        }
        
        //slow swipe
        if velocity.x > -1 , velocity.x < 1,
            position > comparedCellWidth {
            localIndex.row = (localIndex.row) + 1
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
            
        }
        
        if velocity.x > -1 , velocity.x < 1,
            position < comparedCellWidth {
            self.collectionView.scrollToItem(at: localIndex , at: .left, animated: true )
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
