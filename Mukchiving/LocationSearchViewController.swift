//
//  LocationSearchViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/31.
//

import UIKit

class LocationSearchViewController: UIViewController {

    var placeInfo: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlString = "https://dapi.kakao.com/v2/local/search/keyword.json"
        var components = URLComponents(string: urlString)
        var query = URLQueryItem(name: "query", value: "카카오프렌즈")
        components?.queryItems = [query]
        
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.setValue("KakaoAK cbe41a5fea73d427b29126d974d48d19", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            print("완료")
            if let response = response {
                print("\(response)")
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments,.mutableContainers]) as? NSDictionary
//                    let jsonString = String(data: data, encoding: .utf8)
                    
                    let doc = json?.value(forKey: "documents") as? NSArray
                    self.placeInfo = doc as? [NSDictionary] ?? []
                    print("place : \(self.placeInfo[0].value(forKey: "place_name")!)")
                    print("address : \(self.placeInfo[0].value(forKey: "address_name")!)")
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }).resume()
        
    }

    
}
