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
    
    @State private var showWeatherList = false
    
    var body: some View {
        NavigationView {
            formView
                .refreshable {
                    viewModel.pullToRefresh()
                }
                .navigationTitle(viewModel.currentCityName + " Forecast")
                .foregroundColor(.orange)
                .navigationBarTitleDisplayMode(.automatic)
            
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            showWeatherList = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $showWeatherList) {
                    WeatherListView()
                }
        }.onAppear {
            viewModel.locationManager = locationManager
        }
    }
    
    @ViewBuilder
    var formView: some View {
        Form {
            if locationManager.locationError != nil {
                ErrorView(errorMessage: "Unable to fetch your current Location")
            } else {
                ForEach(viewModel.dateGroups, id: \.id ) { dateGroup in
                    Section {
                        WeatherDetailsList(forecastList: dateGroup.items)
                    } header: {
                        Text(dateGroup.header)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

struct WeatherDetailsList: View {
    
    let forecastList: [WeatherDetail]
    
    var body: some View {
        List(forecastList, id: \.id) { detail in
            WeatherDetailCard(detail: detail)
        }
    }
}

private struct WeatherDetailCard: View {
    let detail: WeatherDetail

    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Image(systemName: "stopwatch")
                Text(DateTimeFormatter.stringInFormat_hhmma(for: detail.dt))
            }
            .foregroundColor(.purple)
            .font(.title3)
            
            WeatherTempretureView(main: detail.main)
            WeatherWindView(wind: detail.wind)
            WeatherDescriptionView(weather: detail.weather)
        }
        .imageScale(.large)
    }
}
