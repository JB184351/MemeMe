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
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        configureTextAttributes()
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
        
//        topTextField.contentHorizontalAlignment
        topTextField.textAlignment = .center
        
//        bottomTextField.textAlignment = .center
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
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
    
    
}

