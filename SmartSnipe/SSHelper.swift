//
//  SSHelper.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2020-01-29.
//  Copyright © 2020 NickSentjens. All rights reserved.
//

import Foundation

class SSHelper {
    static func roundNum(number: Float, places: Int) -> Float {
        let multiplier = Float(truncating: pow(10.0, places) as NSNumber)
        return round(number * multiplier) / multiplier
    }
}
