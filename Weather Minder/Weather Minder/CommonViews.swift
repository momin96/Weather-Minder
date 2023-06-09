//
//  CommonViews.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 15/03/23.
//

import SwiftUI

struct WeatherTempretureView: View {
    let main: Main
    
    var body: some View {
        HStack {
            Image(systemName: "thermometer.sun.circle")
            Text("min: \(main.minimum)")
            Text("max: \(main.maximum)")
        }.foregroundColor(.blue)
    }
}

struct WeatherWindView: View {
    let wind: Wind
    
    var body: some View {
        HStack {
            Image(systemName: "wind.circle")
            Text(wind.windSpeedString)
        }
        .foregroundColor(.blue)
    }
}

struct WeatherDescriptionView: View {
    let weather: [Weather]
    var body: some View {
        Group {
            ForEach(weather) { weather in
                HStack {
                    Image(systemName: "smoke")
                    Text(weather.weatherDescription)
                }
                .foregroundColor(.gray)
            }
        }
    }
}

struct ErrorView: View {
    
    let errorMessage: String?
    
    var body: some View {
        HStack {
            Image(systemName: "bolt.trianglebadge.exclamationmark")
                .imageScale(.large)
                .padding()
            Text(errorMessage ?? "Unknow Error")
        }
        .padding(.horizontal, 10.0)
        .font(.headline)
        .foregroundColor(.red)
    }
}
