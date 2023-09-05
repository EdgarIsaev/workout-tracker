//
//  NetworkRequest.swift
//  MyFirstApp
//
//  Created by Эдгар Исаев on 03.05.2023.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(completion: @escaping(Result<Data, Error>) -> Void) {
        let key = "0501cb13159f25ad50eb92b28b1a9f2a"
        let latitude = 59.933880
        let longitude = 30.337239
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        
        .resume()
    }
}
