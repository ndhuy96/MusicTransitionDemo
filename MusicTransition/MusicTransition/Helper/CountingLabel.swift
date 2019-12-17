//
//  CountingLabel.swift
//  MusicTransition
//
//  Created by mac on 8/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    private let counterExponent: Float = 3.0
    
    enum CounterAnimationType {
        case Linear
        case EaseIn
        case EaseOut
    }
    
    enum CounterType {
        case Int
        case Float
    }
    
    private var startNumber: Float = 0.0
    private var endNumber: Float = 0.0
    
    private var progress: TimeInterval!
    private var duration: TimeInterval!
    private var lastUpdate: TimeInterval!
    
    private var timer: Timer?
    
    private var counterType: CounterType!
    private var counterAnimationType: CounterAnimationType!
    
    private var currentCounterValue: Float {
        if progress >= duration {
            return endNumber
        }
        
        let percentage = Float(progress/duration)
        let update = updateCounter(counterValue: percentage)
        
        return startNumber + (update * (endNumber - startNumber))
    }
    
    func count(fromValue: Float, to toValue: Float, withDuration duration: TimeInterval, andAnimationType animationType: CounterAnimationType, andCounterType counterType: CounterType) {
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterType = counterType
        self.counterAnimationType = animationType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        invalidateTimer() // Reset timer
        
        if duration == 0 {
            updateText(toValue)
            return 
        }
        
        // Setup timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateValue), userInfo: nil, repeats: true)
    }
    
    @objc
    private func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        progress = progress + (now - lastUpdate) // calculate a progress
        lastUpdate = now
        
        if progress >= duration {
            invalidateTimer() // Reset timer
            progress = duration
        }
        
        // UpdateText in Label
        updateText(currentCounterValue)
    }
    
    private func updateText(_ value: Float) {
        switch counterType! {
        case .Int:
            self.text = "\(Int(value))"
        case .Float:
            self.text = String(format: "%.2f", value)
        }
    }
    
    private func updateCounter(counterValue: Float) -> Float {
        switch counterAnimationType! {
        case .Linear:
            return counterValue
        case .EaseIn:
            return powf(counterValue, counterExponent) // exponent method for float
        case .EaseOut:
            return 1.0 - powf(1.0 - counterValue, counterExponent)
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
