import Foundation

struct Film: Codable{
    
 
    let title: String
    let opening_crawl: String
    let release_date:String
    
}

struct Person: Codable{
    
    let name: String
    let films: [URL]
}

class SwapiService{
    
    static private let  baseURL =  URL(string:"https://swapi.co/api/")
    static private let peopleEndpoint = "people/"
    
    
    static  func fetchPerson(id: Int, completion: @escaping (Person?) -> Void){
        
        guard let baseURL = baseURL else{return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let idURL = peopleURL.appendingPathComponent(String(id))
        print(idURL)
        URLSession.shared.dataTask(with: idURL){(data, _, error) in
            if let error = error{
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else{return completion(nil)}
            
            do{
                print(try JSONDecoder().decode(Person.self, from: data))
                let decodedData = try JSONDecoder().decode(Person.self, from: data)
                return completion(decodedData)
                 }
            catch{print(error, error.localizedDescription)}
        }.resume()
    }
    
    
    
    
    static func fetchFilm(person: Person, completion: @escaping (Film?) -> Void){
        let url = person.films[0]
        print("The Url is: \(url)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          
            if let error = error{error.localizedDescription
                print(error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else{return completion(nil)}
            do{
                
                let decodedData = try JSONDecoder().decode(Film.self, from: data)
                let films = decodedData
                return completion(films)
            }
            catch{ print(error, error.localizedDescription)}
            
            
        }.resume()
    }
        
        
    
    }
//END OF CLASS
    
SwapiService.fetchPerson(id: 1) { person in
    if let person = person {
        print(person)
        SwapiService.fetchFilm(person: person) { (film) in
            if let film = film{
                print( "the film is \(film.title)")
            }
        }
    }
}
