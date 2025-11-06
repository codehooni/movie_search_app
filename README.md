# Movie Demo

Flutter를 사용하여 TMDB(The Movie Database) API로 영화 정보를 가져와 표시하는 데모 앱입니다.

## 📱 스크린샷

<div style="overflow-x: auto; white-space: nowrap;">
  <table>
    <tr>
      <td align="center"><b>홈 화면</b></td>
      <td align="center"><b>즐겨찾기</b></td>
      <td align="center"><b>검색 화면</b></td>
      <td align="center"><b>영화 상세 페이지</b></td>
    </tr>
    <tr>
      <td><img width="250" alt="home_screen" src="https://github.com/user-attachments/assets/6e206117-467a-4397-b7b2-c34459005ed1" /></td>
      <td><img width="250" alt="favorites_screen" src="https://github.com/user-attachments/assets/845508b6-9fd2-4f95-a741-310901f408f8" /></td>
      <td><img width="250" alt="search_screen" src="https://github.com/user-attachments/assets/0f14a87c-eb78-4b68-bdb6-7fce462b687e" /></td>
      <td><img width="250" alt="detail_screen" src="https://github.com/user-attachments/assets/76ce4cb7-9b9b-4a5f-8ae8-e27fc26070a7" /></td>
    </tr>
  </table>
</div>

## 주요 기능

### 🏠 홈 화면 (Home Screen)
- **배경 이미지**: 선택된 영화의 포스터를 전체 화면 배경으로 표시
- **그라디언트 효과**: 배경 이미지 위에 자연스러운 그라디언트 오버레이
  - 0~30%: 투명 (포스터 표시)
  - 30~60%: 그라디언트 전환
  - 60~100%: 배경색
- **영화 카드**: 선택된 영화의 상세 정보 표시 (제목, 장르, 평점, 재생 버튼)
- **인기 영화 리스트**: 가로 스크롤 가능한 영화 포스터 목록
- **인터랙티브 선택**:
  - 포스터 클릭 시 배경 및 카드 정보 변경
  - 선택된 영화 재클릭 시 상세 화면으로 이동
- **더보기 버튼**: 검색 화면으로 빠른 이동

### 🔍 검색 화면 (Search Screen)
- **실시간 검색**: Debouncer를 활용한 500ms 지연 검색
- **무한 스크롤**: 스크롤 하단 200px 도달 시 자동으로 다음 페이지 로드
- **상태 관리**: 인기 영화 모드 / 검색 결과 모드 자동 전환
- **키보드 관리**: 스크롤 시 자동 포커스 해제
- **Pull-to-Refresh**: 아래로 당겨서 목록 새로고침
- **에러 처리**: 네트워크 오류 감지 및 재시도 버튼 제공

### 📄 상세 화면 (Detail Screen)
- **영화 상세 정보**: 제목, 개봉년도, 평점, 장르, 줄거리 표시
- **즐겨찾기 기능**: 영화를 즐겨찾기에 추가/제거 (SharedPreferences 사용)
- **Hero 애니메이션**: 화면 전환 시 부드러운 이미지 애니메이션
- **실시간 상태 반영**: 즐겨찾기 추가/제거 즉시 UI 업데이트
- **액션 버튼**: 즐겨찾기, 다운로드, 재생 버튼

### ⭐ 즐겨찾기 화면 (Favorites Screen)
- **로컬 저장소**: SharedPreferences를 통한 영구 데이터 저장
- **장르 필터링**: 12개 장르별 영화 필터링 기능
- **그리드 레이아웃**: 2열 그리드로 영화 포스터 표시
- **자동 새로고침**: 상세 화면에서 돌아오면 목록 자동 업데이트
- **Pull-to-Refresh**: 아래로 당겨서 목록 새로고침

### 🧭 내비게이션
- **Bottom Navigation Bar**: Home, Favorites, Search 화면 간 빠른 전환

## 🎨 UI/UX 특징

### 반응형 디자인
- **MediaQuery 기반**: 모든 크기 계산에 `mq.width`, `mq.height` 활용
- **다양한 화면 크기 대응**: 디바이스 크기에 따라 자동 조정
- **비율 기반 레이아웃**: 픽셀 대신 비율(%) 사용

### 통합 위젯 시스템
```dart
MyMovieCard(
  movie: movie,
  isBig: true,      // 큰 카드 / 작은 카드
  isHome: true,     // 홈 화면용 (재생 버튼 표시)
)
```
- **단일 위젯**: MyMovieCard + MyBigMovieCard 통합
- **7:10 비율**: 일관된 이미지 비율 유지
- **반응형 크기**: 화면 크기에 따라 자동 조정

### 테마 최적화
- **로컬 변수화**: `final colorScheme = Theme.of(context).colorScheme`로 성능 개선
- **일관된 색상**: primary, surface, onSurface 등 체계적 색상 시스템
- **투명도 조절**: `withAlpha()`를 통한 시각적 계층 구조

## 기술 스택

### Core
- **Flutter**: ^3.9.2
- **Dart**: 프로그래밍 언어

### 패키지
- **http**: HTTP 통신 (TMDB API)
- **shared_preferences**: 로컬 데이터 저장
- **json_annotation**: JSON 직렬화
- **json_serializable**: JSON 직렬화 코드 생성
- **font_awesome_flutter**: FontAwesome 아이콘
- **cupertino_icons**: iOS 스타일 아이콘

### API
- **TMDB API**: The Movie Database API
  - 인기 영화 조회
  - 영화 검색
  - 영화 상세 정보

## 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점, MediaQuery 초기화
├── models/
│   ├── movie.dart              # Movie 모델 (장르 매핑 포함)
│   └── movie.g.dart            # 자동 생성된 JSON 직렬화 코드
├── screens/
│   ├── main_screen.dart        # Bottom Navigation (Home/Favorites/Search)
│   ├── home_screen.dart        # 홈 화면 (배경 이미지 + 인기 영화)
│   ├── search_screen.dart      # 검색 화면 (검색 + 무한 스크롤)
│   ├── favorites_screen.dart   # 즐겨찾기 화면 (장르 필터링)
│   └── detail_screen.dart      # 상세 화면 (영화 정보)
├── widgets/
│   └── my_movie_card.dart      # 통합 영화 카드 위젯 (isBig, isHome 파라미터)
├── services/
│   ├── api_service.dart        # API 호출 서비스 (인기/검색)
│   └── favorites_service.dart  # 즐겨찾기 저장 서비스
├── utils/
│   └── debouncer.dart          # 검색 디바운서
└── theme/
    └── dark_mode.dart          # 다크모드 테마
```

## 설치 및 실행

### 1. API 키 설정

`lib/services/api_service.dart` 파일에서 API 키 설정:

```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```

API 키는 [TMDB 웹사이트](https://www.themoviedb.org/)에서 발급받을 수 있습니다.

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

## 🚀 주요 개선 사항

### 코드 리팩토링
1. **위젯 통합**: MyMovieCard + MyBigMovieCard → MyMovieCard (isBig 파라미터)
2. **상태 관리 개선**: SearchMode → MovieState enum으로 명확한 상태 구분
3. **코드 중복 제거**: _loadMovies, _loadMore 로직 단순화
4. **화면 분리**: 검색 기능을 별도 SearchScreen으로 분리

### 성능 최적화
1. **Theme 캐싱**: `final colorScheme = Theme.of(context).colorScheme`로 반복 호출 방지
2. **FutureBuilder 제거**: 직접 상태 관리로 불필요한 리빌드 방지
3. **이미지 비율 통일**: 7:10 비율로 일관성 유지 및 레이아웃 안정화
4. **MediaQuery 활용**: 반응형 디자인으로 다양한 화면 크기 대응

### UX 개선
1. **키보드 자동 숨김**: GestureDetector + onPanDown으로 스크롤 시 포커스 해제
2. **포커스 관리**: FocusNode를 통한 검색 필드 제어
3. **로딩 상태**: CircularProgressIndicator, 빈 화면 처리
4. **인터랙티브 홈 화면**: 포스터 선택 시 배경 및 정보 변경

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
enum MovieState { popular, searching }
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

### 4. Hero 애니메이션
화면 전환 시 부드러운 공유 요소 애니메이션
```dart
Hero(
  tag: 'hero-movie-${movie.id}',
  child: Image.network(...),
)
```

### 5. 장르 필터링
Movie 모델에 장르 ID→이름 매핑 로직 구현
```dart
List<String> get genreNames {
  const genreMap = {28: '액션', 35: '코미디', ...};
  return genreIds.map((id) => genreMap[id] ?? '알수없음').toList();
}
```

### 6. 무한 스크롤 (Infinite Scroll)
ScrollController를 사용한 페이지네이션 구현
```dart
final ScrollController _scrollController = ScrollController();
List<Movie> movies = [];
int currentPage = 1;
bool isLoadingMore = false;
bool hasMore = true;

void _onScroll() {
  // 스크롤이 끝에서 200px 전에 도달하면 다음 페이지 로드
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    if (!isLoadingMore && hasMore) {
      _loadMore();
    }
  }
}

Future<void> _loadMore() async {
  setState(() => isLoadingMore = true);

  final nextPage = currentPage + 1;
  final newMovies = await apiService.getPopularMovies(page: nextPage);

  setState(() {
    currentPage = nextPage;
    movies.addAll(newMovies);
    hasMore = newMovies.length >= 20;
    isLoadingMore = false;
  });
}
```

### 7. MediaQuery 기반 반응형 디자인
화면 크기에 따라 동적으로 크기 조정
```dart
// main.dart에서 전역 변수로 초기화
late Size mq;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;  // 화면 크기 저장
    return MaterialApp(...);
  }
}

// 사용 예시
Container(
  width: mq.width * 0.3,   // 화면 너비의 30%
  height: mq.height * 0.25, // 화면 높이의 25%
)
```

### 8. 통합 위젯 패턴
단일 위젯으로 다양한 케이스 처리
```dart
class MyMovieCard extends StatelessWidget {
  final Movie movie;
  final bool isBig;
  final bool isHome;

  Widget build(BuildContext context) {
    final width = isBig ? mq.width * 0.27 : mq.width * 0.17;
    final height = width / 0.7;  // 7:10 비율

    return Row(
      children: [
        if (!isHome) _buildImage(context),
        _buildInfo(context),
        if (isHome) _buildPlayButton(context),
      ],
    );
  }
}
```

## API 엔드포인트

### 인기 영화 목록
```
GET /movie/popular
Parameters:
  - api_key: TMDB API 키
  - language: ko-KR
  - page: 페이지 번호 (default: 1)
```

### 영화 검색
```
GET /search/movie
Parameters:
  - query: 검색어
  - api_key: TMDB API 키
  - language: ko-KR
  - page: 페이지 번호 (default: 1)
```

## 구현 완료된 기능

- [x] 검색 기능 구현 (debounce 적용)
- [x] enum을 사용한 상태 관리 (MovieState)
- [x] Pull-to-refresh 기능
- [x] 에러 처리 개선 (네트워크 오류별 메시지)
- [x] 영화 장르별 필터링
- [x] 즐겨찾기 기능 (로컬 저장)
- [x] Bottom Navigation (3개 탭)
- [x] 무한 스크롤 페이지네이션
- [x] 위젯 통합 (MyMovieCard + MyBigMovieCard)
- [x] 반응형 디자인 (MediaQuery 기반)
- [x] Theme 최적화 (로컬 변수화)
- [x] 홈 화면 인터랙티브 UI (배경 이미지 변경)

## 개선 예정 사항

- [ ] 영화 평점 표시 개선 (별점 UI)
- [ ] 즐겨찾기 화면 정렬 옵션 (최신순, 평점순)
- [ ] 영화 트레일러 재생 기능
- [ ] 스플래시 스크린 추가
- [ ] 다크모드/라이트모드 토글
- [ ] 애니메이션 효과 추가
- [ ] 오프라인 모드 지원

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
- [Dribbble - Cinepix Design](https://dribbble.com/shots/23058000-Cinepix-Movie-Streaming-Mobile-App)

---

**개발 환경**: Flutter 3.9.2+
**최소 지원 버전**: iOS 12.0+ / Android 5.0+
