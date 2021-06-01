//
//  CreateViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/19.
//

import UIKit

class CreateViewController: UIViewController {
    var tags = ["카페","성신여대","돈암동"] //db에서 원래 있던 태그 불러오기
    var postTitle = "가게 이름"
    var postMemo = "한줄평"
    var placeName = "장소 추가"
    
//    let newPost = Post(from: )
    let encoder = JSONEncoder()
    let picker = UIImagePickerController()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var sampleImage: UIImageView!
    @IBOutlet weak var addLocationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        encoder.outputFormatting = .prettyPrinted
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("v1")
        print(placeName)
        addLocationBtn.setTitle(placeName, for: .normal)
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        //지도 api 연결
    }
    
    @IBAction func createPost(_ sender: Any) {
        let newPost = Post(title: postTitle, memo: postMemo, created_at: Date())
        print(newPost)
        /*
        do {
            let data = try encoder.encode(newPost)
            print(String(data: data, encoding: .utf8)!)
            guard let url = URL(string: "http://3.35.3.106") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept-Type")
                let session = URLSession.shared
                session.dataTask(with: request, completionHandler: { (data, response, error) in
                    print("전송완료")
                }).resume()
            }catch{
                print(error.localizedDescription)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        */
        
    }
    
    @IBAction func addImageButton(_ sender: Any) {
        present(picker, animated: true, completion: nil)
    }
    
}

extension CreateViewController: UITextViewDelegate {
    //화면 터치 시 완료로 바꾸기
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @objc func keyBoardWillShow(_ sender: Notification){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyBoardWillHide(_ sender: Notification){
        self.view.frame.origin.y = 0
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        postMemo = textView.text
        print("end")
    }
    
    
}

extension CreateViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing: \((textField.text) ?? "Empty")")
        print("end")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print("textFieldShouldReturn \((textField.text) ?? "Empty")")
        print("d")
//        textField.endEditing(true)
        textField.resignFirstResponder()
        // Process of closing the Keyboard when the line feed button is pressed. textField.resignFirstResponder()
        return true
    }
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            sampleImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UICollectionViewDelegate{
    
}

extension CreateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        cell.tagLabel.text = tags[indexPath.item]
        return cell
    }
    
    
}

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
}
