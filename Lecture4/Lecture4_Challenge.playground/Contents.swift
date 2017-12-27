import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let defaultSession = URLSession(configuration: config)



let urlString = "http://localhost:3000/posts/"
let url = URL(string: urlString)!

//DATA TASK의 completion handler는 데이터, 응답, 에러 객체를 받습니다. 만약에 에러가 없다면 응답을 처리합니다. GET task의 핸들러는 데이터를 app이 사용 가능한 객체로 변환합니다.

//GET 응답이 모두 다르다. 서버의 REST API는 일반적으로 키와 밸류를 처리합니다. 또는 예비 GET과 응답에 대한 검사를 진행할 수도 있습니다. 우리는 RESTed로 파트 투에서 했습니다. 그래서 우리는 response body가 딕셔너리의 배열이며 딕셔너리는 몇몇 키들로 움직이는 것을 저번 시간에 했어여.

//일반적으로 우리의 앱은 Model구조체나 클래스를 가집니다. 모델 객체는 Codable 프로토콜을 수행하고 그것의 프로퍼티 이름은 json 응답의 키와 일치합니다. 우리는 json디코더로 리스폰스 데이터를 파싱하여 모델 객체로 입력할 수 있습니다.


//과제1 : 제이슨 디코더를 만들고 Codable 그리고 Post 객체를 만드세요. 구조체의 속성이름은 리스폰스 데이터의 키와 같게 해야합니다.

//디코더
let decoder = JSONDecoder()
//포스트 객체
struct Post: Codable {
    let id: Int
    let author: String
    let title: String
}





var posts: [Post] = []
var errorMessage = ""


//과제2: task를 만드세요. url과 completion 핸들러를 사용하세요

let task = defaultSession.dataTask(with: url) { data, response, error in
    // When exiting the handler, the page can finish execution
    defer { PlaygroundPage.current.finishExecution() }
    
    if let error = error {
        errorMessage += "DataTask error: " + error.localizedDescription + "\n"
    } else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        // Decode in do-try-catch
        do {
            let posts = try decoder.decode([Post].self, from: data)
            // Show posts
            posts
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)\n"
            return
        }
    }
}

task.resume()

//json-server를 터미널로 시작하셔야 합니다. json-server --watch db.json. 그리고 플레이 그라운드를 실행 하셔야합니다. Rested로도 확인하실 수 있습니다.


