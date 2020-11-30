//
//  ViewController.swift
//  Memes
//
//  Created by Xicheng Wang on 11/29/20.
//  Copyright © 2020 xichengw. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    private var imagePicker: UIImagePickerController;
    
    @IBOutlet weak var shareButton: UIBarButtonItem!;
    @IBOutlet weak var cancelButton: UIBarButtonItem!;
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var topText: UITextView!
    @IBOutlet weak var bottomText: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!;
    @IBOutlet weak var albumButton: UIBarButtonItem!;
    
    required init?(coder aDecoder: NSCoder) {
        self.imagePicker = UIImagePickerController();super.init(coder: aDecoder);
        // empty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // setup
        imageView.backgroundColor = .black;
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera);
        topText.isEditable = true;
        bottomText.isEditable = true;
        topText.textContainer.maximumNumberOfLines = 1;
        bottomText.textContainer.maximumNumberOfLines = 1;
        topText.textAlignment = .center;
        bottomText.textAlignment = .center;
        topText.delegate = self as UITextViewDelegate;
        bottomText.delegate = self as UITextViewDelegate;
    }
    
    @IBAction func openCamera(_ sender: Any) {
        presentImagePicker(withSource: .camera);
    }
    
    @IBAction func openAlbum(_ sender: Any) {
        presentImagePicker(withSource: .photoLibrary)
    }
    
    func presentImagePicker(withSource source: UIImagePickerController.SourceType) {
        self.imagePicker = UIImagePickerController();
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = source;
        self.present(self.imagePicker, animated: true, completion: nil);
    }
}


extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedimage = info[.originalImage] as? UIImage else {
            return;
        }
        self.imageView?.image = selectedimage;
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
}

extension ViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        <#code#>
    }(_ textField: UITextField) {
        textField.text = "";
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
