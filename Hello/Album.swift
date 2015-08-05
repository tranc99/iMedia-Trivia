//
//  Album.swift
//  Hello
//
//  Created by Ten Mutunhire on 8/4/15.
//  Copyright (c) 2015 Lean Startup Space Launcher. All rights reserved.
//

import Foundation

struct Album {
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    let collectionId: Int
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func albumWithJSON(results: NSArray) -> [Album] {
        var albums = [Album]()
        
        // store the results in our table data array
        if results.count > 0 {
            
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String 
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkURL60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String 
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                if let collectionId = result["collection"] as? Int {
                    var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL, collectionId: collectionId)
                    albums.append(newAlbum)
                }
            }
        }
        return albums
    }
}
