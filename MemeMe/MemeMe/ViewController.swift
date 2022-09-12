//
//  ViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/9/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        saveButton.isEnabled = imageView.image == nil
        configureTextAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribedToKeyboardNotificaitons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribedFromKeyboardNotifications()
    }
    
    private func configureTextAttributes() {
        
        let strokeColor: UIColor = .black
        let foregroundColor: UIColor = .white
        let fontType: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let strokeWidth = 6
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: strokeColor,
            .foregroundColor: foregroundColor,
            .font: fontType,
            .strokeWidth: strokeWidth
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let savedMeme = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [savedMeme], applicationActivities: nil)
        present(activityController, animated: true)
        
        // Quesiton, I don't understand the purpose of having this here, I know it was part of the project instructions
        // but what does this do?
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            self.save()
        }
    }
    

    @IBAction func photoLibraryImagePickerAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true)
            } else {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            imagePicker.delegate = self
                            imagePicker.sourceType = .photoLibrary
                            self.present(imagePicker, animated: true)
                        } else {
                            //TODO: Permissions not granted take user to settings
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cameraImagePickerAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            imagePicker.delegate = self
                            imagePicker.sourceType = .camera
                            self.present(imagePicker, animated: true)
                        }
                    } else {
                        // TODO: Permissions not granted take user to settings
                    }
                }
            }
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            imageView.contentMode = .scaleAspectFit
        }
        
        dismiss(animated: true)
    }
    
    private func subscribedToKeyboardNotificaitons() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribedFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

        return memedImage
    }
}

