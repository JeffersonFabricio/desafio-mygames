//
//  EditViewController.swift
//  MyGames
//
//  Created by Aluno on 29/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import Photos

class EditViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var btCover: UIButton!
    
    var console: Console?
    
    @IBAction func addEditConsole(_ sender: UIButton) {
        // acao salvar novo ou editar existente
        print("addEditConsole")
        
        if console == nil {
            console = Console(context: context)
        }
        console?.name = titleLabel.text
        console?.cover = cover.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConsolesManager.shared.loadConsoles(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareDataLayout()
    }
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar console"
            // btAddEdit.setTitle("ALTERAR", for: .normal)
            titleLabel.text = console?.name
            
            cover.image = console?.cover as? UIImage

            if console?.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.chooseImageFromLibrary(sourceType: sourceType)
                } else {
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
}

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConsolesManager.shared.consoles.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = ConsolesManager.shared.consoles[row]
        return console.name
    }
}

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // fechar a janela
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.cover.image = pickedImage
                self.cover.setNeedsDisplay()
                self.btCover.setTitle(nil, for: .normal)
                self.btCover.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
