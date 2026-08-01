# TatsuFlix-MVI Agent

Use this agent when working on the TatsuFlix-MVI iOS project. The goal is to preserve the existing SwiftUI + MVI + The Composable Architecture style while making focused, buildable changes.

## Project Snapshot

TatsuFlix-MVI is a SwiftUI iOS app that consumes the TVMaze API. It uses The Composable Architecture for feature state management, Swift concurrency for networking, SwiftData for local persistence work, and the Swift Testing framework for new unit tests.

The main app target is `TatsuFlix-MVI`.

Important directories:

- `TatsuFlix-MVI/Scenes`: feature screens split by domain.
- `TatsuFlix-MVI/Components`: reusable SwiftUI views and design tokens.
- `TatsuFlix-MVI/Networking/API`: generic request/client infrastructure.
- `TatsuFlix-MVI/Networking/Models`: request and response models.
- `TatsuFlix-MVI/LocalData/Models`: SwiftData local persistence models.
- `TatsuFlix-MVITests`: unit tests. New tests should use `import Testing`.

## Architecture Pattern

Features follow an MVI/TCA shape:

- `FeatureState.swift`: defines `@ObservableState`, phase enums, actions, and navigation path/destination types.
- `FeatureStore.swift`: defines `@Reducer`, aliases `State` and `Action`, handles actions in `Reduce`, mutates state, and returns effects.
- `FeatureView.swift`: renders from store state and sends actions from user interaction.
- Optional `FeatureNavigationStack.swift`: tab-level navigation shell.

Existing examples:

- Home: `HomeState`, `HomeStore`, `HomeView`
- Search: `SearchState`, `SearchStore`, `SearchView`
- Show Details: `ShowDetailsState`, `ShowDetailsStore`, `ShowDetailsView`
- Episodes: `EpisodesState`, `EpisodesStore`, `EpisodesView`

Use `@Bindable var store: StoreOf<FeatureStore>` in SwiftUI views that need bindings or send actions.

Feature phases are modeled as small enums such as:

```swift
enum SearchPhase: Equatable {
  case ready
  case loading
  case failed
  case searchResultEmpty
  case showingSearchResult
}
```

Reducers should update phase state before returning effects, then send success/failure actions from async work.

## Navigation Pattern

Home and Search use TCA stack navigation into Show Details:

```swift
@Reducer
enum Path {
  case showDetails(ShowDetailsStore)
}

@ObservableState
struct FeatureState {
  var path = StackState<Path.State>()
}

@CasePathable
enum FeatureActions {
  case showDetails(for: ShowResponse)
  case path(StackAction<Path.State, Path.Action>)
}
```

In the reducer:

```swift
case let .showDetails(show):
  state.path.append(.showDetails(.init(phase: .ready, show: show)))
  return .none
case .path:
  return .none
```

Then compose child reducers:

```swift
.forEach(\.path, action: \.path)
```

In the view:

```swift
NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
  content
} destination: { store in
  switch store.case {
  case let .showDetails(store):
    ShowDetailsView(store: store)
  }
}
```

Show Details presents Episodes with `@Presents var destination` and `.ifLet(\.$destination, action: \.destination)`.

## Networking Layer

All network requests conform to:

```swift
protocol APIRequest {
  associatedtype Response: Codable
  var endpoint: Endpoint { get }
}
```

`APIRequest.url` builds a URL from:

- scheme: `https`
- host: `BaseURL.getBaseURL()`
- path: `endpoint.path`
- query items: `endpoint.queryItem`

`NetworkClientProtocol` exposes:

```swift
func send<T: APIRequest>(_ request: T) async throws -> T.Response
```

`NetworkClient`:

1. Validates `request.url`.
2. Builds a `URLRequest`.
3. Sets `httpMethod` from `request.endpoint.method.rawValue`.
4. Uses `URLSession.shared.data(for:)`.
5. Validates `HTTPURLResponse` and `200..<300`.
6. Decodes `T.Response` with `JSONDecoder`.
7. Maps failures to `ApiError`.

Existing requests:

- `GetShowsRequest(page:) -> [ShowResponse]`
- `SearchShowsRequest(query:) -> [SearchSeriesResponse]`
- `EpisodesRequest(showId:) -> [EpisodeResponse]`

## How to Add a New API Request

When adding a new TVMaze request, update the network layer in this order:

1. Add a new `Endpoint` case.

```swift
case peopleSearch(query: String)
```

2. Add its path in `Endpoint.path`.

```swift
case .peopleSearch:
  "/search/people"
```

3. Add its method in `Endpoint.method`.

```swift
case .peopleSearch:
  .get
```

4. Add query items in `Endpoint.queryItem` if needed.

```swift
case let .peopleSearch(query):
  ["q": query]
```

5. Create a request model in `Networking/Models`.

```swift
struct SearchPeopleRequest: APIRequest {
  typealias Response = [SearchPeopleResponse]
  let query: String

  var endpoint: Endpoint {
    .peopleSearch(query: query)
  }
}
```

6. Add response models near the request if they are request-specific, or in a shared response file if reused.

7. Inject/use the request through a reducer service:

```swift
let result = try await service.send(SearchPeopleRequest(query: query))
```

8. Add reducer actions for loading, success, and failure.

9. Add focused tests for request URL construction, response mapping, or reducer behavior when practical.

## SwiftData Local Models

Local persistence currently lives in `LocalData/Models/LocalShowsModel.swift`.

`LocalShowsModel` is a SwiftData `@Model` with a unique TVMaze show `id`. It maps from `ShowResponse` and can convert back with `convertToShowResponse()`.

Nested response data is stored using embedded `Codable, Equatable` structs:

- `LocalShowImage`
- `LocalShowSchedule`
- `LocalShowRating`

Prefer this embedded struct pattern for simple nested value objects that do not need independent querying or lifecycle management. Use separate `@Model` relationship objects only when the nested data needs to be fetched, updated, or deleted independently.

## UI Conventions

Use existing components before adding new ones:

- `AsyncImageView`
- `LoadingView`
- `SearchStateView`
- `ShowCardView`
- `TextComponents`
- `Tokens`

Spacing should come from `Tokens.Spacing`.

For show grids, follow the existing two-column `LazyVGrid` pattern with `ShowCardView`.

For empty/error search-style states, use `SearchStateView`.

## Testing Conventions

New unit tests should use Swift Testing:

```swift
import Testing
@testable import TatsuFlix_MVI

struct SomeFeatureTests {
  @Test func testFunctionBeingTested() {
    #expect(...)
  }
}
```

Existing local model tests are in:

`TatsuFlix-MVITests/LocalData/Models/LocalShowsModelTests.swift`

Test function names must always start with `test`, followed by the function or behavior being tested in camelCase. Examples:

- `testInitFromShowResponse`
- `testConvertToShowResponse`
- `testNilImageSummaryAndRating`

Keep tests focused on:

- model mapping
- request URL/query construction
- reducer state transitions
- nil/empty/error cases

Do not add broad UI automation unless the task specifically asks for UI tests.

## Validation

Use Xcode tools when available:

1. `XcodeRefreshCodeIssuesInFile` for fast diagnostics on touched Swift files.
2. `BuildProject` for final compile validation.
3. `GetTestList` and `RunSomeTests` for targeted unit tests.

Known project note: test execution may be blocked by signing settings for the test targets. If this happens, report the signing blocker and include the exact target names from the build log.

## Change Discipline

- Keep changes scoped to the requested feature.
- Preserve SwiftUI + TCA patterns already in the codebase.
- Avoid Combine for new code; use async/await.
- Prefer `let` constants and `@State private var` for SwiftUI state.
- Avoid force unwraps.
- Use 4-space indentation in Swift files.
- Add comments only for non-obvious logic.
- Do not refactor unrelated files while implementing a narrow request.
