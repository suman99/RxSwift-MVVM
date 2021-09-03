//
//  AlbumCollectionViewController.swift
//  RxSwift-MVVM
//
//  Created by Suman on 01/09/2021.
//

import Foundation
import UIKit
import RxSwift

class AlbumCollectionViewController: UIViewController {

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    public var albums = PublishSubject<[Album]>()

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registering the cells of nib file
        albumCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))

        albums.bind(to: albumCollectionView.rx.items(cellIdentifier: "AlbumsCollectionViewCell", cellType: AlbumsCollectionViewCell.self)) {  (row,album,cell) in
            cell.album = album
            cell.withBackView = true
            }.disposed(by: disposeBag)
        
        albumCollectionView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -250, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
        
        
    }

}

