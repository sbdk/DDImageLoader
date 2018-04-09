//
//  SLWebImageManager.swift
//  SLImageLoader
//
//  Created by Li Yin on 4/7/18.
//  Copyright © 2018 Li Yin. All rights reserved.
//

import UIKit

enum SLWebImageCacheRule {
  case memoryOnly, diskOnly, memoryAndDisk, none
}

class SLWebImageManager: NSObject {
  static let shared = SLWebImageManager()
  private let memoryCache = NSCache<AnyObject, AnyObject>()
  
  private var cacheRule: SLWebImageCacheRule = .diskOnly
  
  fileprivate func saveImageIntoCache(urlString: String, image: UIImage, cacheRule: SLWebImageCacheRule = .memoryAndDisk) {
    switch cacheRule {
    case .memoryOnly:
      memoryCache.setObject(image, forKey: urlString as AnyObject)
      break;
      
    case .diskOnly:
      guard let data = UIImagePNGRepresentation(image) else {
        print("can't create image data")
        return
      }
      let folderPath = getImageDocPath()
      
      //If no image saved in this folder before, create the folder first
      if !FileManager.default.fileExists(atPath: folderPath.path) {
        do {
          try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
          print("Create image folder success: \(folderPath.path)")
        } catch let error {
          print("Can't create image folder, \(error.localizedDescription)")
        }
      }
      
      //Save image into folder
      let fileName = URL(fileURLWithPath: urlString).lastPathComponent
      let imagePathUrl = folderPath.appendingPathComponent(fileName)
      do {
        try data.write(to: imagePathUrl, options: .atomic)
      } catch let error {
        print("Can't save image into disk, \(error.localizedDescription)")
      }
      
      break;
    case .memoryAndDisk:
      //First save in memory
      memoryCache.setObject(image, forKey: urlString as AnyObject)
      
      //Then save in disk
      guard let data = UIImagePNGRepresentation(image) else {
        print("can't create image data")
        return
      }
      let folderPath = getImageDocPath()
      
      //If no image saved in this folder before, create the folder first
      if !FileManager.default.fileExists(atPath: folderPath.path) {
        do {
          try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
          print("Create image folder success: \(folderPath.path)")
        } catch let error {
          print("Can't create image folder, \(error.localizedDescription)")
        }
      }
      
      //Save image into folder
      let fileName = URL(fileURLWithPath: urlString).lastPathComponent
      let imagePathUrl = folderPath.appendingPathComponent(fileName)
      do {
        try data.write(to: imagePathUrl, options: .atomic)
      } catch let error {
        print("Can't save image into disk, \(error.localizedDescription)")
      }
      break;
      
    case .none:
      break;
    }
  }
  
  fileprivate func fetchImageFromCacheFor(urlString: String, cacheRule: SLWebImageCacheRule = .memoryAndDisk) -> UIImage? {
    switch cacheRule {
    case .memoryOnly:
      if let image = memoryCache.object(forKey: urlString as AnyObject) as? UIImage {
        print("find a image in memory")
        return image
      } else {
        return nil
      }
  
    case .diskOnly:
      var pathUrl = getImageDocPath()
      let fileName = URL(fileURLWithPath: urlString).lastPathComponent
      pathUrl.appendPathComponent(fileName)
      print("Image path to fetch : \(pathUrl)")
      if FileManager.default.fileExists(atPath: pathUrl.path) {
        let image = UIImage(contentsOfFile: pathUrl.path)
        print("Find a image in disk")
        return image
      }
      print("Can't find image in disk")
      return nil
      
    case .memoryAndDisk:
      //First try memory
      if let image = memoryCache.object(forKey: urlString as AnyObject) as? UIImage {
        print("find a image in memory")
        return image
      }
      
      //Then try disk
      var pathUrl = getImageDocPath()
      let fileName = URL(fileURLWithPath: urlString).lastPathComponent
      pathUrl.appendPathComponent(fileName)
      print("Image path to fetch : \(pathUrl)")
      if FileManager.default.fileExists(atPath: pathUrl.path) {
        if let image = UIImage(contentsOfFile: pathUrl.path) {
          print("Find a image in disk")
          
          //Save this image into memory
          memoryCache.setObject(image, forKey: urlString as AnyObject)
          
          return image
        } else {
          print("can't generate image file")
          return nil
        }
      }
      print("Can't find image in disk")
      return nil
      
    case .none:
      return nil
    }
  }
  
  fileprivate func removeImageCacheFor(urlString: String) {
    switch cacheRule {
    case .memoryOnly:
      memoryCache.removeObject(forKey: urlString as AnyObject)
      break;
    case .diskOnly:
      
      break;
    case .memoryAndDisk:
      
      break;
    case .none:
      
      break;
    }
  }
  
  private func getImageDocPath() -> URL {
    var docPathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    docPathUrl.appendPathComponent("SLWebImage")
    return docPathUrl
  }
}

extension UIImageView {
  func loadImageWithUrlString(urlString: String, cacheRule: SLWebImageCacheRule = .memoryAndDisk, completion: @escaping (Bool) -> Void) {
    
    if let imageFromCache = SLWebImageManager.shared.fetchImageFromCacheFor(urlString: urlString, cacheRule: cacheRule) {
      self.image = imageFromCache
      completion(true)
      return
    }
    
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
      if error != nil {
        print(error!.localizedDescription)
        completion(false)
        return
      }
      
      DispatchQueue.main.async {
        print("Finish downloading image from web")
        let image = UIImage(data: data!)
        SLWebImageManager.shared.saveImageIntoCache(urlString: urlString, image: image!, cacheRule: cacheRule)
        self.image = image
        completion(true)
      }
      }.resume()
  }
}
