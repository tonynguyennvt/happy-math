//
//  Happy_MathApp.swift
//  Happy Math
//
//  Created by Tony on 16/3/25.
//

import SwiftUI
import UIKit

@main
struct Happy_MathApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var localizationManager = LocalizationManager()
    @StateObject private var progressManager = ProgressManager()
    
    init() {
        // Force portrait orientation for the entire app
        AppDelegate.orientationLock = .portrait
    }
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
                .environmentObject(localizationManager)
                .environmentObject(progressManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
