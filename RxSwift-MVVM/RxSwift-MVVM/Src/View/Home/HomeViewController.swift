//
//  HomeViewController.swift
//  RxSwift-MVVM
//
//  Created by Suman on 01/09/2021.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var albumsView: UIView!
    @IBOutlet weak var tracksView: UIView!
    
    
    var homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    
    private lazy var albumCollectionViewController: AlbumCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumCollectionViewController") as! AlbumCollectionViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: albumsView)
        
        return viewController
    }()
    
    private lazy var tracksViewController: TracksViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate view controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "TracksViewController") as! TracksViewController
        
        // Add View ontroller as Child view controller
        self.add(asChildViewController: viewController, to: tracksView)
        
        return viewController
    }()
    
    
    // MARK: - View's Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        homeViewModel.requestData()
    }
    
    // MARK: - Bindings
    private func setupBindings(){
        
        //HomeViewController class for observing the viewModel variables and react views from the view model data:

        // ***** binding loading to vc
        
        //In this code, we are binding loading to isAnimating, which means that whenever viewModel changed loading value, the isAnimating value of our view controllers would change as well.
        
        homeViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        
        // ****** Observing errors to show
        //In the below code, whenever an error comes from the ViewModel, we are subscribed to it. You can do whatever you want with the error (I’m showing a pop up).
        
        //****** what is the .observeOn(MainScheduler.instance)? in the below code
        
        //This part of the code is bringing the emitted signals (in our case errors) to the main thread because our ViewModel is sending values from the background thread. So we prevent awkward run time crash because of the background thread. You just bring your signals to the main thread just in one line instead of doing the DispatchQueue.main.async {} way.
        
        homeViewModel
            .error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error{
                
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
        
        
        // ************* binding albums to album container
        //Now let’s do the binding for our UICollectionView and UITableView of albums and tracks. Because our tableView and collectionView properties are in our child ViewControllers. For now, we are just binding array of albums and tracks from ViewModel to tracks and albums properties of childViewControllers and let the child be responsible for showing them
        
        homeViewModel
            .albums
            .observe(on: MainScheduler.instance)
            .bind(to: albumCollectionViewController.albums)
            .disposed(by: disposeBag)
        
        // ************* binding tracks to track container
        
        homeViewModel
            .tracks
            .observe(on: MainScheduler.instance)
            .bind(to: tracksViewController.tracks)
            .disposed(by: disposeBag)


    }

}

