//  chatInputView.swift
//  InstagramDemo
//  Created by MOAMEN on 12/1/1397 AP.
//  Copyright © 1397 MOAMEN. All rights reserved.

import UIKit


protocol MessagesDelegate {
    func didSubmitMessage(for message: String)
}

class chatInputView: UIView {

    var delegate: MessagesDelegate?

    

    @IBAction func sendMessage(_ sender: Any) {
    }
}
