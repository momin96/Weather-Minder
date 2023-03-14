//
//  HomeView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import CoreLocation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            WeatherListView()
            locationManager.currentLocation.map { location in
                HStack {
                    Text("\(location.coordinate.latitude)")
                    Text("  \(location.coordinate.longitude)")

                }
            }
        }
    }
}

class HomeViewModel {
    init() {
    }
}
