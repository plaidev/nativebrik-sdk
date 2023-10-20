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
struct ApiHttpHeader: Decodable {
  var name: String?
  var value: String?
}
struct ApiHttpRequest: Decodable {
  var url: String?
  var method: ApiHttpRequestMethod?
  var hearders: [ApiHttpHeader]?
  var body: String?
}
enum ApiHttpRequestMethod: String, Decodable, Encodable {
  case GET = "GET"
  case POST = "POST"
  case PUT = "PUT"
  case DELETE = "DELETE"
  case PATCH = "PATCH"
  case HEAD = "HEAD"
  case TRACE = "TRACE"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ApiHttpRequestMethod(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct ApiHttpResponseAssertion: Decodable {
  var statusCodes: [Int]?
}
struct BoxShadow: Decodable {
  var color: Color?
  var offsetX: Int?
  var offsetY: Int?
  var radius: Int?
}
enum BuiltinUserProperty: String, Decodable, Encodable {
  case userId = "userId"
  case userRnd = "userRnd"
  case languageCode = "languageCode"
  case regionCode = "regionCode"
  case currentTime = "currentTime"
  case firstBootTime = "firstBootTime"
  case lastBootTime = "lastBootTime"
  case retentionPeriod = "retentionPeriod"
  case bootingTime = "bootingTime"
  case sdkVersion = "sdkVersion"
  case osVersion = "osVersion"
  case osName = "osName"
  case appVersion = "appVersion"
  case cfBundleVersion = "cfBundleVersion"
  case localYear = "localYear"
  case localMonth = "localMonth"
  case localWeekday = "localWeekday"
  case localDay = "localDay"
  case localHour = "localHour"
  case localMinute = "localMinute"
  case localSecond = "localSecond"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try BuiltinUserProperty(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
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
  var red: Float?
  var green: Float?
  var blue: Float?
  var alpha: Float?
}
enum ConditionOperator: String, Decodable, Encodable {
  case Equal = "Equal"
  case NotEqual = "NotEqual"
  case GreaterThan = "GreaterThan"
  case GreaterThanOrEqual = "GreaterThanOrEqual"
  case LessThan = "LessThan"
  case LessThanOrEqual = "LessThanOrEqual"
  case In = "In"
  case NotIn = "NotIn"
  case Between = "Between"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ConditionOperator(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct ExperimentCondition: Decodable {
  var property: String?
  var `operator`: String?
  var value: String?
}
struct ExperimentConfig: Decodable {
  var id: ID?
  var kind: ExperimentKind?
  var distribution: [ExperimentCondition]?
  var baseline: ExperimentVariant?
  var variants: [ExperimentVariant]?
  var seed: Int?
  var frequency: ExperimentFrequency?
  var startedAt: DateTime?
  var endedAt: DateTime?
}
struct ExperimentConfigs: Decodable {
  var configs: [ExperimentConfig]?
}
struct ExperimentFrequency: Decodable {
  var times: Int?
  var period: Int?
  var unit: FrequencyUnit?
}
enum ExperimentKind: String, Decodable, Encodable {
  case EMBED = "EMBED"
  case POPUP = "POPUP"
  case CONFIG = "CONFIG"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ExperimentKind(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct ExperimentVariant: Decodable {
  var id: ID?
  var configs: [VariantConfig]?
  var weight: Int?
}
enum FlexDirection: String, Decodable, Encodable {
  case ROW = "ROW"
  case COLUMN = "COLUMN"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try FlexDirection(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum FontDesign: String, Decodable, Encodable {
  case DEFAULT = "DEFAULT"
  case MONOSPACE = "MONOSPACE"
  case ROUNDED = "ROUNDED"
  case SERIF = "SERIF"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try FontDesign(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
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
  var shadow: BoxShadow?
}
enum FrequencyUnit: String, Decodable, Encodable {
  case DAY = "DAY"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try FrequencyUnit(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum ImageContentMode: String, Decodable, Encodable {
  case FIT = "FIT"
  case FILL = "FILL"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ImageContentMode(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
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
enum ModalPresentationStyle: String, Decodable, Encodable {
  case DEPENDS_ON_CONTEXT_OR_FULL_SCREEN = "DEPENDS_ON_CONTEXT_OR_FULL_SCREEN"
  case DEPENDS_ON_CONTEXT_OR_PAGE_SHEET = "DEPENDS_ON_CONTEXT_OR_PAGE_SHEET"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ModalPresentationStyle(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum ModalScreenSize: String, Decodable, Encodable {
  case MEDIUM = "MEDIUM"
  case LARGE = "LARGE"
  case MEDIUM_AND_LARGE = "MEDIUM_AND_LARGE"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try ModalScreenSize(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct NavigationBackButton: Decodable {
  var title: String?
  var color: Color?
  var visible: Boolean?
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
enum PageKind: String, Decodable, Encodable {
  case COMPONENT = "COMPONENT"
  case MODAL = "MODAL"
  case WEBVIEW_MODAL = "WEBVIEW_MODAL"
  case TRIGGER = "TRIGGER"
  case LOAD_BALANCER = "LOAD_BALANCER"
  case DISMISSED = "DISMISSED"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try PageKind(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct PlaceholderInput: Encodable {
  var properties: [PropertyInput]?
}
struct Property: Decodable {
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
  var data: JSON?
}
struct TriggerEventDef: Decodable {
  var name: String?
}
struct TriggerEventInput: Encodable {
  var name: String
  var properties: [PropertyInput]?
}
enum TriggerEventNameDefs: String, Decodable, Encodable {
  case RETENTION_1 = "RETENTION_1"
  case RETENTION_2_3 = "RETENTION_2_3"
  case RETENTION_4_7 = "RETENTION_4_7"
  case RETENTION_8_14 = "RETENTION_8_14"
  case RETENTION_15 = "RETENTION_15"
  case USER_BOOT_APP = "USER_BOOT_APP"
  case USER_ENTER_TO_APP = "USER_ENTER_TO_APP"
  case USER_ENTER_TO_APP_FIRSTLY = "USER_ENTER_TO_APP_FIRSTLY"
  case USER_ENTER_TO_FOREGROUND = "USER_ENTER_TO_FOREGROUND"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try TriggerEventNameDefs(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
struct TriggerSetting: Decodable {
  var onTrigger: UIBlockEventDispatcher?
  var trigger: TriggerEventDef?
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
  var name: String?
  var destinationPageId: String?
  var deepLink: String?
  var payload: [Property]?
  var httpRequest: ApiHttpRequest?
  var httpResponseAssertion: ApiHttpResponseAssertion?
}
struct UICarouselBlock: Decodable {
  var id: ID?
  var data: UICarouselBlockData?
}
struct UICarouselBlockData: Decodable {
  var children: [UIBlock]?
  var frame: FrameData?
  var gap: Int?
  var onClick: UIBlockEventDispatcher?
}
struct UICollectionBlock: Decodable {
  var id: ID?
  var data: UICollectionBlockData?
}
struct UICollectionBlockData: Decodable {
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
  var id: ID?
  var data: UIFlexContainerBlockData?
}
struct UIFlexContainerBlockData: Decodable {
  var children: [UIBlock]?
  var direction: FlexDirection?
  var justifyContent: JustifyContent?
  var alignItems: AlignItems?
  var gap: Int?
  var frame: FrameData?
  var overflow: Overflow?
  var onClick: UIBlockEventDispatcher?
}
struct UIImageBlock: Decodable {
  var id: ID?
  var data: UIImageBlockData?
}
struct UIImageBlockData: Decodable {
  var src: String?
  var contentMode: ImageContentMode?
  var frame: FrameData?
  var onClick: UIBlockEventDispatcher?
}
struct UIPageBlock: Decodable {
  var id: ID?
  var data: UIPageBlockData?
}
struct UIPageBlockData: Decodable {
  var kind: PageKind?
  var modalPresentationStyle: ModalPresentationStyle?
  var modalScreenSize: ModalScreenSize?
  var modalNavigationBackButton: NavigationBackButton?
  var webviewUrl: String?
  var triggerSetting: TriggerSetting?
  var renderAs: UIBlock?
  var position: UIPageBlockPosition?
  var httpRequest: ApiHttpRequest?
  var props: [Property]?
  var query: String?
}
struct UIPageBlockPosition: Decodable {
  var x: Int?
  var y: Int?
}
struct UIRootBlock: Decodable {
  var id: ID?
  var data: UIRootBlockData?
}
struct UIRootBlockData: Decodable {
  var pages: [UIPageBlock]?
  var currentPageId: ID?
}
struct UITextBlock: Decodable {
  var id: ID?
  var data: UITextBlockData?
}
struct UITextBlockData: Decodable {
  var value: String?
  var size: Int?
  var color: Color?
  var design: FontDesign?
  var weight: FontWeight?
  var frame: FrameData?
  var onClick: UIBlockEventDispatcher?
}
struct VariantConfig: Decodable {
  var key: String?
  var kind: VariantConfigKind?
  var value: String?
}
enum VariantConfigKind: String, Decodable, Encodable {
  case COMPONENT = "COMPONENT"
  case STRING = "STRING"
  case NUMBER = "NUMBER"
  case BOOLEAN = "BOOLEAN"
  case JSON = "JSON"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try VariantConfigKind(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
enum Weekdays: String, Decodable, Encodable {
  case SUNDAY = "SUNDAY"
  case MONDAY = "MONDAY"
  case TUESDAY = "TUESDAY"
  case WEDNESDAY = "WEDNESDAY"
  case THURSDAY = "THURSDAY"
  case FRIDAY = "FRIDAY"
  case SATURDAY = "SATURDAY"
  case unknown = "unknown"
  init(from decoder: Decoder) throws {
    self = try Weekdays(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}
import Foundation
struct GraphqlError: Decodable {}
enum GraphqlQueryError: Error {
  case Network
}
func getData(query: getDataQuery, projectId: String, url: String) async throws -> getDataQueryResult {
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
  request.setValue(projectId, forHTTPHeaderField: "X-Project-Id")
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
query getData ($query: String!, $placeholder: PlaceholderInput) {
  data(query: $query, placeholder: $placeholder)
}
"""}
