import Foundation

// MARK: - Models

struct Person: Decodable {
    
    let name: String
    let height: String
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
    let birth_year: String
    let gender: String
    let homeworld: String
    let films: [URL]
    let species: [String]
    let vehicles: [String]
    let starships: [String]
    let created: String
    let edited: String
    let url: URL
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

// MARK: - Controllers

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personEndpoint = "people"
    static private let filmsEndPoint = "films"
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // Assemble URL
        guard let baseURL = baseURL else { return completion(nil) }
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        print(personURL)
        
        let finalURL = personURL.appendingPathComponent(String(id))
        print(finalURL)
        // Data Task
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            // Error handling
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // check for data
            guard let data = data else { return completion(nil) }
            
            // decode data
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            // 3 - Check for data
            guard let data = data else { return completion(nil) }
            // 4 - Decode Film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
}


func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        
        let films = person.films
        print("Films in which \(person) appears")
        for film in films {
            fetchFilm(url: film)
        }
        
    }
}
