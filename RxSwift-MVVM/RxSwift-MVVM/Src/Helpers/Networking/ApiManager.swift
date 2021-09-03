//
//  ApiManager.swift
//  RxSwift-MVVM
//
//  Created by Suman on 02/09/2021.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

class APIManager{
    
    static let baseUrl = "https://gist.githubusercontent.com/mohammadZ74/"

    typealias parameters = [String:Any]
    
    enum APIResult{
        case success(JSON)
        case failure(RequestError)
    }
    
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError
        case serverUnavailable
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    static func requestData(url: String, method: HTTPMethod, parameters:parameters?,completion: @escaping (APIResult) -> Void){
        
        let header =  ["Content-Type": "application/x-www-form-urlencoded"]
        
        var urlRequest = URLRequest(url: URL(string: baseUrl+url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpMethod = method.rawValue
        
        // setting up the paramerters to be passed
        if let parameters = parameters {
            let parameterData = parameters.reduce("") { (result, param) -> String in
                return result + "&\(param.key)=\(param.value as! String)"
            }.data(using: .utf8)
            urlRequest.httpBody = parameterData

        }
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response , error) in
            
            if let error = error{
                print(error)
                completion(APIResult.failure(.connectionError))
            }else if let data = data, let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
                    print("responseCode : \(responseCode.statusCode)")
                    print("responseJSON : \(responseJson)")
                    switch responseCode.statusCode {
                    case 200:
                    completion(APIResult.success(responseJson))
                    case 400...499:
                    completion(APIResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                    completion(APIResult.failure(.serverError))
                    default:
                        completion(APIResult.failure(.unknownError))
                        break
                    }
                }
                catch let parseJsonError{
                    completion(APIResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJsonError)")
                    
                }
                
            }
            
        }.resume()

    }
}
