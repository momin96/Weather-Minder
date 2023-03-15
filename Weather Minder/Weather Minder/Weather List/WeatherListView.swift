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
            bodyView
            .searchable(text: $viewModel.searchText,
                        prompt: Text("Enter cities name by comma separated"))
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
            .navigationTitle("Search for city")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.errorAlert, content: {
                Alert(title: Text("Error: City Count"),
                      message: Text("Searchable cities must be between 3 and 7 with comma separated"),
                      dismissButton: .default(Text("Yeah Sure")) {
                    print("dismiss")
                })
            })
        }
    }
    
    @ViewBuilder
    var bodyView: some View {
        VStack {
            if viewModel.alertMessage != nil {
                ErrorView(errorMessage: viewModel.alertMessage)
            } else {
                Form {
                    List {
                        ForEach(viewModel.cities, id: \.id) { city in
                            WeatherCard(city: city)
                        }
                    }
                }
            }
        }
    }
}

struct WeatherCard: View {
    
    var city: City
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "mappin.circle")
                Text("In \(city.name)")
            }
            .foregroundColor(.purple)
            .font(.title3)
            
            city.weather.map { response in
                VStack(alignment: .leading) {
                    WeatherTempretureView(main: response.main)
                    WeatherWindView(wind: response.wind)
                    WeatherDescriptionView(weather: response.weather)
                }
            }
        }
    }
}


struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
