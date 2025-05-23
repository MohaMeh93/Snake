//
//  ChuckJoke.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/16/25.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherDescription: String = "Chargement..."
    
    func fetchWeather(for city: String) {
        let urlString = "https://wttr.in/\(city)?format=j1"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.weatherDescription = "Erreur de réseau"
                }
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                if let current = weatherResponse.current_condition.first {
                    let temp = current.temp_C
                    let desc = current.weatherDesc.first?.value ?? ""
                    let result = "🌡️ \(temp)°C, \(desc)"
                    DispatchQueue.main.async {
                        self.weatherDescription = result
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.weatherDescription = "Erreur décodage météo"
                }
            }
        }.resume()
    }
}

struct WeatherResponse: Decodable {
    let current_condition: [CurrentCondition]
    
    struct CurrentCondition: Decodable {
        let temp_C: String
        let weatherDesc: [WeatherDesc]
        
        struct WeatherDesc: Decodable {
            let value: String
        }
    }
}

