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
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(viewModel.dateGroups, id: \.id ) { dateGroup in
                    Section {
                        WeatherDetailsList(forecastList: dateGroup.items)
                    } header: {
                        Text(dateGroup.header)
                    }
                }
            }
            .navigationTitle("5 days forcast for " + viewModel.currentCityName)
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            viewModel.locationManager = locationManager
        }
    }
}

struct WeatherDetailsList: View {
    
    let forecastList: [WeatherDetail]
    
    var body: some View {
        List(forecastList, id: \.id) { detail in
            WeatherDetailCard(weatherDetail: detail)
        }
    }
}

private struct WeatherDetailCard: View {
    let weatherDetail: WeatherDetail

    var body: some View {
        LazyVStack(alignment: .leading) {
            
            HStack {
                Image(systemName: "stopwatch")
                    .imageScale(.large)
                Text(DateTimeFormatter.stringInFormat_hhmma(for: weatherDetail.dt))
            }
            
            HStack {
                Image(systemName: "thermometer.sun.circle")
                    .imageScale(.large)
                Text("min: \(weatherDetail.main.minimum)")
                Text("max: \(weatherDetail.main.maximum)")
            }
        }
    }
}
