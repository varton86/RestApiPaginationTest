//
//  DataViewModel.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 29.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import Foundation

let NUMBER_OF_ROWS_AT_PAGE = 10

protocol DataViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath])
    func onFetchFailed(with reason: String)
}

final class DataViewModel {
    private weak var delegate: DataViewModelDelegate?
    
    private var airports: [Airport] = []
    private var currentPage = 1
    private var total: Int
    private var isFetchInProgress = false
    
    let client = AlarStudiosClient()
    let request: DataRequest
    
    init(request: DataRequest, delegate: DataViewModelDelegate) {
        self.request = request
        self.delegate = delegate
        self.total = NUMBER_OF_ROWS_AT_PAGE
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return airports.count
    }
    
    func airport(at index: Int) -> Airport {
        return airports[index]
    }
    
    func fetchData() {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true
        
        client.fetchData(with: request, page: currentPage) { [unowned self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.total -= NUMBER_OF_ROWS_AT_PAGE
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.airports.append(contentsOf: response.data)
                    self.total += NUMBER_OF_ROWS_AT_PAGE

                    self.isFetchInProgress = false
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.data)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newAirports: [Airport]) -> [IndexPath] {
        let startIndex = airports.count - newAirports.count
        let endIndex = airports.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
