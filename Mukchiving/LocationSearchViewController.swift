//
//  LocationSearchViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/31.
//

import UIKit

class LocationSearchViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var placeInfo: [NSDictionary] = []
    var placeName = "."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(navigationController?.children[0])
        let vc = (navigationController?.children[0]) as! CreateViewController
        vc.location = self.placeName
    }
}

extension LocationSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        var keyword = searchBar.text
        var urlString = "https://dapi.kakao.com/v2/local/search/keyword.json"
        var components = URLComponents(string: urlString)
        var query = URLQueryItem(name: "query", value: keyword)
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments,.mutableContainers]) as? NSDictionary {
                        //let jsonString = String(data: data, encoding: .utf8)
                        DispatchQueue.main.async {
                            let doc = json.value(forKey: "documents") as? NSArray
                            if(doc?.count ?? 0 > 0){
                                self.placeInfo = doc as? [NSDictionary] ?? []
                                print("place : \(self.placeInfo[0].value(forKey: "place_name")!)")
                                print("address : \(self.placeInfo[0].value(forKey: "address_name")!)")
                                self.tableView.reloadData()
                            } else{
                                self.placeInfo.removeAll()
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        //검색 결과 없음
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeName = placeInfo[indexPath.row].value(forKey: "address_name")! as! String
        print(placeName)
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "localcell", for: indexPath) as? LocationCell else {
            return UITableViewCell()
        }
        cell.placeNameLabel.text = placeInfo[indexPath.row].value(forKey: "place_name") as? String
        cell.addressLabel.text = placeInfo[indexPath.row].value(forKey: "address_name") as? String
        
        return cell
    }
    
    
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
}
