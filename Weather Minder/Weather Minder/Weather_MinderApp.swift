//
//  Weather_MinderApp.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import SwiftUI

@main
struct Weather_MinderApp: App {
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationManager)
        }
    }
}
