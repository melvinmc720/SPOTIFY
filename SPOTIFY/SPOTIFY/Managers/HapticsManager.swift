//
//  HapticsManager.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit
import Foundation

final class HapticsManager{
    
    static let shared:HapticsManager = HapticsManager()
    
    public func vibrateForSelection(){
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
    
    

}
