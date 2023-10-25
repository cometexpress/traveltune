# traveltune

### 소개
 - 국내 관광지에 대한 정보와 관광지 가이드를 들을 수 있는 앱
   
<br>

## 앱스토어
https://apps.apple.com/kr/app/%ED%8A%B8%EB%9E%98%EB%B8%94%ED%8A%A0-%EA%B5%AD%EB%82%B4-%EC%97%AC%ED%96%89-%EC%98%A4%EB%94%94%EC%98%A4-%EA%B0%80%EC%9D%B4%EB%93%9C/id6469851530

<br>

## 미리보기
![ezgif com-resize](https://github.com/J-comet/traveltune/assets/67407666/956e88e5-b76f-4a87-bdbc-325b920d8264)

<br>

## 개발환경
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.9-F05138?style=for-the-plastic&logo=swift&logoColor=white">
<img src ="https://img.shields.io/badge/Xcode-15.0-147EFB?style=for-the-plastic&logo=Xcode&logoColor=white">
<img src ="https://img.shields.io/badge/iOS-16.0-orange?style=for-the-plastic&logo=apple&logoColor=white">
</p>

<br>

## 개발 기간

2023.09.24 ~ 2023.10.22

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
|  (공통)하단 재생 UI - minimalSize  |  2  |  2  |  3 | <ul><li>[x] </li></ul> | 없음 |
|  (공통)하단 재생 기능 - minimalSize  |  2  |  8  |  6 | <ul><li>[x] </li></ul> | 없음 |
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

		

