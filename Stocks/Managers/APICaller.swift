//
//  APICaller.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "c8gfrriad3ic9igd8dgg"
        static let sandboxApiKey = "sandbox_c8gfrriad3ic9igd8dh0"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 60 * 60 * 24
    }
    
    private init() {}
    
    // MARK: -  Public
    
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        request(url: url(for: .search, queryParams: ["q": safeQuery]), expecting: SearchResponse.self, completion: completion)
    }
    
    public func news(for type: NewsViewController.`Type`, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            let url = url(
                for: .topStories,
                queryParams: [
                    "category": "general"
                ]
            )
            request(url: url, expecting: [NewsStory].self, completion: completion)
            
        case .company(let symbol):
            let today = Date()
            let oneWeekBack = today.addingTimeInterval(-(Constants.day * 7))
            let url = url(
                for: .companyNews,
                queryParams: [
                    "symbol": symbol,
                    "from": DateFormatter.newsDateFormatter.string(from: oneWeekBack),
                    "to": DateFormatter.newsDateFormatter.string(from: today)
                ]
            )
            request(url: url, expecting: [NewsStory].self, completion: completion)
        }

    }
    
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date()
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        let url = url(
            for: .marketData,
            queryParams: [
                "symbol": symbol,
                "resolution": "1",
                "from": "\(Int(prior.timeIntervalSince1970))",
                "to": "\(Int(today.timeIntervalSince1970))"
            ]
        )
        
        request(url: url, expecting: MarketDataResponse.self, completion: completion)
    }
    
    
    public func financialMetrics(
        for symbol: String,
        completion: @escaping (Result<FinancialMetricsResponse, Error>) ->  Void
    ) {
        
        request(
            url: url(
                for: .financials,
                queryParams: ["symbol": symbol, "metric": "all"]
            ),
            expecting: FinancialMetricsResponse.self,
            completion: completion
        )
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        //add any params
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        //add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        //convert queryItems to suffix string
        
        let queryString = queryItems.map {"\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
        
        urlString += "?" + queryString
        
        return URL(string: urlString)
    }
    
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}