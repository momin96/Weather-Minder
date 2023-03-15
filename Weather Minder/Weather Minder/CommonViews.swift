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
        }
    }
}

struct WeatherWindView: View {
    let wind: Wind
    
    var body: some View {
        HStack {
            Image(systemName: "wind.circle")
            Text(wind.windSpeedString)
        }
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
            }
        }
    }
}
