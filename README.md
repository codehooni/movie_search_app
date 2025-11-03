# Movie Demo

Flutter를 사용하여 TMDB(The Movie Database) API로 영화 정보를 가져와 표시하는 데모 앱입니다.

## 📱 스크린샷

### 인기 영화 목록
![인기 영화 목록](screenshots/home_screen.png)

### 영화 상세 페이지
![영화 상세 페이지](screenshots/detail_screen.png)

## 주요 기능

- **인기 영화 목록**: TMDB API를 통해 현재 인기 있는 영화 목록을 가져와 표시
- **영화 상세 정보**: 영화 카드를 탭하여 상세 정보 확인
- **Hero 애니메이션**: 화면 전환 시 부드러운 이미지 애니메이션 효과
- **검색 바 UI**: 영화 검색을 위한 UI (기능 구현 예정)

## 기술 스택

- **Flutter**: ^3.9.2
- **Dio**: HTTP 통신 라이브러리
- **TMDB API**: 영화 정보 제공
- **json_serializable**: JSON 직렬화/역직렬화
- **flutter_dotenv**: 환경 변수 관리
- **font_awesome_flutter**: FontAwesome 아이콘

## 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── models/
│   ├── movie.dart              # Movie 모델
│   └── movie.g.dart            # 자동 생성된 JSON 직렬화 코드
├── screens/
│   ├── home_screen.dart        # 홈 화면 (인기 영화 목록)
│   └── detail_screen.dart      # 상세 화면 (영화 상세 정보)
├── widgets/
│   ├── my_movie_card.dart      # 작은 영화 카드 위젯
│   └── my_big_movie_card.dart  # 큰 영화 카드 위젯
├── services/
│   └── api_service.dart        # API 호출 서비스
└── theme/
    └── dark_mode.dart          # 다크모드 테마
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

### Dev Dependencies
- `flutter_lints` (^5.0.0): 코드 품질 검사
- `json_serializable` (^6.11.1): JSON 직렬화 코드 자동 생성
- `build_runner` (^2.10.1): 코드 생성 도구

## 주요 학습 포인트

### 1. FutureBuilder 사용
- API 호출 결과를 비동기로 처리
- 로딩, 에러, 데이터 상태 관리
- `initState()`에서 Future 초기화하여 재호출 방지

```dart
FutureBuilder<List<Movie>>(
  future: popularMovies,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // 로딩
    }
    if (snapshot.hasError) {
      return Text('에러 발생'); // 에러
    }
    return ListView(...); // 데이터
  },
)
```

### 2. Hero 애니메이션
- 화면 전환 시 공유 요소 애니메이션
- 같은 `tag`를 가진 위젯끼리 연결
- 각 영화마다 고유한 tag 사용: `hero-movie-${movie.id}`

```dart
Hero(
  tag: 'hero-movie-${movie.id}',
  child: Image.network(...),
)
```

### 3. JSON 직렬화
- `@JsonSerializable()` 어노테이션 사용
- `@JsonKey(name: 'snake_case')` 필드명 매핑
- Getter를 통한 데이터 변환 (`year`, `genreNames`)

### 4. TMDB 이미지 URL 구성
- 기본 URL: `https://image.tmdb.org/t/p/`
- 크기 옵션: `w500` (width 500px)
- 경로: `${movie.posterPath}` (API에서 제공)

### 5. Flutter 레이아웃
- `Column` + `Expanded`: 남은 공간 채우기
- `ListView.builder`: 효율적인 리스트 렌더링
- `GestureDetector`: 터치 이벤트 처리
- `Navigator.push`: 화면 전환

## API 엔드포인트

### 인기 영화 목록
```
GET /movie/popular
Parameters:
  - api_key: TMDB API 키
  - language: ko-KR
```

## 개선 예정 사항

- [ ] 검색 기능 구현 (debounce 적용)
- [ ] enum을 사용한 상태 관리 개선
- [ ] Pull-to-refresh 기능
- [ ] 에러 처리 개선
- [ ] 로딩 애니메이션 개선
- [ ] 영화 장르별 필터링
- [ ] 즐겨찾기 기능

## 🎨 UI 디자인 출처

이 프로젝트의 UI 디자인은 [Dribbble의 Cinepix](https://dribbble.com/shots/23058000-Cinepix-Movie-Streaming-Mobile-App)에서 영감을 받았습니다.

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