//
//  MovieDetailsController.swift
//  HotelMovieApp
//
//  Created by Andrew Demenagas on 9/5/20.
//  Copyright © 2020 Andrew Demenagas. All rights reserved.
//

import UIKit

class MovieDetailsController: UICollectionViewController {
    
    fileprivate let posterHeaderId = "posterHeaderId"
    fileprivate let infoCellId = "infocellid"
    fileprivate let castSectionCellid = "castSectionCellid"
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(DetailsPosterHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: posterHeaderId)
        collectionView.register(DetailsInfoCell.self, forCellWithReuseIdentifier: infoCellId)
        collectionView.register(MovieDetailsCastSectionCell.self, forCellWithReuseIdentifier: castSectionCellid)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: posterHeaderId, for: indexPath) as! DetailsPosterHeader
        header.delegate = self
        header.posterPath = movie?.poster_path
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellId, for: indexPath) as! DetailsInfoCell
            infoCell.movie = movie
            infoCell.trailersDelegate = self
            return infoCell
        }
        
        let castSectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: castSectionCellid, for: indexPath) as! MovieDetailsCastSectionCell
        castSectionCell.movie = movie
        return castSectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return .init(top: 10, left: 0, bottom: 0, right: 0)
        }
        return .zero
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}


// MARK: DelegateFlowLayout
extension MovieDetailsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let height = getInfoCellHeight()
            return .init(width: view.frame.width, height: height)
        }
        
        return .init(width: view.frame.width, height: 200)
    }
    
    fileprivate func getInfoCellHeight() -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        let dummyCell = DetailsInfoCell(frame: frame)
        dummyCell.movie = movie
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        return estimatedSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .init(width: view.frame.width, height: view.frame.width * 1.5)
        }
        return .zero
    }
    
}

// MARK: Custom Delegation
extension MovieDetailsController: DetailsHeaderDelegate, TrailersDelegate {
    func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapShowTrailers() {
        let trailersController = MovieTrailersController()
        trailersController.movie = movie
        present(UINavigationController(rootViewController: trailersController), animated: true)
    }
}
