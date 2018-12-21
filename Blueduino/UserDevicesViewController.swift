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

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noUserDevices: UIView!
    @IBOutlet weak var devicesCountLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBAction func toSearch(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSearch", sender: nil)
    }
    
    var userDevices: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDevices.count != 0 {
            noUserDevices.isHidden = true
            devicesCountLabel.text = "Devices: \(String(userDevices.count))"
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage += 1
    }
    
}
