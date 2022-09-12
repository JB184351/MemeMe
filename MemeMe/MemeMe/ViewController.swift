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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
