//
//  PostViewController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 15.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import Alamofire

class PostViewController: UIViewController {

    var textLocation : String?
    @IBOutlet weak var textPost: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let opq = OperationQueue()
    
    @IBAction func post(_ sender: Any) {
        let postService = PostService(textPost.text)
        let url = postService.baseURLMethod + postService.path + postService.methodRequest
        let request = Alamofire.request(url, method: .post, parameters: postService.parameters)
        
        let getDataOperation = GetDataOperation(request: request)
        opq.addOperation(getDataOperation)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func addLocation(_ sender: Any) {
    
    }
}
