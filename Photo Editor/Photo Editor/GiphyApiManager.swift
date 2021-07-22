//
//  GiphyGifsApi.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 23/07/2020.
//

import Foundation

struct Pagination: Decodable, Hashable {
    let offset: Int
}

struct GiphyObject: Decodable, Hashable {
    let url: String?
    let height: String?
    let width: String?
}

struct GiphySizes: Decodable, Hashable {
    let downsized: GiphyObject?
    let preview_gif: GiphyObject?
}

struct GiphyImages: Decodable, Hashable {
    let images: GiphySizes
}

struct GiphyResponse: Decodable {
    let data: [GiphyImages]
    let pagination: Pagination?
}

enum GiphyType: String {
    case gifs = "gifs"
    case stickers = "stickers"
    
    func toSring() -> String {
        return self.rawValue
    }
}

enum ApiType: String {
    case trending = "trending"
    case search = "search"
    
    func toSring() -> String {
        return self.rawValue
    }
}

class GiphyApiManager {
    let offsetDefault = 25
    private var giphyType: GiphyType = GiphyType.gifs
    private var apiType: ApiType = ApiType.trending
    private var page: Int = 0
    private var searchTask: DispatchWorkItem?
    private var offset = 0
    private var searchPhrase = ""
    var giphyApiManagerDelegate: GiphyApiManagerDelegate!
    
    init (apiType: GiphyType) {
        giphyType = apiType
    }
    
    private func search(search: String) {
        apiType = ApiType.search
        
        if let apiUrl = buildApiUrl(search: search) {
            let task = URLSession.shared.dataTask(with: apiUrl) {(data, response, error) in
                guard let data = data else { return }
                
                let decodedData = self.decodeData(data: data)
                self.giphyApiManagerDelegate.onLoadData(data: decodedData, type: self.giphyType)
            }
            
            task.resume()
        }
    }
    
    private func decodeData(data: Data) -> [GiphySizes] {
        let gifs: GiphyResponse = try! JSONDecoder().decode(GiphyResponse.self, from: data)
        
        var giphyGifs: [GiphySizes] = []
        
        for image in gifs.data {
            if image.images.downsized != nil && image.images.downsized?.url != nil && image.images.downsized?.width != nil && image.images.downsized?.height != nil
                && image.images.preview_gif != nil && image.images.preview_gif?.url != nil && image.images.preview_gif?.width != nil && image.images.preview_gif?.height != nil {
                giphyGifs.append(image.images)
            }
        }
        
        return giphyGifs
    }
    
    private func buildApiUrl(search: String? = nil, offset: Int = 0) -> URL? {
        if (search == nil || search!.isEmpty) {
            apiType = ApiType.trending
        }
        
        var url = "https://api.giphy.com/v1/\(giphyType.toSring())/\(apiType.toSring())?api_key=K60P8olEveFJVYWFp87IlgqT4CmXcMUe&rating=pg"
        
        if let query = search {
            url = url + "&q=" + query
        }
        
        if offset > 0 {
            url = url + "&offset=\(offset)"
        }
        
        return URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    }
    
    func getSearchPhrase() -> String {
        return searchPhrase;
    }
    
    func fetchTrendingPage() {
        searchPhrase = ""
        apiType = ApiType.trending
        
        if let apiUrl = buildApiUrl() {
            let task = URLSession.shared.dataTask(with:apiUrl) {(data, response, error) in
                guard let data = data else { return }
                
                let decodedData = self.decodeData(data: data)
                self.giphyApiManagerDelegate.onLoadData(data: decodedData, type: self.giphyType)
            }
            
            task.resume()
        }
    }
    
    func searchGif(phrase: String) {
        searchPhrase = phrase
        offset = 0
        searchTask?.cancel()
        
        searchTask = DispatchWorkItem { [weak self] in
            self?.search(search: phrase)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: searchTask!)
    }
    
    func loadMore() {
        offset += offsetDefault
        
        if let apiUrl = buildApiUrl(search: searchPhrase, offset: offset) {
            let task = URLSession.shared.dataTask(with:apiUrl) {(data, response, error) in
                guard let data = data else { return }
                
                let decodedData = self.decodeData(data: data)
                self.giphyApiManagerDelegate.onLoadMoreData(data: decodedData, type: self.giphyType)
            }
            
            task.resume()
        }
    }
}
