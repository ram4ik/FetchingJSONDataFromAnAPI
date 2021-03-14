//
//  ContentView.swift
//  Shared
//
//  Created by Ramill Ibragimov on 14.03.2021.
//

import SwiftUI

let getUrl = "https://jsonplaceholder.typicode.com/todos"
let postUrl = "https://jsonplaceholder.typicode.com/posts"

struct Model: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool
}

struct PostModel: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

class ViewModel: ObservableObject {
    @Published var items = [Model]()
    
    func loadData() {
        guard let url = URL(string: getUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode([Model].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.items = result
                    }
                } else {
                    print("No data")
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func postData() {
        guard let url = URL(string: postUrl) else {
            return
        }
        
        let title = "foo"
        let bar = "bar"
        let userId = 1
        
        let body: [String: Any] = ["title": title, "body": bar, "userId": userId]
        let finalData = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                    print(result)
                } else {
                    print("No data")
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        
        List(viewModel.items, id: \.id) { item in
            Text(item.title)
        }.onAppear() {
            viewModel.loadData()
            viewModel.postData()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
