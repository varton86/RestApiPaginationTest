//
//  ListViewController.swift
//  TestTaskAlarStudios
//
//  Created by Oleg Soloviev on 28.01.2019.
//  Copyright © 2019 varton. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, AlertDisplayer {
    private enum CellIdentifiers {
        static let list = "List"
    }
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var code: String!
    
    private var viewModel: DataViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List of Airports"
        indicatorView.startAnimating()
        
        let request = DataRequest.with(code)
        viewModel = DataViewModel(request: request, delegate: self)
        
        viewModel.fetchData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                detailViewController.airport = viewModel.airport(at: indexPath.row)
            }
        }
    }
    
    deinit {
        print("*** Deinit List ...")
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! DataTableViewCell
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.airport(at: indexPath.row))
        }
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            performSegue(withIdentifier: "ShowDetail", sender: tableView.cellForRow(at: indexPath))
        }
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchData()
        }
    }
}

extension ListViewController: DataViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]) {
        if tableView.isHidden {
            tableView.reloadData()
            tableView.isHidden = false
            indicatorView.stopAnimating()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        performBatchUpdatesTable() { [unowned self] in
            self.tableView.reloadRows(at: indexPathsToReload, with: .none)
        }
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
        tableView.deleteRows(at: (viewModel.currentCount..<(viewModel.currentCount + NUMBER_OF_ROWS_AT_PAGE)).map { IndexPath(row: $0, section: 0) }, with: .none)
    }
}

private extension ListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }

    func performBatchUpdatesTable(_ completion: @escaping () -> Void) {
        tableView.beginUpdates()
        tableView.insertRows(at: (viewModel.currentCount..<viewModel.totalCount).map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.endUpdates()
        completion()
    }
    
}
