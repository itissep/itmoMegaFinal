//
//  NewsService.swift
//  itmoNewsApp
//
//  Created by Уля on 21.03.2025.
//

import Foundation

struct NewsService {
    enum NewsServiceError: LocalizedError {
        case decodingProblem
        case urlTaskProblem
        
        var errorDescription: String? {
            switch self {
            case .decodingProblem:
                "There is a decoding problem! Reload page."
            case .urlTaskProblem:
                "There is a networking problem! Reload page."
            }
        }
        
    }
    
    func fetchData(_ completion: @escaping ([NewsArticle], Error?) -> Void) {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(Env.apiKey)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion([], NewsServiceError.urlTaskProblem)
            } else if let data {
                do {
                    let decodedData = try JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(decodedData.articles, nil)
                } catch {
                    completion([], NewsServiceError.decodingProblem)
                }
            }
        }.resume()
    }
    
    func search(_ searchKey: String) {
        
    }
}

struct NewsResponse: Codable {
    let articles: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    
    
//    "title": "Live updates: London’s Heathrow Airport closes after substation fire, upending global travel - The Washington Post",
//    "description": "One of the world’s busiest airports will be shut down all day Friday due to a fire at a substation that supplies it with power.",
//    "url": "https://www.washingtonpost.com/world/2025/03/21/london-heathrow-airport-closed-fire-power-outage/",
//    "urlToImage": "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/HYB567K5S6Z5B3STSTHNKNXQMQ_size-normalized.jpg&w=1440",
    
}
