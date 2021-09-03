//
//  TrackModel.swift
//  RxSwift-MVVM
//
//  Created by Suman on 02/09/2021.
//

import Foundation

// MARK: - Track
struct Track: Codable {
    let id, name, trackArtWork, trackAlbum: String
    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case trackArtWork = "track_art_work"
        case trackAlbum = "track_album"
        case artist
    }
}
extension Track {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(Track.self, from: data)
            self = me
        }
        catch {
            print(error)
            return nil
        }
    }
}
