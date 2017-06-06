//
//  ViewController.swift
//  ProductsViewer
//

import UIKit
import CoreData

class ProductsViewController: CoreDataCollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var sortingView: ProductsSortingView?
    
    var viewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeMenu()

        navigationItem.title = viewModel.screenTitle
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UINib(nibName: ProductsListCell.defaultReuseIdentifier, bundle: nil),
                                 forCellWithReuseIdentifier: ProductsListCell.defaultReuseIdentifier)
        
        configureFetchController()
        
        viewModel.startRetrievingData = { [weak self] in
            ActivityView.show()
            self?.configureFetchController()
        }
        
        viewModel.endRetrievingData = { [weak self] success in
            ActivityView.hide()
            self?.configureFetchController()
        }
        
        viewModel.addNetworkreachabilityObservation()
        viewModel.restartDownload()
    }
    
    fileprivate func customizeMenu() {
        sortingView?.translatesAutoresizingMaskIntoConstraints = false
        sortingView?.selectedSorting = viewModel.selectedSorting
        sortingView?.selectedRepresentation = viewModel.selectedRepresentation
        
        sortingView?.sortingButtonPressed = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let alertController = UIAlertController(title: "SORT BY", message: "Please select sorting", preferredStyle: .actionSheet)
            
            for sort in ProductsSorting.allValues {
                if sort != strongSelf.viewModel.selectedSorting {
                    let action = UIAlertAction(title: sort.rawValue, style: .default, handler: { _ in
                        strongSelf.viewModel.selectedSorting = sort
                    })
                    alertController.addAction(action)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(cancel)
            
            strongSelf.present(alertController, animated: true, completion: nil)
        }
        
        sortingView?.representationButtonPressed = { [weak self] format in
            guard let strongSelf = self else {
                return
            }
            strongSelf.viewModel.selectedRepresentation = format
        }
        
        viewModel.selectedSortingChangeCallbak = { [weak self] sorting in
            self?.sortingView?.selectedSorting = sorting
            self?.configureFetchController()
        }
        
        viewModel.representationChangeCallback = { [weak self] in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.contentInset = UIEdgeInsets.zero
        collectionView?.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func configureFetchController() {
        let fetchRequest = Product.fetchRequestFromDefaultContextWithPredicate(predicate: viewModel.predicate(), sortDescriptors: viewModel.sortDescriptors())
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: AppDelegate.shared.managedObjectContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        
        startFetchingData()
    }
    
    private func startFetchingData() {
        fetchLocalData()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let indexPath = sender as? IndexPath,
            let product = fetchResultController?.object(at: indexPath) as? Product,
            let detailsVC = segue.destination as? ProductDetailsViewController {
            detailsVC.viewModel.productId = product.id.intValue
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize(collectionViewSize: collectionView.frame.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 1)
    }

}

extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchResultController?.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsListCell.defaultReuseIdentifier, for: indexPath)
        let product = fetchResultController?.object(at: indexPath)
        if let cell = cell as? ProductsListCell {
            cell.customizeWithProduct(product: product as? Product)
        }
        
        return cell
    }
    
}

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: indexPath)
    }
}
