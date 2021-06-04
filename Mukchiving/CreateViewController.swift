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
import TTGTagCollectionView

class CreateViewController: UIViewController {
    var tags = ["카페","성신여대","돈암동", "리조또","분당","양식"] //db에서 원래 있던 태그 불러오기
    var selectedTags: [String] = []
    var postTitle = "가게 이름"
    var postMemo = "한줄평"
    var location = "장소 추가"
    var imgs: [Data] = []
    var score = 3.5
    
//    let newPost = Post(from: )
    let encoder = JSONEncoder()
    let imagePicker = ImagePickerController()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var addTagBtn: UIButton!
    
    @IBOutlet weak var addImgBtn: UIButton!
    var tagView =  TTGTextTagCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTagCollectionView()
        encoder.outputFormatting = .prettyPrinted
        cosmosView.didFinishTouchingCosmos = { rating in
            self.score = self.cosmosView.rating
        }
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(location)
        addLocationBtn.setTitle(location, for: .normal)
        titleTextField.placeholder = "가게이름"
        cosmosView.rating = 3.5
        addLocationBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        addLocationBtn.layer.cornerRadius = 5
    }
    
    func setUI(){
        addTagBtn.layer.cornerRadius = 5
        addTagBtn.layer.borderWidth = 1.5
        addTagBtn.layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        addImgBtn.layer.cornerRadius = 5
        memoTextView.layer.cornerRadius = 5
//        memoTextView.backgroundColor = UIColor.lightGray
    }
    
    func setTagCollectionView(){
        tagView = TTGTextTagCollectionView.init(frame: CGRect.init(x: addTagBtn.frame.maxX + 5 , y: titleTextField.frame.maxY+14, width: view.bounds.width - (addTagBtn.frame.width + 35), height: 40))
        self.view.addSubview(tagView)
        tagView.scrollDirection = .horizontal
        for text in tags {
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.white
            content.textFont = UIFont.systemFont(ofSize: 20)
            
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor(named: "mainColor") ?? UIColor.yellow
            normalStyle.extraSpace = CGSize.init(width: 8, height: 10)
            normalStyle.shadowOpacity = 0
            
            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.backgroundColor = UIColor(named: "pointColor") ?? UIColor(displayP3Red: 133/255, green: 110/255, blue: 155/255, alpha: 1)
            selectedStyle.extraSpace = CGSize.init(width: 8, height: 10)
            selectedStyle.shadowOpacity = 0

            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedStyle = selectedStyle
            
            tagView.addTag(tag)
        }
        tagView.reload()
    }
    
    func addNewTag(text: String) -> TTGTextTag{
        let content = TTGTextTagStringContent.init(text: text)
        content.textColor = UIColor.white
        content.textFont = UIFont.systemFont(ofSize: 20)
        
        let normalStyle = TTGTextTagStyle.init()
        normalStyle.backgroundColor = UIColor(named: "mainColor") ?? UIColor.yellow
        normalStyle.extraSpace = CGSize.init(width: 8, height: 8)
        normalStyle.shadowOpacity = 0

        let selectedStyle = TTGTextTagStyle.init()
        selectedStyle.backgroundColor = UIColor(named: "pointColor") ?? UIColor(displayP3Red: 133/255, green: 110/255, blue: 155/255, alpha: 1)
        selectedStyle.extraSpace = CGSize.init(width: 8, height: 8)
        selectedStyle.shadowOpacity = 0

        let tag = TTGTextTag.init()
        tag.content = content
        tag.style = normalStyle
        tag.selectedStyle = selectedStyle
        
        return tag
    }
    
    
    @IBAction func addTagButton(_ sender: Any) {
        let alert = UIAlertController(title: "태그 추가", message: "추가할 태그를 입력하세요.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let add = UIAlertAction(title: "추가", style: .default) {_ in
            if let newTag = alert.textFields?[0].text {
                if newTag != "" {
                    self.tags.append(newTag)
                    self.tagView.addTag(self.addNewTag(text: newTag))
                    self.tagView.reload()
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addLocationButton(_ sender: Any) {
        //지도 api 연결
    }
    
    func tagToString(selectedTags: [TTGTextTag])->[String] {
        var tagList: [String] = []
        for tag in selectedTags {
            tagList.append(tag.content.getAttributedString().string)
        }
        return tagList
    }
    
    
    @IBAction func createPost(_ sender: Any) {
        location = addLocationBtn.currentTitle!
        selectedTags = tagToString(selectedTags: tagView.allSelectedTags())
        
        let newPost = Post(title: postTitle, memo: postMemo, tags: selectedTags, location: location, score: Float(score), created_at: Date())
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
        imagePicker.settings.selection.max = 4
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // User finished selection assets.
            var imgList:[Data] = []
            for asset in assets {
                PHImageManager.default().requestImage(for: asset,
                                                      targetSize: PHImageManagerMaximumSize,
                                                      contentMode: .aspectFill,
                                                      options: nil) { (image, info) in
                    imgList.append((image?.jpegData(compressionQuality: 0.7))!)
                }
            }
            self.imgs = imgList
            self.imgCollectionView.reloadData()
        })
    }
    
    
    
}

extension CreateViewController: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
    }
    
}
extension CreateViewController: UITextViewDelegate {
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
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgcell", for: indexPath) as? ImgCell else {
            return UICollectionViewCell()
        }
        cell.imgView.image = UIImage(data: imgs[indexPath.item])
        cell.imgView.layer.cornerRadius = 5
        return cell
    }
    
    
}

class ImgCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
