import SwiftUI

struct Location: Codable {
    var name: String
    var country: String
    var localtime: String
}
struct Current: Codable {
    var condition: Condition
    var tempC: Decimal
}
struct Condition: Codable {
    var text: String
}
struct WeatherDay: Codable{

    var location: Location
}
struct DaysDetails {
    static var currentDay = 1
    var dayId: Int
    var dayName: Days
    var dayWeather: Day
    
    static func getDetailsFromForecast(days: [ForecastDay], today: Days) -> [DaysDetails]{
        var casted: [DaysDetails] = []
        var previousDay = today.rawValue
        var todayDay = today.rawValue + 1
        var counter = 0
        for everyDay in days {

            if (todayDay > 6){
                todayDay = 0
            }
            guard let name =  Days(rawValue: todayDay) else{
                continue
            }
            print(name)
            let currentDay = DaysDetails(dayId: counter, dayName: name, dayWeather: everyDay.day)
            casted.append(currentDay)
                todayDay += 1
                counter += 1
            

        }
       
        return casted
    }
}
struct Day: Codable{
    var maxtempC: Decimal
    var condition: Condition
}
struct ForecastDay: Codable{
    var day: Day
    var astro: Astro

}
struct FFCast: Codable{
    var forecastday: [ForecastDay]
}
struct Forecast: Codable{
    var location: Location
    var current:Current
    var forecast: FFCast

}
struct Astro: Codable {
    var isMoonUp: Int
}
