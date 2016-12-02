//
//  ConstructableStorage.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/10/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import Foundation

class ConstructableStorage<C: Constructable> {
    
    fileprivate let storagePath: AnyObject
    fileprivate let storageFileName: String
    
    fileprivate let ACTIVATION_KEY = "activation"
    fileprivate let NEW_FLAG_KEY = "new_flag"
    
    fileprivate(set) var activationSet = Set<Int>()
    fileprivate var newFlagSet = Set<Int>()
    
    init(storageFileName: String) {
        NSLog("Initializing ConstructableStorage from file %@", storageFileName)
        
        self.storageFileName = storageFileName
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            storagePath = paths[0] as AnyObject
            readData()
        } else {
            fatalError("unable to locate storage")
        }
    }
    
    fileprivate func path() -> String {
        return storagePath.appendingPathComponent(storageFileName)
    }
    
    fileprivate func readData() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: path()))
        if data != nil {
            let archiver = NSKeyedUnarchiver(forReadingWith: data!)
            activationSet = Set((archiver.decodeObject(forKey: ACTIVATION_KEY) as? Array<Int>) ?? [])
            newFlagSet = Set((archiver.decodeObject(forKey: NEW_FLAG_KEY) as? Array<Int>) ?? [])
            archiver.finishDecoding()
        }
        NSLog("ConstructableStorage read finished, data: %@", activationSet.debugDescription)
    }
    
    fileprivate func writeData() -> Bool {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(Array(activationSet), forKey: ACTIVATION_KEY)
        archiver.encode(Array(newFlagSet), forKey: NEW_FLAG_KEY)
        archiver.finishEncoding()
        
        return data.write(toFile: path(), atomically: true)
    }
    
    func isActivated(_ item: C) -> Bool {
        return activationSet.contains(item.id)
    }
    
    func hasNewFlag(_ item: C) -> Bool {
        return newFlagSet.contains(item.id)
    }
    
    func activate(_ item: C) -> Bool {
        if isActivated(item) {
            return true
        } else {
            activationSet.insert(item.id)
            newFlagSet.insert(item.id)
            return writeData()
        }
    }
    
    func clearActivated() -> Bool {
        activationSet.removeAll()
        newFlagSet.removeAll()
        return writeData()
    }
    
    func clearNewFlag() -> Bool {
        newFlagSet.removeAll()
        return writeData()
    }
}
