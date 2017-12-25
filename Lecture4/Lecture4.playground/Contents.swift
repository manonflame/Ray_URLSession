import Foundation
// The playground must keep running until the asynchronous task completes:
import PlaygroundSupport

//플레이그라운드를 계속 실행함.
PlaygroundPage.current.needsIndefiniteExecution = true


let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
let defaultSession = URLSession(configuration: config)

struct Track: Decodable {
    let trackName: String
    let artistName: String
    let previewUrl: String
}

struct TrackList: Decodable {
    let results: [Track]
}




class QueryService {
    var tracks: [Track] = []
    var errorMessage = ""


    func getSearchResults() {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")!
        //: The default HTTP method is GET, so a GET data task only needs a url.
        //: The simplest data task has a completion handler, which receives optional
        //: data, URLResponse, and error objects:
        //url을 연결함
        let task = defaultSession.dataTask(with: url) { data, response, error in
            // When exiting the handler, the page can finish execution
            // 에러 처리를 담당하는 부분 : 클라이언트에서 발생하는 에러를 처리
            defer { PlaygroundPage.current.finishExecution() }
            
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                //데이터가 있으면
                //: After checking for a network error, we cast the response as HTTPURLResponse,
                //: to check the status code: 200 means OK:
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                //updateSearchResults: 데이터를 파싱하는 부분
                self.updateSearchResults(data)
                // In a playground, we can just ask to see objects:
                self.tracks
                self.errorMessage
            }
        }
        task.resume()
    }
    //: Session tasks are always created in a suspended state, so remember to call `resume()` to start it.
    //:
    //: Converting response data to tracks happens in `updateSearchResults(_:)`.
    //: The data returned by `dataTask`
    //: is a JSON file, which we'll decode into a `TrackList`.
    //: The [iTunes Search API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/) describes the keys and values in the response data,
    //: so we know the value of the `results` key is an array of dictionaries.
    //: And we've already created the `Track` struct with properties that match the keys in these dictionaries.
    //: A `JSONDecoder` automatically converts the response data into an array of `Track` objects.
    func updateSearchResults(_ data: Data) {
        let decoder = JSONDecoder()
        tracks.removeAll()
        //: `JSONDecoder` can throw an error, so we use a do-try-catch statement:
        do {
            //list는 내가만든 TrackList임
            let list = try decoder.decode(TrackList.self, from: data)
            tracks = list.results
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)\n"
            return
        }
    }
}

//: ### Run `getSearchResults`
//: Run this playground, and you'll see the `tracks` array in the sidebar, beside the handler, above.
QueryService().getSearchResults()
