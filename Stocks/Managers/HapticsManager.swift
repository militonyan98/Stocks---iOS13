//
//  HapticsManager.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import Foundation
import UIKit

/// Object to manage haptics
final class HapticsManager {
    /// Singleton
    static let shared = HapticsManager()
    
    /// Private constructor
    private init() {}
    
    
    // MARK: - Public
    
    /// Vibrate slightly for selection
    public func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    
    /// Play haptic for given type interaction
    /// - Parameter type: Type to vibrate for
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
