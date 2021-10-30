//
//  BookViewController.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/10/19.
//

import UIKit
import Kingfisher

class BookViewController: UIViewController {
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    var movieData: [BookData] = []
    let randomColor = [
        0x6fc27c, 0xefc8b1, 0x008970, 0xbdfff6, 0xffb8b1, 0xc299d0, 0xfcc729
    ]
    

    var startPage = 1
    
    func fetchData(){
        NaverBookNetworkManger.shared.getBooks(searchString: "dog", startPage: startPage) { statusCode, json in
            for item in json["items"].arrayValue{
                
                let title = item["title"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                let image = item["image"].stringValue
                let link = item["link"].stringValue
                let userRating = item["userRating"].stringValue
                let sub = item["subtitle"].stringValue

                let data = BookData(title: title, imageData: image, linkData: link, userRatingData: userRating, subTitle: sub)
                
                self.movieData.append(data)
            }
            DispatchQueue.main.async {
                self.bookCollectionView.reloadData()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Books"
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        bookCollectionView.prefetchDataSource = self
        
        fetchData()
        
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


extension BookViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if movieData.count - 1 == indexPath.item{
                startPage += 10
                fetchData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("취소\(indexPaths)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else{
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        cell.containerView.backgroundColor = UIColor(rgb: randomColor[indexPath.item % 7])
        
        
        cell.movieTitle.text = movieData[indexPath.item].title
       
        
        let imageUrl = URL(string: movieData[indexPath.item].imageData)
        cell.moviePoster.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "no image"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])

        return cell
        
    }
    
    
    
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
