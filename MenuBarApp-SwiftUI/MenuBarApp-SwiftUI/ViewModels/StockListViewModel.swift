//
//  StockListViewModel.swift
//  MenuBarApp-SwiftUI
//
//  Created by paige shin on 2023/02/26.
//

import Foundation

@MainActor
class StockListViewModel: ObservableObject {
    
    @Published var stocks: [StockViewModel] = []
    
    func populateStocks() async {
        do {
            let stocks = try await Webservice().getStocks(url: Constants.Urls.latestStocks!)
            self.stocks = stocks.map(StockViewModel.init)
        } catch {
            print(error)
        }
    }
    
}

struct StockViewModel {
    
    private var stock: Stock
    
    init(stock: Stock) {
        self.stock = stock
    }
    
    var symbol: String {
        self.stock.symbol
    }
    
    var price: Double {
        self.stock.price
    }
    
    var description: String {
        self.stock.description
    }
    
}
