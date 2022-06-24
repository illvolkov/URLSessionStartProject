//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeCall()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<Cards> = { result, response in
            guard let responseUnwrapped = response else { return }

            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let card):
                print("Полученные карты:\n")
                for card in card.cards {
                    print("Имя карты: \(card.name)")
                    print("Тип карты: \(card.type)")
                    if let manaCost = card.manaCost {
                        print("Стоимость маны: \(manaCost)")
                    }
                    print("Редкость: \(card.rarity)")
                    if let originalType = card.originalType {
                        print("Исходный тип: \(originalType)")
                    }
                    print("Название сета: \(card.setName)\n")
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        endpointClient.executeRequest(endpoint, completion: completion)
    }


}

final class GetNameEndpoint: ObjectResponseEndpoint<Cards> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/cards" }
//    override var queryItems: [URLQueryItem(name: "id", value: "1")]?
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        
        return digest.map { String(format: "%02hhx", $0) }.joined() // timestamp + private key + public key (правильный порядок)
    }
    
    override init() {
        super.init()

        queryItems = [
            URLQueryItem(name: "name", value: "Black Lotus|Opt")]
    }
    
}











func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

