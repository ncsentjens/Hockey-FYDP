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
    let heartDeviceInformationService = CBUUID(string: "180A")
    weak var sessionDelegate: SessionDelegate?
    
    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue.main, options: nil)
        super.init()
        centralManager.delegate = self
        self.centralManager.scanForPeripherals(withServices: [heartDeviceInformationService], options: nil)
    }
    
    func startSession() {
        guard let smartSnipePeripheral = self.smartSnipePeripheral, let transmitCharacteristic = self.transmitCharacteristic else { return }
        let jsonDictionary: [String: Any] = [
            "session_in_progress": true
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions()) as Data
            smartSnipePeripheral.writeValue(jsonData, for: transmitCharacteristic, type: CBCharacteristicWriteType.withResponse)
        } catch  {
            print("JSON Error")
        }
    }
    
    func endSession() {
        guard let smartSnipePeripheral = self.smartSnipePeripheral, let transmitCharacteristic = self.transmitCharacteristic else { return }
        let jsonDictionary: [String: Any] = [
            "session_in_progress": false
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions()) as Data
            smartSnipePeripheral.writeValue(jsonData, for: transmitCharacteristic, type: CBCharacteristicWriteType.withResponse)
        } catch  {
            print("JSON Error")
        }
    }
    
    func writeData(hole: HockeyNetHole) {
        guard let smartSnipePeripheral = self.smartSnipePeripheral, let transmitCharacteristic = self.transmitCharacteristic else { return }
        let jsonDictionary: [String: Any] = [
            "hole_to_open": hole.rawValue
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions()) as Data
            smartSnipePeripheral.writeValue(jsonData, for: transmitCharacteristic, type: CBCharacteristicWriteType.withResponse)
        } catch  {
            print("JSON Error")
        }
    }
    
    func writeData(settingsViewModel: SettingsViewModel) {
        guard let smartSnipePeripheral = self.smartSnipePeripheral, let transmitCharacteristic = self.transmitCharacteristic else { return }

        let jsonDictionary: [String: Any] = [
            "time_between_openings": settingsViewModel.timeBetweenOpenings,
            "time_slot_is_open": settingsViewModel.timeSlotIsOpen,
            "number_of_slots_that_open": settingsViewModel.numberOfSlotsThatOpen,
            "current_mode": settingsViewModel.currentMode.rawValue
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions()) as Data
            smartSnipePeripheral.writeValue(jsonData, for: transmitCharacteristic, type: CBCharacteristicWriteType.withResponse)
        } catch  {
            print("JSON Error")
        }
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
        if (peripheral.name == "Blood Pressure" || advertisementData["kCBAdvDataLocalName"] as? String == "Blood Pressure") {
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
            // Look for services we care about, should be one service with tx and rx
            // Blood pressure service
            if (service.uuid.uuidString == "1810") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let serviceCharacteristics = service.characteristics else { return }
        for characteristic in serviceCharacteristics {
            // Characteristic we care about
            if (characteristic.uuid.uuidString == "2A36") {
                // reading is good but can get notied as well
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        // parse data
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            guard let sessionData = json else { return }
            let shots = sessionData["shots"] as! Int
            let goals = sessionData["goals"] as! Int
            let averageShotSpeed = sessionData["average_shot_speed"] as! Float
            let averageReactionTime = sessionData["average_reaction_time"] as! Float
            let fastestShot = sessionData["fastest_shot"] as! Float
            let quickestReactionTime = sessionData["quickest_reaction_time"] as! Float
            let sessionViewModel = SessionViewModel(shots: shots,
                                                    goals: goals,
                                                    averageShotSpeed: averageShotSpeed,
                                                    averageReactionTime: averageReactionTime,
                                                    fastestShot: fastestShot,
                                                    quickestReactionTime: quickestReactionTime,
                                                    sessionDate: Date())
            SSBluetoothManager.sharedManager.sessionDelegate?.didUpdateSessionModel(sessionViewModel: sessionViewModel)
        } catch {
            print("error")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard let error = error else { return }
        print("error")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // Called after writing to peripheral
    }
}
