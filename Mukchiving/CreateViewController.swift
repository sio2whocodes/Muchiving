//
//  CreateViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/19.
//

import UIKit
import BSImagePicker
import Photos
import Cosmos

class CreateViewController: UIViewController {
    var tags = ["카페","성신여대","돈암동"] //db에서 원래 있던 태그 불러오기
    var postTitle = "가게 이름"
    var postMemo = "한줄평"
    var location = "장소 추가"
    var imgs: [Data] = []
    var score = 3.5
    
//    let newPost = Post(from: )
    let encoder = JSONEncoder()
//    let picker = UIImagePickerController()
    let imagePicker = ImagePickerController()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        encoder.outputFormatting = .prettyPrinted
        cosmosView.didFinishTouchingCosmos = { rating in
            self.score = self.cosmosView.rating
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(location)
        addLocationBtn.setTitle(location, for: .normal)
        titleTextField.placeholder = "가게이름"
        cosmosView.rating = 3.5
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        //지도 api 연결
    }
    
    
    @IBAction func createPost(_ sender: Any) {
        location = addLocationBtn.currentTitle!
        let newPost = Post(title: postTitle, memo: postMemo, location: location, score: Float(score), created_at: Date())
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
//        present(picker, animated: true, completion: nil)
        imagePicker.settings.selection.max = 4
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            for asset in assets {
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFill,
                                                      options: nil) { (image, info) in
                    self.imgs.append((image?.jpegData(compressionQuality: 0.7))!)
                }
            }
            self.imgCollectionView.reloadData()
        })
    }
    
    
    
}

extension CreateViewController: UITextViewDelegate {
    //화면 터치 시 완료로 바꾸기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        postMemo = textView.text
        print("end")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 450
    }
    
}

extension CreateViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end!")
        postTitle = titleTextField.text ?? "가게이름"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension CreateViewController: UICollectionViewDelegate{
    
}

extension CreateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return tags.count
        } else {
            return imgs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagcell", for: indexPath) as? TagCell else {
                return UICollectionViewCell()
            }
            cell.tagLabel.text = tags[indexPath.item]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgcell", for: indexPath) as? ImgCell else {
                return UICollectionViewCell()
            }
            cell.imgView.image = UIImage(data: imgs[indexPath.item])
            return cell
        }
        
    }
    
    
}

class TagCell: UICollectionViewCell {
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
}

class ImgCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
