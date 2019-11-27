//
//  SSBluetoothManager.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import CoreBluetooth

class SSBluetoothManager: NSObject {
    
    // Shared Manager singleton
    static let sharedManager = SSBluetoothManager()
    
    private let centralManager: CBCentralManager
    private var smartSnipePeripheral: CBPeripheral?
    
    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil, options: nil)
        super.init()
        self.centralManager.delegate = self
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }
}

extension SSBluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == CBManagerState.poweredOn) {
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // if discovers hockey net peripheral, keep reference and stop scanning
        if (true) {
            self.smartSnipePeripheral = peripheral
            self.centralManager.stopScan()
            self.centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension SSBluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            // Look for services we care about
            if (true) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics {
            // Characteristic we care about
            if (true) {
                // reading is good but can get notied as well
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        // parse data
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // Called after writing to peripheral
    }
}
