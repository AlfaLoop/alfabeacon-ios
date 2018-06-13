//
//  LeDevice.swift
//  AlfaBeacon
//
//  Created by xiaoding.tw on 2018/6/4.
//  Copyright © 2018 AlfaLoop. All rights reserved.
//

import Foundation

struct LeDevice {
    var uuid: String!;
    var name: String?;
    var major: UInt16?;
    var minor: UInt16?;
    var rssi: NSNumber?;
}
