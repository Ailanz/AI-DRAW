//
//  StableDiffusionService.swift
//  AI-Draw
//
//  Created by Hsiang Kuo Tu on 2023-06-05.
//

import Foundation
import UIKit

struct Txt2ImgRequest : Codable {
    var prompt = ""
    var sampler_index = "Euler"
    var steps = 20
}

struct Txt2ImgResponse : Codable {
    var images: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case images
    }
}

class StableDiffusionService {
    
    var host = "http://192.168.86.177:7860/"
    var txt2Img = "sdapi/v1/txt2img"
    
    func GenerateImage(prompt : String, callback:  @escaping (_ img: UIImage)-> Void) -> UIImage? {
        var resultImg = Optional<UIImage>.none
        do {
            var payload = Txt2ImgRequest(prompt: prompt)
            let jsonData = try JSONEncoder().encode(payload)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let url = URL(string: host + txt2Img)
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
                
                let decoder = JSONDecoder()
            
              //print(String(data: data, encoding: .utf8)!)
                
                do {
                    let response = try decoder.decode(Txt2ImgResponse.self, from: data)
                    //print(response.images)
                    resultImg = UIImage(data: Data(base64Encoded: response.images[0])!)
                    print("DonE!")
                    callback(resultImg!)
                } catch {
                    print(String(describing: error))
                }
            }

            task.resume()
            
        } catch { print(error) }
        //print("RETURN: " ,resultImg)
        return resultImg
    }
    
}
