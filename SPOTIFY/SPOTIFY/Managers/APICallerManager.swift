//
//  APICallerManager.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//


import Foundation
import OSLog


final class APICaller{
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPmethod:String
    {
     case GET
     case POST
     case PUT
     case DELETE
        
    }
    
    enum APIerror:Error{
        case FailedToGetData
    }
    
    static let share = APICaller()
    
    private init() {}
    
    
    // -MARK: -Category
    
    public func getCategories(completion: @escaping (Result<[Category],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"), Method: .GET, completion: {
            request in
            let task = URLSession.shared.dataTask(with: request, completionHandler: { 
                (data,_,error) in
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                }
                
                catch (let error){
                    print("you have error here")
                    print(error.localizedDescription)
                }
                
            })
            task.resume()
        })
    }
    
    public func getCategoriesPlaylist(category:Category,completion: @escaping (Result<[playlist],Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"), Method: .GET, completion: {
            request in
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                (data,_,error) in
                guard let data = data , error == nil else {
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    completion(.success(result.playlists.items))
                }
                
                catch (let error){
                    print("you have an error here")
                    print(error.localizedDescription)
                }
                
            })
            task.resume()
        })
    }
    
    
    // -MARK: -LibraryViewControllerApicaller
    public func getCurrentUserPlaylists(completion: @escaping(Result<[playlist] , APIerror>) -> Void){
        
     
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"), Method: .GET, completion: {
            request in

            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data , error == nil else {
                    
                    completion(.failure(.FailedToGetData))
                    fatalError("Unabel to fetch data from this url")
                    
                }
                do{
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
        
                    print(result.items)
                    completion(.success(result.items))
                }
                catch{
                    completion(.failure(.FailedToGetData))
                    print(error.localizedDescription)
                }
            }
            task.resume()
        })
        
    }
    
    public func createPlaylists(with name:String , completion: @escaping (Bool) -> Void){
        
        GetCurrentuserProfiel { [weak self] result in
            switch result{
                
            case .success(let profile):
                print("start creating playlist")
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                
                self?.createRequest(with: URL(string:urlString), Method: .POST) { baserequest in
                    var request = baserequest
                    let json = [
                        "name":name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                        
                        guard let data  = data , error == nil else {
                            completion(false)
                            print("error")
                            return
                        }
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any] ,response["id"] as? String != nil {
                                completion(true)
                            }
                            else{
                                print("failed to get id")
                                completion(false)
                            }
                        }
                        
                        catch (_){
                            completion(false)
                            print("you got an error here")
                        }
                        
                    }
                    task.resume()
                    
                }
                
            case .failure(let error):
                print("unable to render profile")
            }
        }
        
    }
    // - MARK: ADD TRACK TO PLAYLIST
    public func addTrackToPlaylist(track: AudioTrack,Playlist:playlist , completion: @escaping (Bool) -> Void)
    {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(Playlist.id)/tracks"), Method: .POST) { baserequest in
            var request = baserequest
            let json = [
                "uris":["spotify:track:\(track.id)"]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(false)
                    print("you got error here")
                    return
                }
                
                do{
                    let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                    if let response = result as? [String:Any] , response["snapshot_id"] as? String != nil {
                        completion(true)
                        print("your operation was successful")
                    }
                    
                }
                
                catch{
                    print("milad you have error here")
                    completion(false)
                }
            }
            task.resume()
        }
        
    }
    
    // - MARK: GET CURRENT USER ALBUM
    public func getCurrentUserAlbum(completion: @escaping (Result<[Album] , Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums/"), Method: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    print("error at get current user album")
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
                    print(result)
                    completion(.success(result.items.compactMap({$0.album})))
                }
                
                catch{
                    print("error at get current user album")
                    completion(.failure(APIerror.FailedToGetData))
                }
            }
            task.resume()
        }
    }
    // - MARK: SaveAlbum
    public func SaveAlbum(Album:Album , completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "me/albums?ids=\(Album.id)"), Method: .PUT) { baserequest in
            var request = baserequest
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode , error == nil else {
                    print("you got error milad here")
                    completion(false)
                    return
                }
                print("I am working")
                print(code)
                completion(code == 200)
            }
        }
    }
    
    // - MARK: REMOVE TRACK FROM PLAYLIST
    public func removeTrackFromPlaylist(track: AudioTrack,Playlist:playlist , completion: @escaping (Bool) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(Playlist.id)/tracks"), Method: .DELETE) { baserequest in
            var request = baserequest
            let json = [
                "tracks":[
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                   
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data , error == nil else {
                    completion(false)
                    print("you got error here")
                    return
                }
                
                do{
                    let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed)
                    if let response = result as? [String:Any] , response["snapshot_id"] as? String != nil {
                        completion(true)
                        print("your operation was successful")
                    }
                    
                }
                
                catch{
                    print("milad you have error here")
                    completion(false)
                }
            }
            task.resume()
        }
        
        
    }
    
    // -MARK: -PRIVATE
    
    
    // - MARK: GETALBUM DETAIL
    public func getAlbumDetail(for Album:Album , completion: @escaping (Result<AlbumDetailResponse, Error>) -> Void) {
        createRequest(
                      with: URL(string: Constants.baseAPIURL + "/albums/" + Album.id),
                      Method: .GET,
                      completion: { request in
                          
                          let task = URLSession.shared.dataTask(with: request, completionHandler: {data , _ , error in
                              guard let data = data , error == nil else {
                                  completion(.failure(APIerror.FailedToGetData))
                                  fatalError("Unabel to get data in APICaller Manager for getAlbumDetail")
                              }
                              do{
                                  let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                                  completion(.success(result))
                              }
                              
                              catch let error{
                            
                                  completion(.failure(error))
                                 
                              }
                              
                              
                          })
                          
                          task.resume()
                          
                      })
        
    }
    
    // - MARK: GETPlaylist DETAIL
    
    public func getPlaylistDetail(for Playlist:playlist, completion: @escaping (Result<PlaylistDetailResponse, Error>) -> Void) {
        createRequest(
                      with: URL(string: Constants.baseAPIURL + "/playlists/" + Playlist.id),
                      Method: .GET,
                      completion: { request in
                          
                          let task = URLSession.shared.dataTask(with: request, completionHandler: {data , _ , error in
                              guard let data = data , error == nil else {
                                  completion(.failure(APIerror.FailedToGetData))
                                  fatalError("Unabel to get data in APICaller Manager for getAlbumDetail")
                              }
                              do{
                                  let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                                  completion(.success(result))
                              }
                              
                              catch let error{
                    
                                  completion(.failure(error))
                              }
                              
                              
                          })
                          
                          task.resume()
                          
                      })
        
    }
    
    
    public func GetCurrentuserProfiel(completion: @escaping (Result<UserProfile,Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me") , Method: .GET, completion: {
            urlrequest in
            let task = URLSession.shared.dataTask(with: urlrequest, completionHandler: {data , _ , error in
            
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    fatalError("you GetCurrnetUserProfile Error")
                }
                
                do{
                    //let result = try JSONSerialization.jsonObject(with: data , options: .allowFragments)
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    print(result)
                }
                
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            })
            
            task.resume()
        })
    }
    
    
    
    public func getRecommendations(genres: Set<String> ,completion:@escaping(Result<RecommendationsResponse , Error>) -> Void) {
        
        let seeds = genres.joined(separator: ",")
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"), Method: .GET, completion:  { request in
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data , _ , error) in
                
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                
                catch{
                    completion(.failure(error))
                }
            })
            task.resume()
            
        })
    }
    
    

    public func getRecommendedGenre(completion: @escaping((Result<RecommendedGenresResponse , Error>) -> Void)) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), Method: .GET, completion:  { request in
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data , _ , error) in
                
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)

                    completion(.success(result))
                }
                
                catch{
                    completion(.failure(error))
                }
            })
            task.resume()
            
        })
        
    }
    
    // -MARK: -Search
    
    public func search(with query:String , completion: @escaping(Result<[SearchResult] , Error>)-> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), Method: .GET, completion:  { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, Response, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults:[SearchResult] = []
                    
                    searchResults.append(contentsOf:result.tracks.items.compactMap({.track(model: $0)}))
                    searchResults.append(contentsOf:result.albums.items.compactMap({.album(model: $0)}))
                    searchResults.append(contentsOf:result.artists.items.compactMap({.artist(model: $0)}))
                    searchResults.append(contentsOf:result.playlists.items.compactMap({.playlist(model: $0)}))
                    completion(.success(searchResults))
                }
                
                catch let error {
                    completion(.failure(error))
                }
            }
            
            task.resume()
            
        })
    }
    
    
    
    public func getFeaturedFlaylists(completion: @escaping((Result<FeaturedPlaylistResponse , Error>) -> Void)) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), Method: .GET, completion:  { request in
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data , _ , error) in
                
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                }
                
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            })
            task.resume()
            
        })
        
    }
    
    
    public func GetNewRelease(completion: @escaping(Result<NewRelease, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), Method: .GET, completion: { request in
               
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data , _ ,error )in
                
                guard let data = data , error == nil else {
                    completion(.failure(APIerror.FailedToGetData))
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(NewRelease.self, from: data)
                    completion(.success(result))
                }
                
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            })
            
            task.resume()
            
        })
    }
    

    private func createRequest(
        
        with url: URL? ,
        Method:HTTPmethod ,
        completion: @escaping ((URLRequest) -> Void)) {
            
        AuthManager.shared.withvalidToken(completion: { token in
            
            guard let url = url else {
                fatalError("ther is no such url")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = Method.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 30
            
            completion(request)
        })
       }
    
    
}
