import SwiftUI

struct ContentView: View {
    @State private var isNight = false
    @State private var cityName = "London"
    @State private var countryName: String = "United Kingdom"
    @State private var weatherData: Current?
    @State private var today: Days!
    @State private var forecastDays: [DaysDetails]?
    var body: some View {
        ZStack {
            BackGroundView(isNight: isNight)
            VStack {
                // City and Country
                VStack {
                    //  City name here
                    Text(cityName)
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    //  Country name here
                    Text(countryName)
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 0)
                        
                }
                //Icon and current weather
                IconAndDegreeView(icon: getIcon(description: weatherData?.condition.text ?? "", isNight: isNight), degree: (weatherData?.tempC) ?? 0, iconSize: 150, fontSize: 55)
                .padding(.top, 20)
                .padding(.bottom, 50)
                if let forecastDays{
                    ForecastView(weatherForecast: forecastDays, isNight: isNight)
                        .padding(30)
                        .opacity(0.8)

                }
                    
                HStack(spacing: 25) {
                    CountryButtonView(buttonCounty: "London", selectedCountry: cityName, cityName: $cityName)
                    
                    CountryButtonView(buttonCounty: "Cairo", selectedCountry: cityName, cityName: $cityName)
                    
                    CountryButtonView(buttonCounty: "Suez", selectedCountry: cityName, cityName: $cityName)
                    
                    CountryButtonView(buttonCounty: "Riga", selectedCountry: cityName, cityName: $cityName)

                    CountryButtonView(buttonCounty: "Paris", selectedCountry: cityName, cityName: $cityName)
                    
                    CountryButtonView(buttonCounty: "Tokyo", selectedCountry: cityName, cityName: $cityName)
       
                    
                }
                .padding(.top, 50)
                Spacer()
                
            }
            .onChange(of: cityName){ _ in
                Task {
                    do {
                        let data = try await getWeatherData(Country: cityName)
                        weatherData = data.current
                        forecastDays = DaysDetails.getDetailsFromForecast(days: data.forecast.forecastday, today: today)

                        print(weatherData?.condition.text)
                        print(forecastDays)
                        countryName = data.location.country
                        let localTime = String(data.location.localtime.split(separator: " ")[1])
                        
                        if let currentHour = Int(String(localTime.split(separator: ":")[0])), currentHour >= 19 || currentHour <= 6{
                            isNight = true
                        } else {
                            isNight = false
                        }
                        
                        
                        print(data.location.localtime)
                        
                    } catch WeatherError.invalidConnetion {
                        print("There is something wrong with your connection")
                    } catch WeatherError.invalidURL {
                        print("There is something wrong with your URL")

                    } catch WeatherError.invalidData{
                        print("There is something wrong with the data")
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .task {
               
                // handle data
                do {
                    let data = try await getWeatherData(Country: cityName)
                    weatherData = data.current
                    forecastDays = DaysDetails.getDetailsFromForecast(days: data.forecast.forecastday, today: today)

                    
                    countryName = data.location.country
                    let localTime = String(data.location.localtime.split(separator: " ")[1])
                    
                    if let currentHour = Int(String(localTime.split(separator: ":")[0])), currentHour >= 19{
                        isNight = true
                    } else {
                        isNight = false
                    }
                    
                    
                    print(data.location.localtime)
                    
                } catch WeatherError.invalidConnetion {
                    print("There is something wrong with your connection")
                } catch WeatherError.invalidURL {
                    print("There is something wrong with your URL")

                } catch WeatherError.invalidData{
                    print("There is something wrong with the data")
                }catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    
    //fetch weather form API

    func getWeatherData (Country: String) async throws -> Forecast{
    let endpoint: String = "https://api.weatherapi.com/v1/forecast.json?key=3761c78c5ab248d8ac3213040252003&q=\(Country)&days=5&aqi=no&alerts=no"
        guard let url = URL(string: endpoint)else {
           throw WeatherError.invalidURL
        }
        
         let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherError.invalidConnetion
        }
        if let dayString = response.allHeaderFields["Date"] as? String{
            today = Days.getDay(DayInString: String(dayString.split(separator: ",")[0]))

        }
             

        
        
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            throw WeatherError.invalidData
        }
    
    
}
    

}

enum WeatherError: Error{
    case invalidConnetion, invalidURL, invalidData
}

#Preview {
    ContentView()
}



//Data types

enum Days: Int{
    case Fri = 0 , Sat, Mon, Sun, Thes, Wed, Thurs
    
    static func getDay(DayInString:String) -> Days{
        switch (DayInString.lowercased()){
        case "fri":
            return Days.Fri
        case "sat":
            return Days.Sat
        case "sun":
            return Days.Fri
        case "mon":
            return Days.Mon
        case "thu":
            return Days.Thes
        case "wed":
            return Days.Wed
        case "the":
            return Days.Thurs
        default:
            return  Days.Fri
        }
        
        
    }
    
    func getDayInString() -> String{
        switch self {
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        case .Mon:
            return "Mon"
        case .Sun:
            return "Sun"
        case .Thes:
            return "The"
        case .Wed:
            return "Wed"
        case .Thurs:
            return "Thu"
        }
    }
}






