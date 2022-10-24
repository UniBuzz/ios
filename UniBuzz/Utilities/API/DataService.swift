//
//  DataService.swift
//  UniBuzz
//
//  Created by Muhammad Farhan Almasyhur on 03/10/22.
//

import Foundation
import Firebase


class DataService {
    
    public static var shared = DataService()
    
    func getUniversityImage(imageLink: String, completion: @escaping (Result<Data,Error>) -> Void){
        let url = URL(string: imageLink)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
        
    }
    
    
}
