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
    var sampler_index = "DPM++ 2M Karras"
    var steps = 20
    var alwayson_scripts = AlwaysOnScripts()
    
    struct AlwaysOnScripts : Codable {
        var controlnet = ControlNet()
    }
    
    struct ControlNet : Codable {
        var args : [Args] = [Args()]
    }
    
    struct Args : Codable {
        var input_image = ""
        var model = "control_v11p_sd15_lineart [43d4be0d]"
        var module = "lineart_anime"
    }
}

struct Txt2ImgResponse : Codable {
    var images: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case images
    }
}

struct InterrogateRequest : Codable {
    var image = ""
    var model = "clip"
}

struct InterrogateResponse : Codable {
    var caption = ""
}

class StableDiffusionService {
    
    var host = "http://192.168.86.177:7860/"
    var txt2Img = "sdapi/v1/txt2img"
    var interrogate = "sdapi/v1/interrogate"
    
    func CreateRequest(payload: Data, url: String) -> URLRequest {
        let urlAddr = URL(string: url)
        var request = URLRequest(url: urlAddr!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        return request
    }
    
    func InterrogateClip(base64Img : String, callback:  @escaping (_ prompt: String)-> Void) {
        do {
            let payload = InterrogateRequest(image: base64Img)
            let jsonData = try JSONEncoder().encode(payload)
            //let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let request = CreateRequest(payload: jsonData, url: host + interrogate)
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(InterrogateResponse.self, from: data)

                    print("Got Response Interrogate", data, response)
                    callback(response.caption)
                } catch {
                    print(String(describing: error))
                }
            }
            
            task.resume()
            
        } catch { print(error) }
    }
    
    func GenerateImage(prompt : String, base64Img : String, callback:  @escaping (_ img: UIImage)-> Void) {
        do {
            var payload = Txt2ImgRequest(prompt: prompt)
            payload.alwayson_scripts.controlnet.args[0].input_image = base64Img
            
            let jsonData = try JSONEncoder().encode(payload)
            //let jsonString = String(data: jsonData, encoding: .utf8)!
            //print(jsonString)
            let request = CreateRequest(payload: jsonData, url: host + txt2Img)
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let response = try decoder.decode(Txt2ImgResponse.self, from: data)
                    print("Got Response from Txt2Img")
                    callback(response.images[0].imageFromBase64!)
                } catch {
                    print(String(describing: error))
                }
            }
            
            task.resume()
            
        } catch { print(error) }
    }
    
}
