//
//  ViewController.swift
//  Memes
//
//  Created by Xicheng Wang on 11/29/20.
//  Copyright © 2020 xichengw. All rights reserved.
//

import UIKit

// A struct to contain information about stored Meme
struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}

class ViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private var imagePicker: UIImagePickerController;
    private var currentEditingTextField: UITextField?; // used to avoid unnecessary frame slide up
    
    @IBOutlet weak var shareButton: UIBarButtonItem!;
    @IBOutlet weak var cancelButton: UIBarButtonItem!;
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!;
    @IBOutlet weak var albumButton: UIBarButtonItem!;
    
    required init?(coder aDecoder: NSCoder) {
        // eager initialization
        self.imagePicker = UIImagePickerController();
        super.init(coder: aDecoder);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        subscribeToKeyboardNotifications();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        unsubscribeFromKeyboardNotifications();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // setup
        imageView.backgroundColor = .black;
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera);
        shareButton.isEnabled = false;
        topText.text = "TOP";
        bottomText.text = "BOTTOM";
        self.setupForTextField(topText);
        self.setupForTextField(bottomText);
    }
    
    @IBAction func openCamera(_ sender: Any) {
        presentImagePicker(withSource: .camera);
    }
    
    @IBAction func openAlbum(_ sender: Any) {
        presentImagePicker(withSource: .photoLibrary);
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let generatedImage = self.generateMemedImage();
        let activity = UIActivityViewController(
            activityItems: ["I created this picture, look!", generatedImage],
            applicationActivities: nil
        );
        activity.popoverPresentationController?.barButtonItem = sender;
        activity.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
            Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(generatedImage);
            }
        }
        self.present(activity, animated: true, completion: nil);
    }
    
    func presentImagePicker(withSource source: UIImagePickerController.SourceType) {
        self.imagePicker = UIImagePickerController();
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = source;
        self.present(self.imagePicker, animated: true, completion: nil);
    }
    
    func setupForTextField(_ textField: UITextField) {
        textField.textAlignment = .center;
        textField.delegate = self;
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: 0 // any positive value will make entire text black
        ];
        textField.defaultTextAttributes = memeTextAttributes;
    }
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedimage = info[.originalImage] as? UIImage else {
            return;
        }
        self.imageView?.image = selectedimage;
        shareButton.isEnabled = true;
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
}

extension ViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentEditingTextField = textField;
        textField.text = "";
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentEditingTextField = nil;
        textField.resignFirstResponder();
        return true;
    }
}

// keyboard related code
extension ViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil);
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (self.bottomText == currentEditingTextField) {
            view.frame.origin.y -= getKeyboardHeight(notification);
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if (view.frame.origin.y < 0) { // y is offscreen, we should retore y to 0
            view.frame.origin.y = 0;
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo;
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue;
        return keyboardSize.cgRectValue.height;
    }
}

extension ViewController {
    func save(_ memedImage: UIImage) {
        // Create the meme, but not stored in any db
        _ = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalImage: imageView.image!, memedImage: memedImage);
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size);
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true);
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return memedImage;
    }
}
