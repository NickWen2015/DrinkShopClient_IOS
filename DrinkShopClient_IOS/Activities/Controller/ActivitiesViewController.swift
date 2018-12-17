//
//  ViewController.swift
//  DrinkShopClient_IOS
//
//  Created by Nick Wen on 2018/10/7.
//  Copyright © 2018 Nick Wen. All rights reserved.
//  drinkshop ios消費者端

import UIKit
import QuartzCore



class ActivitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
    
    var newsArray = [NewsItem]()
    var newsIdArray = [Int]()
    var imageArray = [Data]()
    var imageIndex = 0
    var time: Timer!
    
    let PHOTO_URL = Common.SERVER_URL + "NewsServlet"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityCollectionView.delegate = self
        activityCollectionView.dataSource = self
        
       
        
        //取得每張圖片的id
        Communicator.shared.retriveIds { (result, error) in
            
            if let error = error {
                print(" Load Data Error: \(error)")
                return
            }
            guard let result = result else {
                print (" result is nil")
                return
            }
            print("Load Data OK.")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print(" Fail to generate jsonData.")
                return
            }
            
            //解碼
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([NewsItem].self, from: jsonData) else {
                print(" Fail to decode jsonData.")
                return
            }
            
            self.newsIdArray = []
            for newsItem in resultObject {
                guard let newsId = newsItem.id else {
                    continue
                }
                self.newsIdArray.append(newsId)

            }
            self.newsIdArray.append(self.newsIdArray[0])
            
            DispatchQueue.main.async {
                
                self.activityCollectionView.reloadData()
                //每隔3秒轉換圖片
                self.time = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeBanner), userInfo: nil, repeats: true)
            }
         
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if time != nil {
            time?.invalidate()
        }
    }
    
   
    @IBAction func unwindToActivities(_ unwindSegue: UIStoryboardSegue) { }
    
    
    //轉動CollectionView
    @objc func changeBanner() {
        var indexPath: IndexPath
        imageIndex += 1
        if imageIndex < newsIdArray.count {
            indexPath = IndexPath (item: imageIndex, section: 0)
            activityCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            imageIndex = 0
            indexPath = IndexPath(item: imageIndex, section: 0)
            activityCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            changeBanner()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //設定總數
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newsIdArray.count
    }
    
    var imageDic = [Int: UIImage]()
    
    //設定Cell的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ActivitiesCollectionViewCell
        
        let id = self.newsIdArray[indexPath.row]
     
        
        
        if let image = imageDic[id] {
            cell.activityImageView.image = image
        } else {
            cell.activityImageView.image = nil
            
            Communicator.shared.getPhotoById(photoURL: self.PHOTO_URL, id: id) { (result, error) in
                guard let data = result else {
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageDic[id] = image
                        cell.activityImageView.image = image
                        
                    }
                }
            }
        }
        return cell
    }
    
    //設定cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    //設定每個section上下的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //設定每個Item間的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
