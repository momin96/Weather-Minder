//
//  WeatherListView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import SwiftUI

struct WeatherListView: View {
    
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = WeatherListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        ForEach(viewModel.cities, id: \.id) { city in
                            WeatherCard(city: city)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText,
                        prompt: Text("Enter cities name by comma separated"))
            .onChange(of: viewModel.searchText) { newValue in
                viewModel.shouldEnabledSearch(from: newValue)
            }
            .onSubmit(of: .search) {
                viewModel.performSearch(with: viewModel.searchText)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    }
                }
            }
            .disableAutocorrection(viewModel.disableSearchButton)
            .navigationTitle("Search for city")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WeatherCard: View {
    
    var city: City
    var body: some View {
        VStack(alignment: .leading) {
            Text("In \(city.name)")
            city.weather.map { response in
                VStack(alignment: .leading) {
                    Text(response.main.minimumaAndMaximumTempreture)
                    Text(response.wind.windSpeedString)
                    
                    WeatherDescriptionView(weather: response.weather)
                }
            }
        }
    }
}

struct WeatherDescriptionView: View {
    let weather: [Weather]
    var body: some View {
        Group {
            ForEach(weather) { weather in
                Text(weather.weatherDescription)
            }
        }
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
