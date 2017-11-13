//
//  Utils.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 25.09.17.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import Foundation

class Delay {
    private var timer: Timer?
    private let delayTime = 0.85
    
    // @escaping - сбегающее замыкание
    func delayTime(run: @escaping (() -> Void)) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: false) { _ in run() }
    }
}
