![traveltune-korea-audio-guide_small](https://github.com/J-comet/traveltune/assets/67407666/931a54d9-c83f-43b3-95a2-55982c005512)
# 트래블튠 - 국내 여행 오디오 가이드
### [앱스토어 바로가기](https://apps.apple.com/kr/app/%ED%8A%B8%EB%9E%98%EB%B8%94%ED%8A%A0-%EA%B5%AD%EB%82%B4-%EC%97%AC%ED%96%89-%EC%98%A4%EB%94%94%EC%98%A4-%EA%B0%80%EC%9D%B4%EB%93%9C/id6469851530)

<br>

### 프로젝트
 - 인원 : 개인프로젝트 <br>
 - 기간 : 2023.09.24 ~ 2023.10.22 (4주) <br>
 - 최소지원버전 : iOS 16 <br>
 
<br>

### 한줄소개
 - 국내 관광지에 대한 정보를 알수 있고 관광지 가이드 오디오를 들을 수 있는 앱 입니다.
   
<br>

### 미리보기
![gitreadmeImgage](https://github.com/J-comet/bookwarm/assets/67407666/ac5491ba-e76a-4c52-9cdd-cd0f6ce949f7)

<br>

### 기술
| Category | Stack |
|:----:|:-----:|
| Architecture | `MVVM` |
| iOS | `UIKit` `AVFoundation` `WebKit` `MapKit` `UserDefaults` `CoreLocation`|
|  UI  | `SnapKit` |
| Reactive | `RxSwift` |
|  Network  | `Alamofire` `URLSession` `Codable` |
|  Database  | `Realm` |
|  Image  | `Kingfisher` |
|  Dependency Manager  | `CocoaPods` `SwiftPackageManager` |
|  Firebase  | `Crashlytics` `Analytics` |
|  Etc  | `Hero` `Parchment` `FSPagerView` `IQKeyboardManager` `FloatingPanel` `Charts` `Toast` |

<br>

### 기능
1. 관광지 오디오 가이드 재생 (백그라운드,잠금화면 오디오 재생)
2. 오디오 가이드 좋아요
3. 관광지 / 가이드 검색
4. 오디오 가이드 파일 공유
5. 위치 기반 관광지 오디오 검색
6. 관광지 방문객 통계

<br>

### 개발 고려사항
- AVPlayer, MPRemoteCommandCenter 클래스 더이상 사용되지 않을 때 메모리에서 해지 되도록 구현
- MPRemoteCommandCenter 클래스를 활용해 잠금화면과 다이나믹 아일랜드에서 재생/일시정지 기능 구현
- MPRemoteCommandCenter, AVPlayer 의 재생 상태 동기화
- MapKit CustomAnnotationView / CustomClustering 구현
- Kingfisher, 이미지 재가공후 Annotation 이미지로 사용
- Alamofire Router 패턴으로 Request 관리
- Alamofire RequestInterceptor 프로토콜을 활용해 동일한 인자값들 defaultParameters 로 관리
- URLScheme 지도앱 연동
- 재사용 가능한 CustomView 구현
- CollectionView - DiffableDataSource / CompositionalLayout 적용
- API 통신 중 UIWindow 하위의 화면 위 사용자의 상호작용 차단 하는 공통 LoadingIndicator 구현
- 다크모드, 다국어 대응

<br>


### 트러블슈팅
  ✏️ [트러블슈팅 일지](https://medium.com/@hyeseong7848/%EA%B8%B0%ED%9A%8D%EB%B6%80%ED%84%B0-%EC%B6%9C%EC%8B%9C%EA%B9%8C%EC%A7%80-6051a4143a05)

 ####  1. 잠금 화면에서 여러 오디오 파일을 재생 했을 때 중첩되서 재생 되는 오류
 -> 오디오를 재생시킬 때 MPRemoteCommandCenter 의 재생/일시정지 기능이 동작하도록 MPRemoteCommandCenter 를 등록하는 과정이 필요했습니다. <br>
   등록할 때 계속 addTarget 이 호출되어 이전에 등록된 action 이 해지되지 않아 중첩되고 있었습니다. 해당 메서드에 removeTarget 을 추가 후 해결했습니다. <br>

```swift
func registerRemoteCenterAction() {

	// 중첨 액션 방지용
        center.playCommand.removeTarget(self)
        center.pauseCommand.removeTarget(self)
        
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        
        let player = AVPlayerManager.shared.player
        
        center.playCommand.addTarget { event in
            AVPlayerManager.shared.replay()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds
            return .success
        }
        
        center.pauseCommand.addTarget { event in
            AVPlayerManager.shared.pause()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds
            return .success
        }
    }

```
     
<br>
 
 #### 2. 일일 API 콜 제한 수 문제
  -> Splash화면에서 최초 앱 실행하는 유저일 경우 관광지에 대한 정보를 Realm 에 캐싱 후 캐싱 데이터를 로드해서 사용 했습니다.<br>
  -> 다국어 대응이 필요해서 한국어, 영어 모두 요청이 완료된 후 캐싱 되도록 구현했습니다. (DispatchGroup 으로 모든 API 요청이 끝났을 때 저장하도록 구현)

```swift
// 한국어 데이터 요청
private func updateKoTravelSpots(group: DispatchGroup, errorHandler: @escaping () -> Void) {
        
        group.enter()
        let language = Network.LangCode.ko
        
        remoteTravelSpotRepository?.requestTravelSpots(page: koPage, language: language) { [weak self] response in
            guard let self else {
                errorHandler()
                group.leave()
                return
            }
            
            switch response {
            case .success(let success):
                let result = success.response
                if self.koPage == 1 {
                    self.koTotalCount = result.body.totalCount
                }
                
                self.koTravelSpots.append(contentsOf: result.body.items.item)
                
                let travelSpotsCnt = self.koTravelSpots.count
                if travelSpotsCnt < self.koTotalCount {
                    self.koPage += 1
                    self.updateKoTravelSpots(group: group) { errorHandler() }
                }
                
            case .failure(let failure):
                errorHandler()
            }
            group.leave()
        }
    }
```
  
<br>

#### 3. UIVibrancyEffect 안에 있는 버튼에 터치 액션이 전달 되지 않는 오류
-> View 구조는 VisualEffectView(BlurEffect) > View > VisualEffectView(VibrancyEffect) > View > UIButton 구조였습니다. <br>
   Button 위에 여러 개의 View 가 쌓이면서 Button 의 터치이벤트가 상위 뷰에게 터치 액션을 빼앗겼습니다.
-> 하위뷰로 터치 이벤트를 넘기기 위해 hitTest 를 활용해 해결했습니다.
  
```swift
extension UIVisualEffectView {

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self.contentView ? nil : view
    }
}
```

<br>

### 회고
✏️ [회고 일지](https://medium.com/@hyeseong7848/%ED%8A%B8%EB%9E%98%EB%B8%94%ED%8A%A0-%EC%B6%9C%EC%8B%9C-%ED%9A%8C%EA%B3%A0-eb66b6cc57aa)
- Swift 언어에 대한 이해도는 앱이 커질 수록 점점 중요해지는 부분이라고 느꼈습니다. <br>
  WMO, Struct, Reference Count, final 이런 키워드들에 대한 내용을 잘 이해하고 있어야 Swift 성능을 향상시킬 수 있기 때문에 앞으로도 꾸준히 학습이 필요하다고 느꼈습니다.
- 개발자는 생각의 폭을 넓게 가질 수 있어야 합니다. 이런 부분까지 신경써야되냐? 라고 한다면 어떤 사용자가 어떤 환경에서 사용할지 모르기 때문에 신경써야 한다고 생각합니다. <br>
  기능 개발을 빨리 할 수 있는 실력이 키워진다면 여러 상황에서 어떻게 동작이 되어질까? 에 대한 부분을 미리 알고 미리 대응할 수 있어야한다고 생각합니다. <br>
  출시 버전에서는 이러한 부분을 많이 챙기지 못했지만 이후 업데이트 버전은 다양한 상황들에 대해 좀더 고민해보고 그에 맞게 업데이트를 진행할 예정입니다.

<br>

### 이터레이션

|   이터레이션   	   |       기간 	     | 타입 |
|:----------------:|:----------------:|:----:|
|     이터레이션 0    |  09.24  | 프로젝트 세팅
|     이터레이션 1    |  09.25 ~ 09.27 | 개발
|     이터레이션 2    |  09.28 ~ 10.01 | 개발
|     이터레이션 3    |  10.02 ~ 10.04 | 개발
|     이터레이션 4    |  10.05 ~ 10.08 | 개발
|     이터레이션 5    |  10.09 ~ 10.11 | 개발
|     이터레이션 6    |  10.12 ~ 10.15 | 개발
|     이터레이션 7    |  10.16 ~ 10.18 | QA/출시준비
|     이터레이션 8    |  10.19 ~ 10.22 | QA/출시준비
|     이터레이션 9    |  10.23 ~ 10.25 | 심사 기간


<br>

- ### 개발 일정

| Task | 이터레이션 | 예상 (hour) | 구현 (hour) | 완료 | 비고 |
|:-----:|:-----:|:-----:|:------:|:----:|:----:|
|  프로젝트 세팅 | 0 | 6  |  12 | <ul><li>[x] </li></ul> | 다국어, 다크모드, 라이브러리, Base 등 세팅 |
|  홈 메인 UI  |  1  | 8  |  12 | <ul><li>[x] </li></ul> | Cocoapods 오류 처리로 지연 |
|  Splash UI & 기능 |  1  | 8  |  13 | <ul><li>[x] </li></ul> | 기획단계에서 생각만 했던 것을 개발하며 기획을 같이해서 지연 |
|  테마 상세 UI |  1  |  8  | 16 | <ul><li>[x] </li></ul> | hero 라이브러리 기능 개발 지연, UIVisualEffectView 안 객체 터치 안되는 이슈로 지연 HitTest 로 해결 |
|  테마 상세 기능 |  2  |  10  | 20 | <ul><li>[x] </li></ul> | 테마상세로 이동시 api 최초 한번만 호출 데이터 캐시 기능 구현으로 지연, 좋아요, 재생 관련기능이 생각보다 처리할게 많아 지연 |
|  테마 상세 지도모드 UI |  2  | 4 |  - h  | <ul><li>[ ] </li></ul> | 보류 |
|  (커스텀뷰)하단 재생 UI  |  2  |  2  |  3 | <ul><li>[x] </li></ul> | 없음 |
|  (커스텀뷰)하단 재생 기능  |  2  |  8  |  6 | <ul><li>[x] </li></ul> | 없음 |
|  검색 메인 UI  |  2  | 6 | 22 | <ul><li>[x] </li></ul> | DiffableDataSource, CompositionalLayout 학습 지연 |
|  검색 메인 기능  |  3  | 10 |  6  | <ul><li>[x] </li></ul> | 없음 |
|  검색 결과 UI  |  3  | 6 |  12  | <ul><li>[x] </li></ul> | tabMan -> parchment 라이브러리 변경 |
|  검색 결과 기능  |  3  | 8 |  12 | <ul><li>[x] </li></ul> | 부모ViewController 와 자식ViewController 간의 데이터 전달 지연 |
|  관광지 상세 UI  |  3  |  4  |  20  | <ul><li>[x] </li></ul> | 개인 일정으로 개발 진행 못함 |
|  관광지 상세 기능 UI  |  3  | 6 |  6 | <ul><li>[x] </li></ul> | 없음 |
|  이야기 상세 UI  |  4  |  4  |  6  | <ul><li>[x] </li></ul> | 없음 |
|  이야기 상세 기능  |  4  |  6  |  4 | <ul><li>[x] </li></ul> | 없음 |
|  지도 메인 UI  |  5  |  3  | 5 | <ul><li>[x] </li></ul> | FloatingPanel 라이브러리 학습 |
|  지도 메인 줌인 기능  |  5  |  2  | 2 | <ul><li>[x] </li></ul> | 없음 |
|  지도 관광지 상세 UI  |  5  |  8  |  8 | <ul><li>[x] </li></ul> | 없음 |
|  지도 관광지 상세 기능  |  5  |  8  |  6 | <ul><li>[x] </li></ul> | 없음 |
|  지도 상세 커스텀 마커 |  5  |  2  |  3 | <ul><li>[x] </li></ul> | 없음 |
|  지도 상세 클러스터링 |  6  |  5  |  3 | <ul><li>[x] </li></ul> | 없음 |
|  지도 상세 UI |  6  |  6  |  6 | <ul><li>[x] </li></ul> | 없음 |
|  지도 상세 마커, 클러스터링 터치 기능 |  6  |  10  |  8 | <ul><li>[x] </li></ul> | 없음 |
|  설정 메인 UI  |  7  |  8  | 5 | <ul><li>[x] </li></ul> | 없음 |
|  설정 메인 기능  |  7  |  16  | 12 | <ul><li>[x] </li></ul> | 없음 |
|  로컬 알림 기능  |  7  |  3  |  6 | <ul><li>[x] </li></ul> | 로컬 알림을 등록하는 부분보다 등록 후 알림설정 페이지에서 권한이 변경되었을 때 처리하는 로직에 시간이 많이 듬 |
|  잠금모드일 때 오디오 재생 기능  |  7  |  6  |  8 | <ul><li>[x] </li></ul> | MPRemoteCommandCenter 를 이용해 테스트 코드 작성 후 실제 적용시키는데 지연됨 |
	
<br>

