//
//  ViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/9/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.delegate = memeTextFieldDelegate
        bottomTextField.delegate = memeTextFieldDelegate
        saveButton.isEnabled = false
        imageView.image = UIImage(named: "MemeGenerator_120 copy")
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
    
    // MARK: - Enables app to save/share meme
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let savedMeme = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [savedMeme], applicationActivities: nil)
        present(activityController, animated: true)
        
        // Quesiton, I don't understand the purpose of having this here, I know it was part of the project instructions
        // but what does this do?
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
            }
        }
    }
    
    // MARK: - Image Picker Actions

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
    
    // MARK: - Keyboard Notifications
    
    private func subscribedToKeyboardNotificaitons() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribedFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - Methods for saving/sharing the meme
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
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

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        saveButton.isEnabled = false && imageView.image == nil
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            imageView.contentMode = .scaleAspectFit
        }
        
        saveButton.isEnabled = true
        
        dismiss(animated: true)
    }
}

