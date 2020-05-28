//
//  MapClient.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation

class MapClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case webAuth
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .logout:
                return Endpoints.base + "/session"
            case .webAuth:
                return "https://auth.udacity.com/sign-up"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    //MARK: - POST REQUEST
    class func taskForPostRequest<RequestType : Encodable, ResponseType: Decodable>(url : URL, response: ResponseType.Type,  body : RequestType, completion: @escaping(ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                do{
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion : @escaping(Bool, Error?)->Void){
        let udacity = Udacity(username: username, password: password)
        let body = LoginRequest(udacity: udacity)
        
        taskForPostRequest(url: Endpoints.login.url, response: LoginResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                completion(response.account.registered, nil)
            }else{
                completion(false, error)
            }
        }
    }
    
//MARK: - DELETE REQUEST
    class func logout(completion : @escaping () -> Void ){
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
}
