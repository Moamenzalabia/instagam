//  ChatVC.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit
import Firebase

class ChatVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let cellId = "ChatCell"
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messages"
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        fetchMessages()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        cell.message = self.messages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let chatCell = ChatCell(frame: frame)
        chatCell.message = messages[indexPath.item]
        chatCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = chatCell.systemLayoutSizeFitting(targetSize)
        let height = max( 50 + 8 + 8, estimatedSize.height)
        
        return  height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func fetchMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let  messagesDictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = messagesDictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let message = Message(user: user, messagesDictionary: messagesDictionary)
                self.messages.append(message)
                self.chatTableView.reloadData()
            })
        }) { (error) in
            print("Failed to observe messages")
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        guard let message = messageTextField.text, message.isEmpty == false else { return}
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["text": message, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("messages").child(uid).childByAutoId().updateChildValues(values) { (error, referance) in
            if let error = error {
                print("Failed to insert mesage: ",error.localizedDescription)
                return
            }
            print("Successfully inserted message")
        }
    }

}
