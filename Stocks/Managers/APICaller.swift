//
//  APICaller.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import Foundation

/// Object to manage api calls
final class APICaller {
    /// Singleton
    public static let shared = APICaller()
    
    /// Constants
    private struct Constants {
        static let apiKey = "c8gfrriad3ic9igd8dgg"
        static let sandboxApiKey = "sandbox_c8gfrriad3ic9igd8dh0"
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 60 * 60 * 24
    }
    
    /// Private constructor
    private init() {}
    
    // MARK: -  Public
    
    /// Search for a company
    /// - Parameters:
    ///   - query: Query string (symbol or name)
    ///   - completion: Result callback
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }
        request(
            url: url(
                for: .search,
                queryParams: ["q": safeQuery]
            ),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    /// Gets news for type
    /// - Parameters:
    ///   - type: Company or top stories
    ///   - completion: Result callback
    public func news(for type: NewsViewController.`Type`, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            let url = url(
                for: .topStories,
                queryParams: [
                    "category": "general"
                ]
            )
            
            request(
                url: url,
                expecting: [NewsStory].self,
                completion: completion
            )
            
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
    
    /// Gets market data
    /// - Parameters:
    ///   - symbol: Given symbol
    ///   - numberOfDays: Number of days back from today
    ///   - completion: Result callback
    public func marketData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        
        request(
            url: url(
                for: .marketData,
                queryParams: [
                    "symbol": symbol,
                    "resolution": "1",
                    "from": "\(Int(prior.timeIntervalSince1970))",
                    "to": "\(Int(today.timeIntervalSince1970))"
                ]
            ),
            expecting: MarketDataResponse.self,
            completion: completion
        )
    }
    
    
    /// Gets financial metrics
    /// - Parameters:
    ///   - symbol: Symbol of company
    ///   - completion: Result callback
    public func financialMetrics(for symbol: String, completion: @escaping (Result<FinancialMetricsResponse, Error>) ->  Void) {
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
    
    /// API endpoints
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    /// API errors
    private enum APIError: Error {
        case noDataReturned
        case invalidURL
    }
    
    /// Tries to create url for endpoint
    /// - Parameters:
    ///   - endpoint: Endpoint to create for
    ///   - queryParams: Additional query arguments
    /// - Returns: Optional URL
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        // Add any params
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        // Convert queryItems to suffix string
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        urlString += "?" + queryString
        
        return URL(string: urlString)
    }
    
    
    /// Performs api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
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
