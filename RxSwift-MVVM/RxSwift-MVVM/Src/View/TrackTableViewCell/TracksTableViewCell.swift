//
//  TracksTableViewCell.swift
//  RxSwift-MVVM
//
//  Created by Suman on 01/09/2021.
//

import Foundation
import UIKit

class TracksTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    
    
    public var cellTrack: Track!{
        didSet{
            self.trackImageView.clipsToBounds = true
            self.trackImageView.layer.cornerRadius = 3
            self.trackImageView.loadImage(fromURL: cellTrack.trackArtWork)
            self.trackTitle.text = cellTrack.name
            self.trackArtist.text = cellTrack.artist
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        trackImageView.image = UIImage()
    }
    
}


