//
//  LoginViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/31.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var loginStatus: UILabel!
    
    var id = "test1"
    var pw = "1111"
    var msg = ""
    
//    let url = "http://15.164.226.153/api/v1/auth/login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginStatus.text = ""
    }
    @IBAction func loginBtn(_ sender: Any) {
        id = idField.text!
        pw = pwField.text!
        let param = ["user_id":id, "password":pw]
                
        guard let url = URL(string: "http://15.164.226.153/api/v1/auth/login") else {
            print("url nil")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let body = try? JSONSerialization.data(withJSONObject: param, options: [.fragmentsAllowed]) else {
            print("json error")
            return
        }
        request.httpBody = body
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            print("전송완료")
            self.loginStatus.text = "로그인 성공"
            if let response = response {
                print("\(response)")
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments,.mutableContainers]) as? NSDictionary
                    print(json)
                    print(json?.value(forKey: "message"))
                    self.msg = json?.value(forKey: "message") as! String
                    print(json?.value(forKey: "success"))
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
        
    }
    
}
