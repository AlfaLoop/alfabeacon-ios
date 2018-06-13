//
//  Defaults.swift
//  AlfaBeacon
//
//  Created by kuasmis.wmc on 2018/6/4.
//  Copyright © 2018 AlfaLoop. All rights reserved.
//

import Foundation


class Defaults : NSObject {
    let BeaconIdentifier = "com.alfaloop.ios.AlfaBeacon"
//        let supportedProximityUUIDs = [NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, NSUUID(UUIDString: "74278BDA-B644-4520-8F0C-720EAF059935")!]
    let supportedProximityUUIDs = [NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!, NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, NSUUID(UUIDString: "74278BDA-B644-4520-8F0C-720EAF059935")!]
    let defaultPower = -61
    
    func defaultProximityUUID() -> NSUUID {
        return supportedProximityUUIDs[0]
    }
}
