import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



/*
 url로도 전달이 가능하고 request로도 연결이 가능하다.
 환경설정 등록
 환경 설정을 세션에 등록
 url주소 만들기
 디코더 만들고 (json디코더로) + 통신에 실어나를 객체에 codable로 상속하여 쉽게 문자열로 변환이 가능하게 함
 세션에 url을 넣어서 데이터태스크를 만듦
 */


//CH4. GET방식 연결하기 :: 실습용 json server 와 함께함

//환경 설정 등록
let config = URLSessionConfiguration.default
config.waitsForConnectivity = true

//세션으로 환경 설정 등록
let defaultSession = URLSession(configuration: config)

//url 주소 입력
let urlString = "http://localhost:3000/posts/"
let url = URL(string: urlString)!

//디코더 만들기 + 객체를 Codable로 만들어 쉽게 문자열로 변환이 가능한 객체로 만든다.
let decoder = JSONDecoder()
struct Post: Codable{
    let id: Int
    let authour: String
    let title: String
}

var posts: [Post] = []
var errorMessage = ""

//dataTask를 만듦
let task = defaultSession.dataTask(with: url){
    data, response, error in defer{ PlaygroundPage.current.finishExecution() }
    
    //에러가 있다면 처리
    if let error = error{
        errorMessage += "DataTask error: " + error.localizedDescription + "\n"
    }//에러가 없다면 데이터를 보고 리스폰스의 상태 코드를 보고 아무 문제가 없으면 do 문장을 수행
    else if let data = data,
        let response = response as? HTTPURLResponse,
        response.statusCode == 200 {
        // Decode in do-try-catch
        do {
            let posts = try decoder.decode([Post].self, from: data)
            // Show posts
            posts
        } catch let decodeError as NSError{
            //디코딩 에러가 발생시 사용
            errorMessage += "Decoder Error : \(decodeError.localizedDescription)"
        }
    }
}

task.resume()



//CH5. POST방식 연결하기 :: 실습용 json server 와 함께함
/*
 세션을 만들자 ephemeral로 : 하여 캐시 사용을 안함
 url만듦
 데이터 태스크 만듦
 
 URLRequest로 Post 데이터 태스크 만들자
 여러 환경 설정을 함
 캐시 정책
 네트워크 서비스 타입 : 백그라운드
 
 encoder만들기
 
 
 
 
 */

