//
//  SSBluetoothManager.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SessionDelegate: class {
    func didUpdateSessionModel(sessionViewModel: SessionViewModel)
}

class SSBluetoothManager: NSObject {
    
    // Shared Manager singleton
    static let sharedManager = SSBluetoothManager()
    
    private let centralManager: CBCentralManager
    private var smartSnipePeripheral: CBPeripheral?
    private var transmitCharacteristic: CBCharacteristic?
    private var receiveCharacteristic: CBCharacteristic?
    
    weak var sessionDelegate: SessionDelegate?
    
    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue.main, options: nil)
        super.init()
        centralManager.delegate = self
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func startSession() {
        let jsonDictionary: [String: Any] = [
            "session_in_progress": true
        ]
        guard let smartSnipePeripheral = self.smartSnipePeripheral,
            let receiveCharacteristic = self.receiveCharacteristic,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary,
                                                       options: JSONSerialization.WritingOptions()) else { return }

        smartSnipePeripheral.writeValue(jsonData, for: receiveCharacteristic, type: .withResponse)
    }
    
    func endSession() {
        let jsonDictionary: [String: Any] = [
            "session_in_progress": false
        ]
        guard let smartSnipePeripheral = self.smartSnipePeripheral,
            let receiveCharacteristic = self.receiveCharacteristic,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions()) else { return }

        smartSnipePeripheral.writeValue(jsonData, for: receiveCharacteristic, type: .withResponse)
    }
    
    func updateNextHole(hole: HockeyNetHole) {
        let jsonDictionary: [String: Any] = [
            "hole_to_open": hole.rawValue
        ]
        guard let smartSnipePeripheral = self.smartSnipePeripheral,
            let receiveCharacteristic = self.receiveCharacteristic,
            let holeJSONData = try? JSONSerialization.data(withJSONObject: jsonDictionary,
                                                           options: JSONSerialization.WritingOptions()) else { return }
        
        smartSnipePeripheral.writeValue(holeJSONData, for: receiveCharacteristic, type: .withResponse)
    }
    
    func updateSettings(settingsViewModel: SettingsViewModel) {
        guard let smartSnipePeripheral = self.smartSnipePeripheral,
            let receiveCharacteristic = self.receiveCharacteristic,
            let settingsJSON = try? JSONEncoder().encode(settingsViewModel) else { return }
        smartSnipePeripheral.writeValue(settingsJSON,
                                        for: receiveCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }
}

extension SSBluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == CBManagerState.poweredOn) {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // if discovers hockey net peripheral, keep reference and stop scanning
        if (peripheral.name == "OBC-UART" || peripheral.name == "obc") {
            self.smartSnipePeripheral = peripheral
            self.centralManager.stopScan()
            self.centralManager.connect(peripheral, options: nil)
            peripheral.delegate = self
            peripheral.discoverServices(nil)
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
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics {
            if (characteristic.uuid.uuidString == "6E400002-B5A3-F393-E0A9-E50E24DCCA9E") {
                // receive characteristic
                self.receiveCharacteristic = characteristic
            } else if (characteristic.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") {
                // transmit char
                self.transmitCharacteristic = characteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let decoder = JSONDecoder()
        guard let data = characteristic.value,
            let sessionModel = try? decoder.decode(SessionViewModel.self, from: data) else { return }
        sessionDelegate?.didUpdateSessionModel(sessionViewModel: sessionModel)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // Called after writing to peripheral
    }
}
