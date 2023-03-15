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
                        WeatherForecastList(forecastList: dateGroup.items)
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

struct WeatherForecastList: View {
    
    let forecastList: [WeatherDetail]
    
    var body: some View {
        List(forecastList, id: \.id) { list in
            /*@START_MENU_TOKEN@*/Text(list.dt_txt)/*@END_MENU_TOKEN@*/
        }
    }
}
