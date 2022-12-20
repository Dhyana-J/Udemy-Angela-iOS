//
//  ViewController.swift
//  WhatFlower
//
//  Created by Kaala on 2022/12/19.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
    }
    
    private func setImagePicker(){
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
//        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    func detect(image:CIImage){
        guard let model = try? VNCoreMLModel(for:FlowerClassifier().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model:model) { request, error in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Failed to classify image")
            }
            
            var flowerName:String = classification.identifier.capitalized
            self.navigationItem.title = flowerName
            self.requestInfo(flowerName: flowerName)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("error perfom handler : \(error)")
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
    private func requestInfo(flowerName:String){
        
        let parameters : [String:String] = [
          "format" : "json",
          "action" : "query",
          "prop" : "extracts|pageimages",
          "exintro" : "",
          "explaintext" : "",
          "titles" : flowerName,
          "indexpageids" : "",
          "redirects" : "1",
          "pithumbsize" : "500"
          ]
        
        Alamofire.request(wikipediaURl,method: .get,parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Got the Wikipedia Info.")
                print(response)
                
                let flowerJSON:JSON = JSON(response.result.value!)
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue

                
                self.imageView.sd_setImage(with: URL(string:flowerImageURL))
                self.label.text = flowerDescription
                
            }
        }
        
        
        
        
    }
    
    
}

extension ViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage.")
            }
            
            detect(image:ciImage)
        }
        
        imagePicker.dismiss(animated: true)
    }
}

extension ViewController:UINavigationControllerDelegate {
    
}

