//
//  repository.swift
//  Nativebrik
//
//  Created by Ryosuke Suzuki on 2023/06/30.
//

import Foundation

class CacheStrategy<V: NSObject> {
    private let cache = NSCache<NSString, Entry<V>>()

    fileprivate func get(key: String) -> Entry<V>? {
        return cache.object(forKey: key as NSString)
    }

    fileprivate func set(entry: Entry<V>, forKey: String) {
        cache.setObject(entry, forKey: forKey as NSString)
    }
}

enum EntryState {
    case COMPLETED
    case FAILED
}
class Entry<V: NSObject> {
    let state: EntryState
    let value: V?
    init(value: V) {
        self.state = .COMPLETED
        self.value = value
    }
    init() {
        self.state = .FAILED
        self.value = nil
    }
}

class Repositories {
    let image: ImageRepository
    let component: ComponentRepository
    let queryData: QueryDataRepository
    let experiment: ExperimentConfigsRepository
    let track: TrackRespository

    init(config: Config, user: NativebrikUser) {
        self.image = ImageRepository(
            cacheStrategy: CacheStrategy()
        )
        self.component = ComponentRepository(config: config, cacheStrategy: CacheStrategy())
        self.queryData = QueryDataRepository(cache: CacheStrategy(), config: config)
        self.experiment = ExperimentConfigsRepository(config: config, cacheStrategy: CacheStrategy())
        self.track = TrackRespository(config: config, user: user)
    }
}

class ImageData: NSObject {
    let data: Data
    let contentType: String
    init(data: Data, contentType: String) {
        self.data = data
        self.contentType = contentType
    }
}

class ImageRepository {
    private let cache: CacheStrategy<ImageData>

    init(cacheStrategy: CacheStrategy<ImageData>) {
        self.cache = cacheStrategy
    }

    func fetch(url: String, callback: @escaping (_ entry: Entry<ImageData>) -> Void) {
        if let dataFromCache = self.cache.get(key: url) {
            callback(dataFromCache)
            return
        }
        guard let requestUrl = URL(string: url) else {
            let entry = Entry<ImageData>()
            callback(entry)
            return
        }
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if error != nil {
                let entry = Entry<ImageData>()
                callback(entry)
                return
            }
            if let imageData = data {
                let entry = Entry(
                    value: ImageData(
                        data: imageData,
                        contentType: getContentType(response)
                    )
                )
                callback(entry)
                self.cache.set(entry: entry, forKey: url)
                return
            } else {
                let entry = Entry<ImageData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: url)
                return
            }
        }
        task.resume()
    }
}

func getContentType(_ response: URLResponse?) -> String {
    guard let response = response else {
        return ""
    }
    let contentType = (response as! HTTPURLResponse).allHeaderFields["Content-Type"] as? String
    guard let contentType = contentType else {
        return ""
    }
    return contentType
}

class ComponentData: NSObject {
    let view: UIBlockJSON
    let id: String
    init(view: UIBlockJSON, id: String) {
        self.view = view
        self.id = id
    }
}

class ComponentRepository {
    private let cache: CacheStrategy<ComponentData>
    private let config: Config

    init(config: Config, cacheStrategy: CacheStrategy<ComponentData>) {
        self.config = config
        self.cache = cacheStrategy
    }

    func fetch(experimentId: String, id: String, callback: @escaping (_ entry: Entry<ComponentData>) -> Void) {
        if id == "" {
            return
        }
        if let entry = self.cache.get(key: id) {
            callback(entry)
            return
        }
        let url = self.config.cdnUrl + "/projects/" + self.config.projectId + "/experiments/components/" + experimentId + "/" + id
        guard let requestUrl = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if error != nil {
                let entry = Entry<ComponentData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: id)
                return
            }

            if let viewData = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UIBlockJSON.self, from: viewData)
                    let entry = Entry<ComponentData>(
                        value: ComponentData(
                            view: result,
                            id: id
                        )
                    )
                    callback(entry)
                    self.cache.set(entry: entry, forKey: url)
                    return
                } catch {
                    let entry = Entry<ComponentData>()
                    callback(entry)
                    self.cache.set(entry: entry, forKey: id)
                    return
                }
            } else {
                let entry = Entry<ComponentData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: id)
                return
            }
        }
        task.resume()
    }
}

class ExperimentConfigsData: NSObject {
    let value: ExperimentConfigs
    init(value: ExperimentConfigs) {
        self.value = value
    }
}

class ExperimentConfigsRepository {
    private let cache: CacheStrategy<ExperimentConfigsData>
    private let config: Config

    init(config: Config, cacheStrategy: CacheStrategy<ExperimentConfigsData>) {
        self.config = config
        self.cache = cacheStrategy
    }

    func trigger(event: TriggerEvent, callback: @escaping (_ entry: Entry<ExperimentConfigsData>) -> Void) async {
        let url = self.config.cdnUrl + "/projects/" + self.config.projectId + "/experiments/trigger/" + event.name
        await self._fetch(key: event.name, url: url, callback: callback)
    }

    func fetch(id: String, callback: @escaping (_ entry: Entry<ExperimentConfigsData>) -> Void) async {
        let url = self.config.cdnUrl + "/projects/" + self.config.projectId + "/experiments/id/" + id
        await _fetch(key: id, url: url, callback: callback)
    }

    private func _fetch(key: String, url: String, callback: @escaping (_ entry: Entry<ExperimentConfigsData>) -> Void) async {
        if let entry = self.cache.get(key: key) {
            callback(entry)
            return
        }

        guard let requestUrl = URL(string: url) else {
            return
        }

        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if error != nil {
                let entry = Entry<ExperimentConfigsData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: key)
                return
            }

            if let experimentRawData = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ExperimentConfigs.self, from: experimentRawData)
                    let entry = Entry<ExperimentConfigsData>(
                        value: ExperimentConfigsData(
                            value: result
                        )
                    )
                    callback(entry)
                    self.cache.set(entry: entry, forKey: key)
                    return
                } catch {
                    let entry = Entry<ExperimentConfigsData>()
                    callback(entry)
                    self.cache.set(entry: entry, forKey: key)
                    return
                }
            } else {
                let entry = Entry<ExperimentConfigsData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: key)
                return
            }
        }
        task.resume()
    }
}

struct TrackRequest: Encodable {
    var projectId: String
    var userId: String
    var timestamp: DateTime
    var events: [TrackEvent]
}

struct TrackEvent: Encodable {
    enum Typename: String, Encodable {
        case Event = "event"
        case Experiment = "experiment"
    }
    var typename: Typename
    var experimentId: String?
    var variantId: String?
    var name: String?
    var timestamp: DateTime
}

struct TrackUserEvent {
    var name: String
}

struct TrackExperimentEvent {
    var experimentId: String
    var variantId: String
}

class TrackRespository {
    private let maxQueueSize: Int
    private let maxBatchSize: Int
    private let config: Config
    private let user: NativebrikUser
    private let queueLock: NSLock
    private var timer: Timer?
    private var buffer: [TrackEvent]
    init(config: Config, user: NativebrikUser) {
        self.maxQueueSize = 300
        self.maxBatchSize = 50
        self.config = config
        self.user = user
        self.queueLock = NSLock()
        self.buffer = []
        self.timer = nil
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    func trackExperimentEvent(_ event: TrackExperimentEvent) {
        self.pushToQueue(TrackEvent(
            typename: .Experiment,
            experimentId: event.experimentId,
            variantId: event.variantId,
            timestamp: Date.now.ISO8601Format()
        ))
    }
    
    func trackEvent(_ event: TrackUserEvent) {
        self.pushToQueue(TrackEvent(
            typename: .Event,
            name: event.name,
            timestamp: Date.now.ISO8601Format()
        ))
    }
    
    private func pushToQueue(_ event: TrackEvent) {
        self.queueLock.lock()
        if self.timer == nil {
            // here, use async not sync. main.sync will break the app.
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { _ in
                    Task(priority: .low) {
                        try await self.sendAndFlush()
                    }
                })
            }
        }

        if self.buffer.count >= self.maxBatchSize {
            Task(priority: .low) {
                try await self.sendAndFlush()
            }
        }
        self.buffer.append(event)
        if self.buffer.count >= self.maxQueueSize {
            self.buffer.removeFirst(self.maxQueueSize - self.buffer.count)
        }
        
        self.queueLock.unlock()
    }
    
    private func sendAndFlush() async throws {
        if self.buffer.count == 0 {
            return
        }
        let events = self.buffer
        self.buffer = []
        let trackRequest = TrackRequest(
            projectId: self.config.projectId,
            userId: self.user.id,
            timestamp: Date.now.ISO8601Format(),
            events: events
        )
        
        do {
            let url = URL(string: config.trackUrl)!
            let jsonData = try JSONEncoder().encode(trackRequest)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let _ = try await URLSession.shared.data(for: request)
            
            self.timer?.invalidate()
            self.timer = nil
        } catch {
            self.buffer.append(contentsOf: events)
        }
    }
}

class JSONData: NSObject {
    let data: JSON?
    init(data: JSON?) {
        self.data = data
    }
}
class QueryDataRepository {
    private let cache: CacheStrategy<JSONData>
    private let config: Config

    init(cache: CacheStrategy<JSONData>, config: Config) {
        self.cache = cache
        self.config = config
    }

    func fetch(query: String, placeholder: PlaceholderInput, callback: @escaping (_ entry: Entry<JSONData>) -> Void) async {
        let key = query + ":" + placeholderInputToString(input: placeholder)

        if let entry = self.cache.get(key: key) {
            callback(entry)
            return
        }

        do {
            let data = try await getData(
                query: getDataQuery(query: query, placeholder: placeholder),
                projectId: self.config.projectId,
                url: self.config.url
            )
            if let data = data.data?.data {
                let entry = Entry<JSONData>(
                    value: JSONData(data: data)
                )
                callback(entry)
                self.cache.set(entry: entry, forKey: key)
                return
            } else {
                let entry = Entry<JSONData>()
                callback(entry)
                self.cache.set(entry: entry, forKey: key)
                return
            }
        } catch {
            let entry = Entry<JSONData>()
            callback(entry)
            self.cache.set(entry: entry, forKey: key)
        }
    }
}

func placeholderInputToString(input: PlaceholderInput) -> String {
    guard let properties = input.properties else {
        return ""
    }
    var query = ""
    properties.forEach({ property in
        query += property.name + property.value
    })
    return query
}

