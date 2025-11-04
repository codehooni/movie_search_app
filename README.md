# Movie Demo

Flutter를 사용하여 TMDB(The Movie Database) API로 영화 정보를 가져와 표시하는 데모 앱입니다.

## 📱 스크린샷

<div style="overflow-x: auto; white-space: nowrap;">
  <table>
    <tr>
      <td align="center"><b>인기 영화 목록</b></td>
      <td align="center"><b>검색 기능</b></td>
      <td align="center"><b>영화 상세 페이지</b></td>
      <td align="center"><b>즐겨찾기</b></td>
    </tr>
    <tr>
      <td><img width="250" alt="home_screen" src="https://github.com/user-attachments/assets/a4a8003f-3eba-44c7-8ad1-9833254b09fb" /></td>
      <td><img width="250" alt="search_screen" src="https://github.com/user-attachments/assets/8d47b99e-3929-4ba7-87b3-78f5b36d751d" /></td>
      <td><img width="250" alt="detail_screen" src="https://github.com/user-attachments/assets/404d64a6-d120-4bad-9ce6-3c5d330b560e" /></td>
      <td><img width="250" alt="favorites_screen" src="https://github.com/user-attachments/assets/f325f331-3c96-4bb9-a3c8-4514d6cc6490" /></td>
    </tr>
  </table>
</div>

## 주요 기능

### 🏠 홈 화면
- **인기 영화 목록**: TMDB API를 통해 현재 인기 있는 영화 목록 표시
- **실시간 검색**: Debounce를 적용한 영화 검색 기능 (500ms 지연)
- **검색 모드 전환**: 인기 영화 ↔ 검색 결과 자동 전환
- **Pull-to-Refresh**: 아래로 당겨서 영화 목록 새로고침
- **에러 처리**: 네트워크 오류 감지 및 재시도 버튼 제공

### 📄 상세 화면
- **영화 상세 정보**: 제목, 개봉년도, 평점, 장르, 줄거리 표시
- **즐겨찾기 기능**: 영화를 즐겨찾기에 추가/제거 (SharedPreferences 사용)
- **Hero 애니메이션**: 화면 전환 시 부드러운 이미지 애니메이션
- **실시간 상태 반영**: 즐겨찾기 추가/제거 즉시 UI 업데이트

### ⭐ 즐겨찾기 화면
- **로컬 저장소**: SharedPreferences를 통한 영구 데이터 저장
- **장르 필터링**: 12개 장르별 영화 필터링 기능
- **그리드 레이아웃**: 2열 그리드로 영화 포스터 표시
- **자동 새로고침**: 상세 화면에서 돌아오면 목록 자동 업데이트

### 🧭 내비게이션
- **Bottom Navigation Bar**: Home과 Favorites 화면 간 빠른 전환

## 기술 스택

- **Flutter**: ^3.9.2
- **Dio**: HTTP 통신 라이브러리
- **TMDB API**: 영화 정보 제공
- **json_serializable**: JSON 직렬화/역직렬화
- **flutter_dotenv**: 환경 변수 관리
- **font_awesome_flutter**: FontAwesome 아이콘
- **shared_preferences**: 로컬 데이터 저장

## 프로젝트 구조

```
lib/
├── main.dart                       # 앱 진입점
├── models/
│   ├── movie.dart                 # Movie 모델 (장르 매핑 포함)
│   └── movie.g.dart               # 자동 생성된 JSON 직렬화 코드
├── screens/
│   ├── main_screen.dart           # 메인 화면 (Bottom Navigation)
│   ├── home_screen.dart           # 홈 화면 (검색 + 인기 영화)
│   ├── favorites_screen.dart      # 즐겨찾기 화면 (장르 필터링)
│   └── detail_screen.dart         # 상세 화면 (영화 상세 정보)
├── widgets/
│   ├── my_movie_card.dart         # 작은 영화 카드 위젯
│   └── my_big_movie_card.dart     # 큰 영화 카드 위젯
├── services/
│   ├── api_service.dart           # API 호출 서비스 (인기/검색)
│   └── favorites_service.dart     # 즐겨찾기 저장 서비스
├── utils/
│   └── debouncer.dart             # 검색 디바운서
└── theme/
    └── dark_mode.dart             # 다크모드 테마
```

## 설치 및 실행

### 1. API 키 설정

1. [TMDB 웹사이트](https://www.themoviedb.org/)에서 계정 생성
2. API 키 발급
3. 프로젝트 루트 디렉토리에 `.env` 파일 생성
4. 다음 내용 추가:

```env
TMDB_API_KEY=your_api_key_here
```

### 2. 의존성 설치

```bash
flutter pub get
```

### 3. JSON 직렬화 코드 생성

```bash
flutter pub run build_runner build
```

### 4. 앱 실행

```bash
flutter run
```

## 사용된 패키지

### Dependencies
- `cupertino_icons` (^1.0.8): iOS 스타일 아이콘
- `flutter_dotenv` (^6.0.0): 환경 변수 관리 (.env 파일)
- `dio` (^5.9.0): HTTP 클라이언트 (REST API 호출)
- `json_annotation` (^4.9.0): JSON 직렬화 어노테이션
- `font_awesome_flutter` (^10.7.0): FontAwesome 아이콘
- `shared_preferences` (^2.5.3): 로컬 데이터 영구 저장

### Dev Dependencies
- `flutter_lints` (^5.0.0): 코드 품질 검사
- `json_serializable` (^6.11.1): JSON 직렬화 코드 자동 생성
- `build_runner` (^2.10.1): 코드 생성 도구

## 주요 학습 포인트

### 1. 검색 기능 + Debouncing
검색 입력마다 API 호출을 방지하기 위해 Debouncer 구현
```dart
class Debouncer {
  final Duration delay;
  Timer? _timer;

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }
}
```

### 2. Enum을 활용한 상태 관리
검색 모드를 enum으로 관리하여 명확한 상태 구분
```dart
enum SearchMode { popular, searching }
```

### 3. SharedPreferences로 로컬 저장
즐겨찾기 데이터를 JSON으로 변환하여 영구 저장
```dart
static Future<void> addFavorite(Movie movie) async {
  final prefs = await SharedPreferences.getInstance();
  List<Movie> favorites = await getFavorites();
  favorites.add(movie);

  final jsonList = favorites.map((m) => jsonEncode(m.toJson())).toList();
  await prefs.setStringList(_favoritesKey, jsonList);
}
```

### 4. FutureBuilder 패턴
API 호출 결과를 상태별로 처리 (waiting, error, data)
```dart
FutureBuilder<List<Movie>>(
  future: moviesFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return ErrorWidget();
    }
    return ListView(...);
  },
)
```

### 5. Hero 애니메이션
화면 전환 시 부드러운 공유 요소 애니메이션
```dart
Hero(
  tag: 'hero-movie-${movie.id}',
  child: Image.network(...),
)
```

### 6. 장르 필터링
Movie 모델에 장르 ID→이름 매핑 로직 구현
```dart
List<String> get genreNames {
  const genreMap = {28: '액션', 35: '코미디', ...};
  return genreIds.map((id) => genreMap[id] ?? '알수없음').toList();
}
```

### 7. 에러 처리
네트워크 에러 타입별 사용자 친화적 메시지 표시
```dart
String _getErrorMessage(Object? error) {
  if (error.toString().contains('SocketException')) {
    return '인터넷 연결을 확인해주세요.';
  }
  // ... 다른 에러 타입 처리
}
```

## API 엔드포인트

### 인기 영화 목록
```
GET /movie/popular
Parameters:
  - api_key: TMDB API 키
  - language: ko-KR
```

### 영화 검색
```
GET /search/movie
Parameters:
  - query: 검색어
  - api_key: TMDB API 키
  - language: ko-KR
```

## 구현 완료된 기능

- [x] 검색 기능 구현 (debounce 적용)
- [x] enum을 사용한 상태 관리 (SearchMode)
- [x] Pull-to-refresh 기능
- [x] 에러 처리 개선 (네트워크 오류별 메시지)
- [x] 영화 장르별 필터링
- [x] 즐겨찾기 기능 (로컬 저장)
- [x] Bottom Navigation

## 개선 예정 사항

- [ ] 영화 평점 표시 개선 (별점 UI)
- [ ] 즐겨찾기 화면 정렬 옵션 (최신순, 평점순)
- [ ] 영화 트레일러 재생 기능
- [ ] 스플래시 스크린 추가
- [ ] 다크모드/라이트모드 토글
- [ ] 무한 스크롤 페이지네이션

## 🎨 UI 디자인 출처

이 프로젝트의 UI 디자인은 [Dribbble의 Cinepix](https://dribbble.com/shots/25673169-Cinepix-Get-Started-Home-Series-detail)에서 영감을 받았습니다.

**면책조항**:
- 본 프로젝트는 **학습 목적**으로만 제작되었습니다.
- 디자인의 모든 권리는 원 디자이너에게 있습니다.
- 이 프로젝트는 상업적 용도로 사용되지 않습니다.
- 원작 디자인을 Flutter로 재구현한 학습용 데모입니다.

## 라이선스

이 프로젝트는 학습 목적으로 만들어진 데모 앱입니다.

## 참고 자료

- [TMDB API Documentation](https://developers.themoviedb.org/3)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dio Package](https://pub.dev/packages/dio)
- [Dribbble - Cinepix Design](https://dribbble.com/shots/23058000-Cinepix-Movie-Streaming-Mobile-App)
