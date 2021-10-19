//
//  BookViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/19.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    var data : [TvShow]?
    let randomColor = [UIColor.brown, .cyan, .blue, .magenta, .orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        
        
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        layout.itemSize = CGSize(width: (bookCollectionView.bounds.width / 2) - 15, height: bookCollectionView.bounds.height / 4)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        bookCollectionView.collectionViewLayout = layout

    }
}

extension BookViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell, let info = data?[indexPath.item] else{
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.backgroundColor = randomColor.randomElement()
        
        cell.movieTitle.text = info.title
        cell.moviePoster.contentMode = .scaleAspectFit
        cell.moviePoster.image = UIImage(named: "\(info.title)") ?? UIImage()
        
        return cell
        
    }
    
    
    
}
