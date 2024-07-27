//
//  ImageEditVC.swift
//  PhotoEditor
//
//  Created by Om Gandhi on 27/07/2024.
//

import UIKit

class ImageEditVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    

    @IBOutlet weak var lblCurrentValue: UILabel!
    @IBOutlet weak var sliderEditValues: UISlider!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewSlider: UIView!
    var image: UIImage?
    
    var imageControlArr = [["name":"Exposure","value":0],
                           ["name":"Brightness","value":0],
                           ["name":"Highlights","value":0],
                           ["name":"Shadows","value":0]] as [[String:Any]]
    var aCIImage = CIImage();
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    var exposureFilter: CIFilter!
    var context = CIContext();
    var outputImage = CIImage();
    var newUIImage = UIImage();
    var orientation = UIImage.Orientation.up
    var imageScale = CGFloat()
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = image
        viewSlider.isHidden = true
        sliderEditValues.minimumValue = -1
        sliderEditValues.maximumValue = 1
        sliderEditValues.value = 0
        
        
        var aUIImage = imgView.image
        var aCGImage = aUIImage?.cgImage;
        aCIImage = CIImage(cgImage: aCGImage!)
            context = CIContext(options: nil);
            contrastFilter = CIFilter(name: "CIColorControls");
            contrastFilter.setValue(aCIImage, forKey: "inputImage")
            brightnessFilter = CIFilter(name: "CIColorControls");
            brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter.setValue(aCIImage, forKey: "inputImage")
        imageScale = imgView.image?.scale ?? 0.00
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageControlArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageEditCell", for: indexPath) as! ImageEditCell
        cell.lblOptions.text = imageControlArr[indexPath.row]["name"] as? String ?? ""
        cell.imgOptions.image = UIImage(systemName: "lightbulb.fill")
        cell.layer.borderColor = UIColor.label.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.height/2
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewSlider.isHidden = false
        lblCurrentValue.text = String(format: "%.2f", imageControlArr[indexPath.row]["value"] as? Float ?? 0.00)
        sliderEditValues.value = imageControlArr[indexPath.row]["value"] as? Float ?? 0.00
        selectedIndex = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    @IBAction func btnBack(_ sender: Any) {
        viewSlider.isHidden = true
        selectedIndex = -1
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        switch selectedIndex{
        case 0: let sliderValue = sliderEditValues.value
            exposureFilter.setValue(NSNumber(value: sliderValue), forKey: "inputEV");
            outputImage = exposureFilter.outputImage!;
            let imageRef = context.createCGImage(outputImage, from: aCIImage.extent)
            newUIImage = UIImage(cgImage: imageRef!,scale: imageScale,orientation: image?.imageOrientation ?? .up)
            imgView.image = newUIImage.fixOrientation();
            imageControlArr[0]["value"] = sliderEditValues.value
            lblCurrentValue.text = String(format: "%.2f", imageControlArr[0]["value"] as? Float ?? 0.00)
            break
        case 1: let sliderValue = sliderEditValues.value
            brightnessFilter.setValue(NSNumber(value: sliderValue), forKey: "inputBrightness");
            outputImage = brightnessFilter.outputImage!;
            let imageRef = context.createCGImage(outputImage, from: aCIImage.extent)
            newUIImage = UIImage(cgImage: imageRef!,scale: imageScale,orientation: image?.imageOrientation ?? .up)
            imgView.image = newUIImage.fixOrientation();
            imageControlArr[0]["value"] = sliderEditValues.value
            lblCurrentValue.text = String(format: "%.2f", imageControlArr[1]["value"] as? Float ?? 0.00)
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:break
        }
        
    }
    
}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
    return self

    }

    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        self.draw(in: CGRectMake(0, 0, self.size.width, self.size.height))

        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!

    UIGraphicsEndImageContext()

    return normalizedImage;

    }
}
