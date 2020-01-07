//
//  ViewController+Extension.swift
//  CurrencyExchanger
//
//  Created by Neil Francis Hipona on 1/7/20.
//  Copyright © 2020 Neil Francis Hipona. All rights reserved.
//

import Foundation
import Alamofire

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func loadCurrency() {
        
        Alamofire.request("https://api.exchangeratesapi.io/latest").responseJSON(completionHandler: { (data) in
          
            if data.result.isSuccess {
                if let obj = data.result.value as? [String: AnyObject] {
                    if let b = obj["base"] as? String {
                        self.base = b
                    }
                    
                    if let r = obj["rates"] as? [String: NSNumber] {
                        self.rates = r
        
                        self.currencies = [[self.base: 1000]] // reset rate
                        
                        for (key, value) in r {
                            self.currencies.append([key: value.floatValue])
                        }
                    }
                }
            }
            
            self.collectionView.reloadData()
        })
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCVCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let currency = currencies[indexPath.item]
        
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 22)
        let attrib : [NSAttributedString.Key : Any] = [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 17)]
        let currencyLbl = "\(currency.values.first!) \(currency.keys.first!)"
        let boundingRect = currencyLbl.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrib, context: nil)
        let maxWidth = boundingRect.size.width + 20
        
        return CGSize(width: maxWidth, height: 30)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
        let currency = currencies[indexPath.item]
        
        let c = cell as! CurrencyCVCell
        c.balanceLbl.text = "\(currency.values.first!) \(currency.keys.first!)"
    }
    
    
}