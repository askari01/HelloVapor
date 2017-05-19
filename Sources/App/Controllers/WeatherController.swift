import Vapor
import HTTP

final class WeatherController {
    
    func addRoutes(drop: Droplet) {
            drop.group("weather") { group in
                group.get("sunny", handler: sunny)
                group.get(handler: weatherCloudy)
                group.get(String.self, handler: argument)
                group.post("post", handler: post)
        }
    }
    
    func sunny(request: Request) throws -> ResponseRepresentable {
        return "The sun is shinning"
    }
    
    func weatherCloudy(request: Request) throws -> ResponseRepresentable {
        return "The cloudy today"
    }
    
    func argument(request: Request, weather: String) throws -> ResponseRepresentable {
        return try JSON(node:["message":"It's \(weather) today"])
    }
    
    func post(request: Request) throws -> ResponseRepresentable {
        guard let city = request.data["city"]?.string!
            else {
                throw Abort.badRequest
        }
        return try JSON(node: ["message":"It's sunny in \(city)"])
    }
}
