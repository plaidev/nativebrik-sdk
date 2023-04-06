/**
 * This file is generated by nativebrik/pkg/swift_code_gen. Do not edit this file.
 */
typealias ID = String
enum AlignItems: String, Decodable, Encodable {
  case START = "START"
  case CENTER = "CENTER"
  case END = "END"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try AlignItems(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum CollectionKind: String, Decodable, Encodable {
  case CAROUSEL = "CAROUSEL"
  case SCROLL = "SCROLL"
  case GRID = "GRID"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try CollectionKind(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct Color: Decodable {
  var __typename = "Color"
  var red: Float?
  var green: Float?
  var blue: Float?
  var alpha: Float?
  var code: SystemColorCode?
  var string: String?
}
struct Component: Decodable {
  var __typename = "Component"
  var id: ID?
  var viewId: ID?
  var view: UIBlockJSON?
}
enum FlexDirection: String, Decodable, Encodable {
  case ROW = "ROW"
  case COLUMN = "COLUMN"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try FlexDirection(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum FontWeight: String, Decodable, Encodable {
  case ULTRA_LIGHT = "ULTRA_LIGHT"
  case THIN = "THIN"
  case LIGHT = "LIGHT"
  case REGULAR = "REGULAR"
  case MEDIUM = "MEDIUM"
  case SEMI_BOLD = "SEMI_BOLD"
  case BOLD = "BOLD"
  case HEAVY = "HEAVY"
  case BLACK = "BLACK"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try FontWeight(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct FrameData: Decodable {
  var __typename = "FrameData"
  var width: Int?
  var height: Int?
  var paddingLeft: Int?
  var paddingRight: Int?
  var paddingTop: Int?
  var paddingBottom: Int?
  var borderRadius: Int?
  var borderWidth: Int?
  var borderColor: Color?
  var background: Color?
  var backgroundSrc: String?
}
enum JustifyContent: String, Decodable, Encodable {
  case START = "START"
  case CENTER = "CENTER"
  case END = "END"
  case SPACE_BETWEEN = "SPACE_BETWEEN"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try JustifyContent(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum Overflow: String, Decodable, Encodable {
  case VISIBLE = "VISIBLE"
  case HIDDEN = "HIDDEN"
  case SCROLL = "SCROLL"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try Overflow(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct PlaceholderInput: Encodable {
  var properties: [PropertyInput]?
}
struct Property: Decodable {
  var __typename = "Property"
  var name: String?
  var value: String?
  var ptype: PropertyType?
}
struct PropertyInput: Encodable {
  var name: String
  var value: String
  var ptype: PropertyType
}
enum PropertyType: String, Decodable, Encodable {
  case INTEGER = "INTEGER"
  case STRING = "STRING"
  case TIMESTAMPZ = "TIMESTAMPZ"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try PropertyType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct Query: Decodable {
  var __typename = "Query"
  var data: JSON?
  var component: Component?
}
enum SystemColorCode: String, Decodable, Encodable {
  case CLEAR = "CLEAR"
  case PRIMARY = "PRIMARY"
  case SECONDARY = "SECONDARY"
  case BLACK = "BLACK"
  case BLUE = "BLUE"
  case GRAY = "GRAY"
  case GREEN = "GREEN"
  case ORANGE = "ORANGE"
  case PINK = "PINK"
  case PURPLE = "PURPLE"
  case RED = "RED"
  case WHITE = "WHITE"
  case YELLOW = "YELLOW"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try SystemColorCode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
indirect enum UIBlock: Decodable {
  case EUIRootBlock(UIRootBlock)
  case EUIPageBlock(UIPageBlock)
  case EUIFlexContainerBlock(UIFlexContainerBlock)
  case EUITextBlock(UITextBlock)
  case EUIImageBlock(UIImageBlock)
  case EUICollectionBlock(UICollectionBlock)
  case EUICarouselBlock(UICarouselBlock)
  case unknown

  enum CodingKeys: String, CodingKey {
    case __typename
  }
  enum Typename: String, Decodable {
    case __UIRootBlock = "UIRootBlock"
    case __UIPageBlock = "UIPageBlock"
    case __UIFlexContainerBlock = "UIFlexContainerBlock"
    case __UITextBlock = "UITextBlock"
    case __UIImageBlock = "UIImageBlock"
    case __UICollectionBlock = "UICollectionBlock"
    case __UICarouselBlock = "UICarouselBlock"
    case unknown
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let typename = try container.decode(Typename.self, forKey: .__typename)
    let associateContainer = try decoder.singleValueContainer()
    switch typename {
    case .__UIRootBlock:
      let data = try associateContainer.decode(UIRootBlock.self)
      self = .EUIRootBlock(data)
    case .__UIPageBlock:
      let data = try associateContainer.decode(UIPageBlock.self)
      self = .EUIPageBlock(data)
    case .__UIFlexContainerBlock:
      let data = try associateContainer.decode(UIFlexContainerBlock.self)
      self = .EUIFlexContainerBlock(data)
    case .__UITextBlock:
      let data = try associateContainer.decode(UITextBlock.self)
      self = .EUITextBlock(data)
    case .__UIImageBlock:
      let data = try associateContainer.decode(UIImageBlock.self)
      self = .EUIImageBlock(data)
    case .__UICollectionBlock:
      let data = try associateContainer.decode(UICollectionBlock.self)
      self = .EUICollectionBlock(data)
    case .__UICarouselBlock:
      let data = try associateContainer.decode(UICarouselBlock.self)
      self = .EUICarouselBlock(data)
    default:
      self = .unknown
    }
  }
}
struct UIBlockEventDispatcher: Decodable {
  var __typename = "UIBlockEventDispatcher"
  var name: String?
  var destinationPageId: String?
  var payload: [Property]?
}
struct UICarouselBlock: Decodable {
  var __typename = "UICarouselBlock"
  var id: ID?
  var data: UICarouselBlockData?
}
struct UICarouselBlockData: Decodable {
  var __typename = "UICarouselBlockData"
  var children: [UIBlock]?
  var frame: FrameData?
  var gap: Int?
  var onClick: UIBlockEventDispatcher?
}
struct UICollectionBlock: Decodable {
  var __typename = "UICollectionBlock"
  var id: ID?
  var data: UICollectionBlockData?
}
struct UICollectionBlockData: Decodable {
  var __typename = "UICollectionBlockData"
  var children: [UIBlock]?
  var frame: FrameData?
  var gap: Int?
  var kind: CollectionKind?
  var direction: FlexDirection?
  var reference: String?
  var gridSize: Int?
  var itemWidth: Int?
  var itemHeight: Int?
  var onClick: UIBlockEventDispatcher?
}
struct UIFlexContainerBlock: Decodable {
  var __typename = "UIFlexContainerBlock"
  var id: ID?
  var data: UIFlexContainerBlockData?
  var root: UIFlexContainerRoot?
}
struct UIFlexContainerBlockData: Decodable {
  var __typename = "UIFlexContainerBlockData"
  var children: [UIBlock]?
  var direction: FlexDirection?
  var justifyContent: JustifyContent?
  var alignItems: AlignItems?
  var gap: Int?
  var frame: FrameData?
  var overflow: Overflow?
  var onClick: UIBlockEventDispatcher?
}
struct UIFlexContainerRoot: Decodable {
  var __typename = "UIFlexContainerRoot"
  var x: Int?
  var y: Int?
}
struct UIImageBlock: Decodable {
  var __typename = "UIImageBlock"
  var id: ID?
  var data: UIImageBlockData?
}
struct UIImageBlockData: Decodable {
  var __typename = "UIImageBlockData"
  var src: String?
  var frame: FrameData?
  var onClick: UIBlockEventDispatcher?
}
struct UIPageBlock: Decodable {
  var __typename = "UIPageBlock"
  var id: ID?
  var data: UIPageBlockData?
}
struct UIPageBlockData: Decodable {
  var __typename = "UIPageBlockData"
  var renderAs: UIBlock?
  var position: UIPageBlockPosition?
  var props: [Property]?
  var query: String?
}
struct UIPageBlockPosition: Decodable {
  var __typename = "UIPageBlockPosition"
  var x: Int?
  var y: Int?
}
struct UIRootBlock: Decodable {
  var __typename = "UIRootBlock"
  var id: ID?
  var data: UIRootBlockData?
}
struct UIRootBlockData: Decodable {
  var __typename = "UIRootBlockData"
  var pages: [UIPageBlock]?
  var currentPageId: ID?
}
struct UITextBlock: Decodable {
  var __typename = "UITextBlock"
  var id: ID?
  var data: UITextBlockData?
}
struct UITextBlockData: Decodable {
  var __typename = "UITextBlockData"
  var value: String?
  var size: Int?
  var color: Color?
  var weight: FontWeight?
  var frame: FrameData?
  var onClick: UIBlockEventDispatcher?
}
import Foundation
struct GraphqlError: Decodable {}
enum GraphqlQueryError: Error {
  case Network
}
func getComponent(query: getComponentQuery, apiKey: String, url: String) async throws -> getComponentQueryResult {
  let urlComponents = URLComponents(string: url)!
  let document = getComponentQuery.__document__
  struct BodyData: Encodable {
    var operationName = "getComponent"
    var query: String
    var variables: getComponentQuery
  }
  let body = BodyData(query: document, variables: query)
  let jsonData = try JSONEncoder().encode(body)
  var request = URLRequest(url: urlComponents.url!)
  request.httpBody = jsonData
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
  let (data, response) = try await URLSession.shared.data(for: request)
  guard let httpResponse = response as? HTTPURLResponse,
  httpResponse.statusCode == 200 else {
    throw GraphqlQueryError.Network
  }
  let decoder = JSONDecoder()
  let result = try decoder.decode(getComponentQueryResult.self, from: data)
  return result
}
struct getComponentQueryResult: Decodable {
  var data: ResultData?
  var errors: [GraphqlError]?
  struct ResultData: Decodable {
    var component: Component??
  }
}
struct getComponentQuery: Encodable {
  var id: ID?
  enum CodingKeys: String, CodingKey {
    case id
  }
  static let __document__ = """
query getComponent($id: ID!) {
  component(id: $id) {
    __typename
    id
    view
  }
}

query getData($query: String!, $placeholder: PlaceholderInput) {
  data(query: $query, placeholder: $placeholder)
}

"""}
func getData(query: getDataQuery, apiKey: String, url: String) async throws -> getDataQueryResult {
  let urlComponents = URLComponents(string: url)!
  let document = getDataQuery.__document__
  struct BodyData: Encodable {
    var operationName = "getData"
    var query: String
    var variables: getDataQuery
  }
  let body = BodyData(query: document, variables: query)
  let jsonData = try JSONEncoder().encode(body)
  var request = URLRequest(url: urlComponents.url!)
  request.httpBody = jsonData
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
  let (data, response) = try await URLSession.shared.data(for: request)
  guard let httpResponse = response as? HTTPURLResponse,
  httpResponse.statusCode == 200 else {
    throw GraphqlQueryError.Network
  }
  let decoder = JSONDecoder()
  let result = try decoder.decode(getDataQueryResult.self, from: data)
  return result
}
struct getDataQueryResult: Decodable {
  var data: ResultData?
  var errors: [GraphqlError]?
  struct ResultData: Decodable {
    var data: JSON??
  }
}
struct getDataQuery: Encodable {
  var query: String?
  var placeholder: PlaceholderInput?
  enum CodingKeys: String, CodingKey {
    case query
    case placeholder
  }
  static let __document__ = """
query getComponent($id: ID!) {
  component(id: $id) {
    __typename
    id
    view
  }
}

query getData($query: String!, $placeholder: PlaceholderInput) {
  data(query: $query, placeholder: $placeholder)
}

"""}
