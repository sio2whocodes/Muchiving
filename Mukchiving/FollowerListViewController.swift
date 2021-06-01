//
//  FollowerListViewController.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/25.
//

import UIKit

class FollowerListViewController: UIViewController {

    var followerList = [UserProfile]()
    let sio2 = UserProfile(username: "소이🌏", user_id: "sio2whocodes", profileImg: UIImage(named: "1")!, bio: "타코, 샌드위치, 치킨 좋아함:)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followerList.append(sio2)
        followerList.append(sio2)
    }
    
}

extension FollowerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "followercell",
                                                       for: indexPath) as? FollowCell else{
            return UITableViewCell()
        }
        cell.usernameLabel.text = followerList[indexPath.row].username
        cell.ProfileMemoLabel.text = followerList[indexPath.row].bio
        cell.profileImgView.image = followerList[indexPath.row].profileImg
        cell.profileImgView.layer.cornerRadius = 28
        return cell
    }
    
    
}

extension FollowerListViewController: UITableViewDelegate {
    
}
