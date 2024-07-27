//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Om Gandhi on 27/07/2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCamer(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @IBAction func btnGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "imageEditStory") as! ImageEditVC
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true)
    }
}

