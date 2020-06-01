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
        static var userId = ""
        static var firstName = ""
        static var lastName = ""
    }
    
    enum optionalParameter{
        case limit(by: String)
        case skip(limit: String, skip: String)
        case order(limit: String)
        case uniqueKey(id: String)
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case webAuth
        case studentLocations(by: optionalParameter)
        case userInfo(String)
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .logout:
                return Endpoints.base + "/session"
            case .webAuth:
                return "https://auth.udacity.com/sign-up"
            case let .studentLocations(by):
                switch by {
                case let .limit(number):
                    return Endpoints.base + "/StudentLocation" + "?limit=\(number)"
                case let .skip(limit, skip):
                    return Endpoints.base + "/StudentLocation" + "?limit=\(limit)&skip=\(skip)"
                case let .order(limit):
                    return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(limit)"
                case let .uniqueKey(id):
                    return Endpoints.base + "/StudentLocation" + "?uniqueKey=\(id)"
                }
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case let .userInfo(userId):
                return Endpoints.base + "/users/\(userId)"
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
        
        let errorClient = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Invalid username or password"]) as Error
        
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
                        completion(nil, errorClient)
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
                Auth.userId = response.account.key
                completion(response.account.registered, nil)
            }else{
                completion(false, error)
            }
        }
    }
    
//MARK: - GET REQUEST
    class func taskForGetRequest<ResponseType : Decodable>(url : URL, responseType: ResponseType.Type, completion : @escaping(ResponseType?, Error?)->Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func getStudentLocation(completion : @escaping([StudentInfo], Error?)->Void){
        
        taskForGetRequest(url: Endpoints.studentLocations(by: .order(limit: "100")).url, responseType: StudentLocationResponse.self) { (response, error) in
            if let response = response {
                StudentModel.loccation = response.results
                completion(response.results, nil)
            }else{
                completion([], error)
            }
        }
    }
    

    class func getPublicUser(completion : @escaping(Bool,Error?)->Void){
        taskForGetRequest(url: Endpoints.userInfo(Auth.userId).url, responseType: PublicUserResponse.self) { (response, error) in
            if let response = response{
                Auth.firstName = response.user.firstName
                Auth.lastName = response.user.lastName
                completion(true, nil)
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
