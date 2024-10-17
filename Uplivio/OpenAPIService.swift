import Foundation
import UIKit

class OpenAPIService {
    let messagePrompt = "Give me a short, positive motivational message to inspire someone today. The message should be no more than 30 words."

    
//    let backgroundImagePrompt = "Create a soft gradient background with smooth transitions between light pastel colors, such as light blue and white. The background should have a clean and simple surface without any shapes or distracting details, designed to allow text to stand out clearly. The overall aesthetic should be minimalistic and elegant."
    
    let apiKey = "xxxxxxx"

    // MARK: - Fetch Motivational Message

    func fetchMotivationalMessage(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": messagePrompt]
            ],
            "max_tokens": 30,
            "temperature": 0.7
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // API isteği
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching message: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // HTTP yanıt kodunu kontrol et
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("Failed with status code: \(httpResponse.statusCode)")
                    completion(nil)
                    return
                }
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            
                if let choices = jsonResponse?["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String
                {
                    // Motivasyon mesajını geri döndür
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Failed to parse response")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
                    
        task.resume()
    }
    
    
    
    /* Image i openai apisi ile cekmekten vazgectim. image in yuklenmesi 10 saniye suruyor.
     
    // MARK: - Fetch Image

    func generateBackgroundImage(completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/images/generations")!
           
        // Prompt, arka plan oluşturma için
        let parameters: [String: Any] = [
            "model": "dall-e-2",
            "prompt": "Create a soft gradient background with smooth transitions between light pastel colors, such as light blue and white. The background should have a clean and simple surface without any shapes or distracting details, designed to allow text to stand out clearly. The overall aesthetic should be minimalistic and elegant.",
            "n": 1,
            "size": "1024x1024"
        ]
           
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
           
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
           
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
               
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
               
            do {
                // Gelen yanıtı çözümleme
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataArray = jsonResponse["data"] as? [[String: Any]],
                   let firstImageData = dataArray.first,
                   let imageUrlString = firstImageData["url"] as? String,
                   let imageUrl = URL(string: imageUrlString)
                {
                    // Görseli URL'den indir
                    if let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                        completion(image) // Görseli geri döndür
                    } else {
                        print("Failed to load image from URL")
                        completion(nil)
                    }
                } else {
                    print("Failed to parse JSON")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
           
        task.resume()
    }
     */
}
