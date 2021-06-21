//
//  ViewController.swift
//  SeaFood
//
//  Created by Kenny on 2021/6/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    
    private let imagePickerVC = UIImagePickerController()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = false
        
    }
    
    
    
    // MARK: - Methods
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePickerVC, animated: true, completion: nil)
    }
    
}

// MARK: - ImagePickerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userImage = info[.originalImage] as? UIImage,
              let ciImage = CIImage(image: userImage) else { return }
        
        imageView.image = userImage
        
        detect(image: ciImage)
        
        dismiss(animated: true, completion: nil)
    }
    
    private func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let result = request.results as? [VNClassificationObservation] else { return }
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hot Dog!!!"
                } else {
                    self.navigationItem.title = "Not Hot Dog!!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try? handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}
