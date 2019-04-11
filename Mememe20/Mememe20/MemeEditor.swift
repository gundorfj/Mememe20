//
//  ViewController.swift
//  PickingImages
//
//  Created by Jan Gundorf on 09/03/2019.
//  Copyright © 2019 Jan Gundorf. All rights reserved.
//

import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareOutlet: UIBarButtonItem!
    @IBOutlet weak var cancelOutlet: UIBarButtonItem!
    var memeSentFromDetail: MemeStruct?

    let textFieldDelegate = TextFieldDelegate()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -4.0,
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        
        //Only enable the camerabutton of .camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // Setup initial status of buttons
        setStyle(topTextField, label: Constants.topLabel)
        setStyle(bottomTextField, label: Constants.bottomLabel)
        setStatus(status: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        if let memeFromDetail = memeSentFromDetail as MemeStruct! {
            imageView.image = memeFromDetail.memedImage
        }
        
        subscribeTokeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unSubscribeTokeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false

    }
    
    //set textfield helper function
    func setStyle(_ textField: UITextField, label: String )
    {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = textFieldDelegate
        textField.textAlignment = NSTextAlignment.center
        textField.accessibilityIdentifier = label
        textField.text = label
    }
    
    //Open picker action
    @IBAction func openPicker(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType(rawValue: sender.tag) ?? UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    //Cancel button action
    @IBAction func cancel(_ sender: Any)
    {
        // NOw, according to the Project Specification, the cancel button should take you straight back to the Send Memes
        imageView.image = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Image picler delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            setStatus(status: false)
        }
        dismiss(animated: true, completion: nil)
    }

    //Generate memed image
    func generateMemedImage() -> UIImage {
        
        hideToolbars(true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        return memedImage
    }
    
    // Set Toolsbars isHidden property
    func hideToolbars(_ hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    //Move view upwards on Keyboard show
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if (bottomTextField.isFirstResponder)
        {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    //Move view back to original height on Keyboard hide
    @objc func keyboardWillHide(_ notification: Notification)
    {
        view.frame.origin.y = 0
    }

    
    // Cancel the image Picker controller and set button and label status
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        if (imageView.image == nil)
        {
            setStatus(status: true)
        }
    }
    
    // Find the Keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //Subscribe to Keyboard Notifications
    func subscribeTokeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe from Keyboard Notifications
    func unSubscribeTokeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Share the meme
    @IBAction func shareMeme(_ sender: Any) {
        
        let meme_image: UIImage = generateMemedImage()
        let imageToShare = [ meme_image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme(memeImage: meme_image)
            }
        }
    }
    
    //Setup status for fields and buttons
    func setStatus(status: Bool)
    {
        topTextField.isHidden = status
        bottomTextField.isHidden = status
        shareOutlet.isEnabled = !status
        cancelOutlet.isEnabled = true
    }

    // Save the memed image
    func saveMeme(memeImage: UIImage) {
        
        // Create the memed image with all needed parts included
        let meme = MemeStruct(topText: topTextField.text!, buttomText: bottomTextField.text!, imageOriginal: imageView.image!, memedImage: memeImage)
        MemeManager.shared.addToMemeLib(item: meme)
        self.dismiss(animated: true, completion: nil)
    }
}

// 'Watermark' strings for Textfields
struct Constants {
    static let topLabel = "TOP" as String
    static let bottomLabel = "BOTTOM" as String
    
}
