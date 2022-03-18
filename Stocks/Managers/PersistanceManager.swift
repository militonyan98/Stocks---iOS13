//
//  PersistanceManager.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import Foundation

/// Object to manage saved caches
final class PersistanceManager {
    /// Singleton
    static let shared = PersistanceManager()
    
    /// Reference to user defaults
    private let userDefaults: UserDefaults = .standard
    
    /// Constants
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    /// Private constructor
    private init() {}
    
    
    // MARK: - Public
    
    /// Gets user watchlist
    public var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    
    /// Checks if watchlist contains item
    /// - Parameter symbol: Symbol to check
    /// - Returns: Boolean
    public func watchlistContains(symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    
    /// Adds a symbol to watchlist
    /// - Parameters:
    ///   - symbol: Symbol to add
    ///   - companyName: Company name for symbol being added
    public func addToWatchlist(symbol: String, companyName: String) {
        var current = watchlist
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchListKey)
        userDefaults.set(companyName, forKey:  symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
    }
    
    
    /// Removes item from watchlist
    /// - Parameter symbol: Symbol to remove
    public func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        userDefaults.set(nil, forKey: symbol)
        
        for item in watchlist where item != symbol {
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchListKey)
    }
    
    
    // MARK: - Private
    
    /// Check if user has been onboarded
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: Constants.onboardedKey)
    }
    
    /// Sets up default watchlist items
    private func setUpDefaults() {
        let map: [String: String] = [
            "AAPL": "Apple Inc.",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc.",
            "GOOG": "Alphabet",
            "AMZN": "Amazon.com, Inc.",
            "WORK": "Slack Technologies",
            "FB": "Facebook Inc.",
            "NVDA": "Nvidia Inc.",
            "NKE": "Nike",
            "PINS": "Pinterest Inc."
        ]
        
        let symbols = map.keys.map{$0}
        userDefaults.set(symbols, forKey: Constants.watchListKey)
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}
