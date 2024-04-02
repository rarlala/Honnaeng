//
//  ImageFileManager.swift
//  Honnaeng
//
//  Created by Rarla on 4/2/24.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    private init(){}
    
    func saveImageToFileSystem(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil }
          let fileName = UUID().uuidString + ".jpeg"
          let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

          do {
              try imageData.write(to: filePath)
              return fileName
          } catch {
              print("Error saving image: \(error)")
              return nil
          }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadImageFromFileSystem(fileName: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }
}
