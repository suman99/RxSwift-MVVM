//
//  TracksViewController.swift
//  RxSwift-MVVM
//
//  Created by Suman on 01/09/2021.
//

import UIKit
import RxSwift

class TracksViewController: UIViewController {

    @IBOutlet weak var tracksTableView: UITableView!
    
    let tracks = PublishSubject<[Track]>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering the cells of nib file
        tracksTableView.register(UINib(nibName: "TracksTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TracksTableViewCell.self))
        
        //Now in viewDidLoad method of TracksViewController, we should bind tracks to tracksTableView, which can be done in 2 lines. Thanks to RxCocoa!

        //we just need to pass the model (binding model to UITableView) and give it a cellType. In the closure, RxCocoa will give you cell, model and the row corresponding to your model array, so that you could feed the cell with the corresponding model. In our cell, whenever the model gets set with didSet, the cell is going to set the properties with the model.

        tracks.bind(to: tracksTableView.rx.items(cellIdentifier: "TracksTableViewCell", cellType: TracksTableViewCell.self)){ (row, track, cell) in
            cell.cellTrack = track
        }.disposed(by: disposeBag)
        
        //set tableView and collectionView by giving some animations:
        tracksTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell, indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        cell.alpha = 1
                        cell.layer.transform = CATransform3DIdentity
                    }, completion: nil)
            })).disposed(by: disposeBag)
    }

}
