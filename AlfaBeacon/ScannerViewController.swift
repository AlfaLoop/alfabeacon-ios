//
//  ScannerViewController.swift
//  AlfaBeacon
//
//  Created by kuasmis.wmc on 2018/4/9.
//  Copyright © 2018 AlfaLoop. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ScannerViewController: UIViewController{

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var beaconTableView: UITableView!
    
    let backgroundColor = UIColor(red: 249.0/255.0, green: 250.0/255.0, blue: 252.0/255.0, alpha: 1.0)
    var manager : CBCentralManager!
    var discoveredPeripheralsArr :[CBPeripheral?] = []
    var rangedRegions = [CLBeaconRegion]()
    var discoveredBeacons = [String:[CLBeacon]]()
    var beacons = [CLBeacon]()

    var discoveredDevices : Dictionary<String , LeDevice>!;
    
    //连接的外围
    var connectedPeripheral : CBPeripheral!
    //保存的设备特性
    var savedCharacteristic : CBCharacteristic!
    
    var isScanning : Bool!
    
    var lastString : NSString!
    var sendString : NSString!
    var leftButton : UIButton!
    var locationManager: CLLocationManager!
    let kAlfaBeaconClass = CBUUID(string: "A55A");


    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = UIColor(red: 40.0/255.0, green: 171.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        navBar?.tintColor = UIColor.white
        navBar?.isTranslucent = false
        navBar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        searchBar.barTintColor = backgroundColor
        
        leftButton = UIButton.init(type: UIButtonType.custom)
        leftButton.frame = CGRect(x: 0,y: 0,width: 60,height: 20)
        leftButton.setTitle("Start", for: UIControlState.normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        leftButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        locationManager = CLLocationManager()
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                locationManager.requestAlwaysAuthorization()
            }
        }
        
        locationManager.delegate = self

        isScanning = false
        discoveredDevices = [String : LeDevice]()

        beaconTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
  
    @objc func clickButton() {
        if !isScanning {
            discoveredDevices.removeAll()
            beaconTableView.reloadData()
            manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
//            self.startScanning()
            leftButton.setTitle("Stop", for: UIControlState.normal)
            isScanning = true
        } else {
             manager.stopScan()
//            self.stopScanning()
            leftButton.setTitle("Start", for: UIControlState.normal)
            isScanning = false
        }
        
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "AlfaBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopScanning() {
        let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "AlfaBeacon")
    
        locationManager.stopMonitoring(for: beaconRegion)
    }
}

extension ScannerViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.beacons.count
        return discoveredDevices.count
//        return discoveredPeripheralsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerCell", for: indexPath) as! ScannerTableViewCell
       
        let leDevice = Array(discoveredDevices.values)[indexPath.row]
        let rssiNumber: NSNumber = leDevice.rssi!
        var rssiValue = rssiNumber.int8Value
        var major = leDevice.major!
        var minor = leDevice.minor!

//        let beacon = self.beacons[indexPath.row]
//        var rssiValue =  beacon.rssi

//        var rssiValue = rssi?.intValue
        if (rssiValue < -80) {
            cell.rssiImageView.image = UIImage(named: "Signal_1")
        } else if (rssiValue < -60) {
            cell.rssiImageView.image = UIImage(named: "Signal_2")
        } else {
            cell.rssiImageView.image = UIImage(named: "Signal_3")
        }
        
//        cell.rssiLabel.text = "\(rssiValue)"
        cell.rssiLabel?.text = String.init(format: "%d", (rssiValue))
        cell.deviceName?.text = String.init(format: "%@", (leDevice.name)!)
        cell.ibeaconMajor?.text = String.init(format: "%d", (major))
        cell.ibeaconMinor?.text = String.init(format: "%d", (minor))

        cell.backgroundColor = backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPeripheral = discoveredPeripheralsArr[indexPath.row]
//        manager.connect(selectedPeripheral!, options: nil)
        
    }
}

extension ScannerViewController :CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("\(beacons)")
        
        self.beacons = beacons
        beaconTableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
//                    startScanning()
                }
            }
        }
    }
}


extension ScannerViewController :CBCentralManagerDelegate,CBPeripheralDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        switch central.state {
        case .unknown:
            print("CBCentralManagerStateUnknown")
        case .resetting:
            print("CBCentralManagerStateResetting")
        case .unsupported:
            print("CBCentralManagerStateUnsupported")
        case .unauthorized:
            print("CBCentralManagerStateUnauthorized")
        case .poweredOff:
            print("CBCentralManagerStatePoweredOff")
        case .poweredOn:
            print("CBCentralManagerStatePoweredOn")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
//        print("\(advertisementData)")

        let uuidString = peripheral.identifier.uuidString
        if (!isAlreadyFound(uuid: uuidString)) {
            if let data = advertisementData["kCBAdvDataServiceData"] as? [NSObject:AnyObject]{
                if let data = data[kAlfaBeaconClass] as? Data{
                    let byteArray = [UInt8](data)
                    var type = byteArray[0]
                    var battery = byteArray[1]
                    let major:UInt16 = UInt16(byteArray[2]) * 256 + UInt16(byteArray[3])
                    let minor:UInt16 = UInt16(byteArray[4]) * 256 + UInt16(byteArray[5])
                    var txm = byteArray[6]
                    print("major: \(major) minor: \(minor)")
                    // only show major == 1001 (debug)
                    if (major == 1001) {
                        insertFoundDevice(newUuid: uuidString, newName: peripheral.name, newMajor: major, newMinor: minor, rssi: RSSI)
                    }
                }
            }
        } else {
            discoveredDevices[uuidString]?.rssi = RSSI
        }
        beaconTableView.reloadData()
    }
    
    func isAlreadyFound(uuid : String!) -> Bool {
        return discoveredDevices[uuid] != nil;
    }
    
    func insertFoundDevice(newUuid: String!, newName: String?, newMajor: UInt16, newMinor: UInt16, rssi: NSNumber?) {
        let leDevice = LeDevice(uuid: newUuid, name: newName, major: newMajor, minor: newMinor, rssi: rssi);
        discoveredDevices[newUuid] = leDevice;
    }
    
    //连接上
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        connectedPeripheral = peripheral
        //外设寻找service
        peripheral .discoverServices(nil)
        
        peripheral.delegate = self
        self.title = peripheral.name
        manager .stopScan()
    }
    
    //连接到Peripherals-失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("连接到名字为 \(peripheral.name) 的设备失败，原因是 \(error?.localizedDescription)")
        
    }
    ///断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("连接到名字为 \(peripheral.name) 的设备断开，原因是 \(error?.localizedDescription)")
        
        let alertView = UIAlertController.init(title: "抱歉", message: "蓝牙设备\(peripheral.name)连接断开，请重新扫描设备连接", preferredStyle: UIAlertControllerStyle.alert)
        alertView.show(self, sender: nil)
        
    }
    // CBPeripheralDelegate
    
    //扫描到Services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        
        if (error != nil){
            print("查找 services 时 \(peripheral.name) 报错 \(error?.localizedDescription)")
        }
    }
    
    
    //扫描到 characteristic
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        if error != nil{
            print("查找 characteristics 时 \(peripheral.name) 报错 \(error?.localizedDescription)")
        }
        
        //获取Characteristic的值，读到数据会进入方法：
        //        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
        
        for characteristic in service.characteristics! {
            peripheral .readValue(for: characteristic)
            
            
            //设置 characteristic 的 notifying 属性 为 true ， 表示接受广播
            
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    
    //获取的charateristic的值
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        let resultStr = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
        
        print("characteristic uuid:\(characteristic.uuid)   value:\(resultStr)")
        
        if lastString == resultStr{
            return;
        }
        
        // 操作的characteristic 保存
        self.savedCharacteristic = characteristic
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?){
        if error != nil{
            print("写入 characteristics 时 \(peripheral.name) 报错 \(error?.localizedDescription)")
        }
        
        let alertView = UIAlertController.init(title: "抱歉", message: "写入成功", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction.init(title: "好的", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        alertView.show(self, sender: nil)
        lastString = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
        
    }
    
}
