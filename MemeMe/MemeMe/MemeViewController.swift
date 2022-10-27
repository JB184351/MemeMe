//
//  ViewController.swift
//  MemeMe
//
//  Created by Justin Bengtson on 9/9/22.
//

import UIKit
import AVFoundation

class MemeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        saveButton.isEnabled = false
        imageView.image = UIImage(named: "MemeGenerator_180 copy")
        configureTextAttributes(topTextField)
        configureTextAttributes(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribedToKeyboardNotificaitons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribedFromKeyboardNotifications()
    }
    
    private func configureTextAttributes(_ textField: UITextField) {
        let strokeColor: UIColor = .black
        let foregroundColor: UIColor = .white
        let fontType: UIFont = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        let strokeWidth = -3.5
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: strokeColor,
            .foregroundColor: foregroundColor,
            .font: fontType,
            .strokeWidth: strokeWidth,
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = memeTextFieldDelegate
        textField.textAlignment = .center
    }
    
    // MARK: - Enables app to save/share meme
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let savedMeme = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [savedMeme], applicationActivities: nil)
        present(activityController, animated: true)
        
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Image Picker Actions
    
    @IBAction func photoLibraryImagePickerAction(_ sender: Any) {
        pickImage(with: .photoLibrary)
    }
    
    @IBAction func cameraImagePIckerAction(_ sender: Any) {
        pickImage(with: .camera)
    }
    
    
    private func pickImage(with sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
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
            view.frame.origin.y = -getKeyboardHeight(notification)
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
    
    private func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memeImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    private func generateMemedImage() -> UIImage {
        toggleWhatIsHidden()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toggleWhatIsHidden()
        
        return memedImage
    }
    
    private func toggleWhatIsHidden() {
        tabBarController?.tabBar.isHidden = !(tabBarController?.tabBar.isHidden ?? true)
        navigationController?.navigationBar.isHidden = !(navigationController?.navigationBar.isHidden ?? true)
        topToolBar.isHidden = !topToolBar.isHidden
        bottomToolBar.isHidden = !bottomToolBar.isHidden
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MemeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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

