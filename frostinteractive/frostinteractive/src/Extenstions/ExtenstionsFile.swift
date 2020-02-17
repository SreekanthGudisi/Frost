//
//  ExtenstionsFile.swift
//  frostinteractive
//
//  Created by DWC-LAP-539 on 09/02/20.
//  Copyright © 2020 DWC-LAP-539. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}

