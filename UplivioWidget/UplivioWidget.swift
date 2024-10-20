import SwiftUI
import WidgetKit

// Bu sınıf, widget'ı besleyen sağlayıcıdır (Provider). Bu, widget'e zaman çizelgesi (timeline) bilgileri sağlar.
struct Provider: AppIntentTimelineProvider {
    // Placeholder: Widget'in ilk yüklenirken gösterilecek placeholder verisi.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Loading...") // Placeholder, "Loading..." mesajıyla gösterilir.
    }

    // Snapshot: Widget'te gösterilecek statik veriyi oluşturur. Gerçek zamanlı gösterim sırasında bu fonksiyon çağrılır.
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Believe in yourself!") // Snapshot için sabit bir mesaj.
    }

    // Timeline: Widget'teki verinin zaman çizelgesini oluşturur. Bu, widget'in verilerinin ne sıklıkla güncelleneceğini belirler.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Mesajı OpenAI API'den çekiyoruz. Eğer API başarısız olursa, varsayılan olarak "Stay positive!" mesajını gösteriyoruz.
        let message = await fetchMotivationalMessage() ?? "Stay positive!"

        // Şu anki zaman dilimini alıyoruz.
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, message: message) // Çekilen mesaj ile bir zaman dilimi girdisi oluşturuluyor.

        // Widget'in bir sonraki saat diliminde güncellenmesi için bir saat sonrasını belirtiyoruz.
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate)) // Widget 1 saat sonra güncellenir.

        return timeline
    }

    // Bu fonksiyon OpenAI API'ye bir HTTP isteği göndererek motivasyon mesajı alır.
    func fetchMotivationalMessage() async -> String? {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")! // API URL'si.
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // HTTP POST isteği.
        request.setValue("Bearer xxxxx", forHTTPHeaderField: "Authorization") // API anahtarı (güvenlik için).
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // JSON içerik tipi ayarlanır.

        // API'ye gönderilecek parametreler: model, mesaj ve diğer ayarlar.
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": "Give me a short, positive motivational message to inspire someone today. The message should be no more than 20 words, and it should be a complete sentence."]],
            "max_tokens": 20, // Yanıtın en fazla 30 token (kelime ya da karakter) uzunluğunda olmasını belirtir.
            "temperature": 0.7 // Rastgelelik derecesi, daha düşük sıcaklık daha tutarlı yanıtlar verir.
        ]

        // Parametreleri JSON verisine çeviriyoruz.
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData

        do {
            // HTTP isteğini URLSession ile gönderiyoruz.
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String
            {
                return content // Eğer başarılıysa, mesajı döndürür.
            }
        } catch {
            print("Failed to fetch message: \(error)") // İstek başarısız olursa hatayı yazdırır.
        }

        return nil // Eğer bir hata oluşursa veya veri çekilemezse nil döner.
    }
}

// Widget'teki her bir zaman dilimi girdisinin (entry) verilerini tanımlar.
struct SimpleEntry: TimelineEntry {
    let date: Date // Zaman bilgisi.
    let message: String // Gösterilecek mesaj.
}

// Widget arayüzü (SwiftUI kullanılarak oluşturulan görünüm).
struct UplivioWidgetEntryView: View {
    var entry: Provider.Entry // Zaman dilimi girdisinden gelen veri.

    var body: some View {
        ZStack {
            
            // randomTwoColors fonksiyonu iki farklı rengi seçiyor
            let colors = BackgroundColors.randomTwoColors()

            // Gradient arka plan
            LinearGradient(gradient: Gradient(colors: [
                Color(colors.color1), // İlk renk
                Color(UIColor.white.withAlphaComponent(0.8)),
                Color(colors.color2)
            ]), startPoint: .topTrailing, // Yukarıdan sağa doğru başlasın
                           endPoint: .bottomLeading)
            .ignoresSafeArea(edges: .all)  // Safe area'yı ihmal et


            VStack {
                
                Text(entry.message) // Mesaj
                    .font(.system(size: 18)) // Yazı boyutu 12
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color(UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)))
                
            }
        }
    }
}

// Widget'ın ana yapılandırması.
struct UplivioWidget: Widget {
    let kind: String = "UplivioWidget" // Widget kimliği.

    var body: some WidgetConfiguration {
        // AppIntentConfiguration kullanarak widget yapılandırmasını oluşturur.
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            UplivioWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget) // Widget arka planı tercihi.
        }
    }
}

// SwiftUI preview, widget'in nasıl görüneceğini önceden görmek için kullanılır.
#Preview(as: .systemSmall) {
    UplivioWidget()
} timeline: {
    SimpleEntry(date: .now, message: "Believe in yourself! Believe in yourself! Believe in yourself! Believe in yourself!")
}
