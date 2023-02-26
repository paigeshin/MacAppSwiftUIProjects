//
//  ContentView.swift
//  MenuBarApp-SwiftUI
//
//  Created by paige shin on 2023/02/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = StockListViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stocks")
                .padding()
            
            List(vm.stocks, id: \.symbol) { stock in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(stock.symbol)
                            .fontWeight(.semibold)
                        Text(stock.description)
                            .opacity(0.4)
                        Divider()
                    }
                    Spacer()
                    Text(stock.price.formatAsCurrency())
                }
            }
            .task {
                await vm.populateStocks()
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "N/A"
    }
    
}
