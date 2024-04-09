//
//  AuthManager.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

final class AuthManager{
    
    static let shared = AuthManager()
    private var refreshingToken:Bool = false
    
    
    private init(){}
    
    struct Constants{
        static let ClientId:String = "d47eac45a1d64c93942639510b4c8939"
        static let ClientSecret:String = "71c2af935e5946dca425b3a22ac2bf61"
        static let TokenAPIURL:String = "https://accounts.spotify.com/api/token"
        static let URI:String = "https://www.prestigequill.us"
        static let scope:String = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    public var SignInURL:URL? {
        let base:String = "https://accounts.spotify.com/authorize"
        let url = "\(base)?response_type=code&client_id=\(Constants.ClientId)&scope=\(Constants.scope)&redirect_uri=\(Constants.URI)&show_dialog=TRUE"
        return URL(string: url)
    }
    var signIn:Bool {
        return AccessToken != nil
    }
    
    private var AccessToken:String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var RefreshToken:String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var ExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken:Bool{
        
        guard let expirationDate = ExpirationDate else {
            return false
        }
        
        let current = Date()
        let Fiveminutes:TimeInterval = 300
        
        return current.addingTimeInterval(Fiveminutes) >= expirationDate
        
    }
    
    public func ExchangeCodeForToken(code:String , completion: @escaping((Bool) -> Void)){
        //Get token
        guard let url = URL(string: Constants.TokenAPIURL) else {
            fatalError("the url is not correct")
        }
        
        
        var components = URLComponents()
        components.queryItems = [
          URLQueryItem(name: "grant_type", value: "authorization_code"),
          URLQueryItem(name: "code", value: code),
          URLQueryItem(name: "redirect_uri", value: Constants.URI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let Basic = Constants.ClientId + ":" + Constants.ClientSecret
        let data = Basic.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            print("failure to ger base64")
            completion(false)
            return
        }
        
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data , _ , error ) in
            guard let data = data , error == nil else {
                completion(false)
                fatalError("you got an error here for making request here")
            }
            
            do{
                
                let result = try JSONDecoder().decode(AuthResponse.self , from: data)
                self.CacheToken(result: result)
                completion(true)
            }
            catch (let error){
                print(error.localizedDescription)
                completion(false)
            }
            
        })
        
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func withvalidToken(completion: @escaping (String) -> Void) {
        
        guard !refreshingToken else {
            //append the completion
            self.onRefreshBlocks.append(completion)
            return
        }
        
        
        if shouldRefreshToken {
            RefreshAccessToken(completion:{ [weak self] success in
            if let token = self?.AccessToken , success {
                completion(token)
                }
            })
        }
        else if let token = self.AccessToken{
            completion(token)
        }
    }
    
    
    
    public func RefreshAccessToken(completion:((Bool) -> Void)?){
        
        guard !refreshingToken else {
            return
        }
        
        guard self.shouldRefreshToken else {
            completion?(true)
            return
        }
       
        guard let refeshtoken = self.RefreshToken else {
            return
        }
        
        
        //refresh the token
        guard let url = URL(string: Constants.TokenAPIURL) else {
            fatalError("the url is not correct")
        }
        
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
          URLQueryItem(name: "grant_type", value: "refresh_token"),
          URLQueryItem(name: "refresh_token", value: refeshtoken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let Basic = Constants.ClientId + ":" + Constants.ClientSecret
        let data = Basic.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            print("failure to ger base64")
            completion?(false)
            return
        }
        
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data , _ , error ) in
            
            self.refreshingToken = false
            guard let data = data , error == nil else {
                completion?(false)
                fatalError("you got an error here for making request here")
            }
            
            do{
                
                let result = try JSONDecoder().decode(AuthResponse.self , from: data)
                print("token successfuly refreshed")
                self.onRefreshBlocks.forEach({$0(result.access_token)})
                self.onRefreshBlocks.removeAll()
                self.CacheToken(result: result)
                completion?(true)
            }
            catch (let error){
                print(error.localizedDescription)
                completion?(false)
            }
            
        })
        
        task.resume()
        
    }
    
    private func CacheToken(result:AuthResponse){
        
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
        
    }
    
    public func signOut(completion: (Bool) -> Void) {
        
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        
        completion(true)

    }
}
