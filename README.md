# Chat.Zip

# 1. 팀 소개

---

### 팀명 : chat.zip

### **빅데이터 및 AI 활용 트랙**

파트너사 : Pathfinder, AWS, 네이버클라우드

### 파트너사 : Pathfinder, AWS, 네이버 클라우드

[팀 명단](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/%E1%84%90%E1%85%B5%E1%86%B7%20%E1%84%86%E1%85%A7%E1%86%BC%E1%84%83%E1%85%A1%E1%86%AB%201a9ba42e91394e91877cd6b70c78766d.csv)

# 2. 서비스 개요

---

> **서비스명**
> 

> **한줄 소개**
> 

ChatZip

**바쁜 현대인들을 위한 채팅 요약 서비스**

> **개발 동기**
> 
- 카카오톡의 오픈채팅방이나 텔레그램의 채널 같은 다수의 사람들이 대화에 참여하는 채팅방들이 있다. 주로 주식이나 코인 등의 정보 제공을 목적으로 하는 채팅방이 많고, 일상적인 목적으로도 수많은 사람들이 채팅에서 수다를 떨다 보면 순식간에 많은 채팅이 쌓여있다.
- 해당 채팅방에 참여하는 사람은 어떤 대화 내용이 오고 갔는지도 모른 채, 대화를 따라가고 정보를 얻기 위해 위에서부터 읽기 시작하는데, 세간에선 이를 벽타기, 등반이라고 할 정도로 생각보다 오랜 시간이 걸린다.
- 또한, 공유 오피스 ‘패스파인더’에 직접 입주해 본 멤버의 입장에서, 패스파인더에 입주한 여러 스타트업 기업들은 운영에 있어 메신저가 상당히 중요한 역할을 한다고 생각한다. 특히, 가장 많이 쓰는 메신저인 카카오톡을 통한 대화 내용을 요약해 줌으로써 업무에 큰 도움이 될 것이라고 본다.
- 따라서, 우리 chat.zip 팀은 하루에도 수 백여개의 대화가 오가는 중에 하루 마다, 혹은 원할때마다 간단하게 채팅을 요약한 정보를 알 수 있는, 바쁜 현대인들을 위한 앱을 개발하고자 한다.

# 3. 세부 내용

---

- 정보 제공을 목적으로 하는 채팅방(ex. 주식, 코인)에서 나누는 많은 대화 뿐만 아니라 쌓여있던 일상의 많은 알림 하나하나를 압축하여 한 눈에 보기 쉽게 요약해 주는 서비스로, 접근성을 위해 앱으로 개발한다.
- 또한, 고성능의 요약 기능을 제공하고 보다 많은 명령을 처리하고자 LLM와 연동되는 백엔드 서버를 두고 보안 및 개인정보 보호에 중점을 두어 개발한다.

> **사용 기술**
> 
1. **Front-End : Flutter로 앱 구현**
    1. 주요 라이브러리
        1. notification_listener_service: ^0.3.2 - 디바이스 시스템 알림을 가져오기 위해 사용
        2. http: ^1.1.0 - AWS백엔드 서버와 api request를 위해 사용
        3. shared_preferences: ^2.2.0 - 채팅기록 보호를 위해 외부 서버 및 DB를 사용하지 않고 내부 저장용 메인 데이터베이스로 사용
    2. 화면 구성
        1. 앱 선택 목록 화면
        2. 채팅방 목록 화면
        3. 채팅 요약 화면
        4. 권한 선택 화면

![KakaoTalk_20230708_021100107.jpg](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/KakaoTalk_20230708_021100107.jpg)

알림 앱 선택 화면

![KakaoTalk_20230708_063850850_02.jpg](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/KakaoTalk_20230708_063850850_02.jpg)

채팅방 목록 화면

![KakaoTalk_20230708_064130062.jpg](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/KakaoTalk_20230708_064130062.jpg)

채팅 요약 화면

![Untitled](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled.jpeg)

권한 선택 화면

1. **Back-End : AWS 서버 구축**
- LLM - AWS EC2 [Langchain - Python Fastapi - Uvicorn - Nginx] 로 구성된 분산 처리 가능한 백엔드 서버 구축

![Untitled](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled.png)

![Untitled](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled%201.png)

- 비동기 및 병렬 프로그래밍을 통한 전처리 및 응답 속도 향상
- 채팅의 내용이 길어 모델의 최대 토큰 수를 넘더라도 맥락을 유지하며 요약이 가능한 토크나이징 알고리즘 적용
- 채팅 내용에 URL이 포함되어있을경우, 비정형화 문서 추출 알고리즘을 이용하여 내부HTML 분석 후 핵심 내용을 반환
- GPT4, Clova Summarize와 요약 성능 비교를 해본 결과, 3.5 Turbo 버전이 비용대비 축약, 이해 성능이 뛰어나 비용 절감 및 반응 속도를 올리기 위해 3.5 버전을 채택하여 프롬프트 엔지니어링을 진행
    - ChatGPT4 vs ChatGPT3.5 vs Naver Clova summarize 비교결과
        - 카카오톡 메시지 200개(2800토큰) 대상 요약 성능 비교
        
        ![Untitled](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled%202.png)
        
        - ChatGPT4 : $0.12 per 1K token, 최대 **8192 token,** 평균응답속도: 25초
        - ChatGPT3.5 : $0.002 per 1k token, 최대 4096 token, 평균응답속도:13초
        - NaverClova : $0.0015per 1 call, 최대 2000 token, **평균응답속도 2초**
    
    ![[ChatGPT3.5]](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled%203.png)
    
    [ChatGPT3.5]
    
    ![[Naver Clova Summarize ]](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled%204.png)
    
    [Naver Clova Summarize ]
    
- 네이버 클로바는 빠르지만 기사 및 블로그 글 기반의 요약이라 대화체 요약 성능이 많이 떨어지고, 4버전은 요약 자동화를 진행하기엔 비용이 너무 비싸 최종적으로 3.5모델을 선택.

[https://www.notion.so](https://www.notion.so)

> **구현 과정**
> 

![Untitled](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/Untitled%205.png)

(1) 메신저들은 대화 API를 제공하지 않으므로, 시스템 API를 통해 알림을 가져와 메신저 내용의 수집 가능 확인

(2) 알림을 가져오는 과정에서 내용 및 발신인을 확인할 수 있지만, 어떤 채팅방인지 확인 불가한 문제로 알람  아이콘 그림을 스트링화하여 그룹을 구분

(3) 유저가 채팅을 기록할 목록을 선택할 수 있게 그룹 선택이 가능한 앱 기능 명세 및 화면 UI 설계

(4) 앱에서 기록할 채팅 목록을 유저 요청 전까지 내부 DB에 쌓고 유저 요청 시 암호화 및 익명화 처리로 외부 서버와 통신 시작

(5) AWS 백엔드 서버는 채팅 목록 필터링, 구문 분석 및 전처리 후, 최대한 맥락을 보존하면서 토크나이저를 통해 LLM의 최대 처리 가능 토큰 단위로 분해

(6) 이후 프롬프트 엔지니어링을 통해 각 채팅목록의 요약본을 반환

(7) 다시 앱에서 반환된 익명화 대화기록을 보내기 전 기록했던 보안키로 복원

(8) 이전 채팅 기록을 지우고, 요약된 정보만 최근 DB에 다시 저장하여 저장소 용량 유지

(9) 유저는 앱의 각 채팅목록에서 반환된 요약과 이전 기록을 확인하고 관리할 수 있음.

> 기능 설명
> 
1. 주요 기능
    1. 디바이스 알림 센싱 및 분류 기능
    2. 디바이스 알림 센싱 on/off 기능
    3. 카카오톡 알림 미리보기 기능
    4. 카카오톡 채팅방별 대화 요약 기능
    5. 요약 내용 삭제 기능
    6. 대화 내용 암복호화 기능
2. 앱 로고 및 이름 사진
3. 스플래시 스크린
4. main 화면
    1. 사용자 권한 동의를 받아 알림 데이터 수집
5. 채팅방 리스트 화면
    1. on/off 기능을 추가하여 사용자의 보안 및 편의에 맞게 선별적 데이터 수집 가능
6. 채팅 화면
    1. 데이터를 주고받는 과정에서 암호화를 적용하여 보안 강화
    2. 버튼을 활용하여 요약분석 요청 / 목록 삭제
    3. api 요청 시, 로딩바 구현
    4. 대화 미리보기를 보는 도중 요약 요청 및 삭제 기능
    

# 4. 기대 효과

---

- 많은 대화 내용을 카톡방에 들어가 일일이 확인하지 않아도 되므로, 많은 시간을 절약하고 편의 제공 가능
- 채팅방의 대화 내용을 읽음 표시하지 않고 요약본을 볼 수 있으므로, 손쉽게 대화내용을 파악 가능함
- 껄끄러운 상대 및 조회 수가 신경쓰이는 상황에서 알림만을 통해 유유히 내용만 볼 수 있음.
- 서버가 따로 로그를 저장하지 않고 채팅 내용 또한 암호화 및 익명화하여 전달하므로 개인정보 보호를 제공함

- **발전 방향성**
    - 스마트폰 시스템 API를 활용하여 알림을 가져오므로, 사용자가 권한 허용만 한다면 카카오톡 서비스 뿐만 아니라 트위터나 텔레그램 등의 플랫폼도 지원가능하게 추가할 예정이다.

# 5. 자료

> MVP GitHub Release (APK다운로드 주소)
  
  [https://github.com/PNU-ChatZip/Prompter-Day-Seoul/releases/tag/v1.0.0](https://github.com/PNU-ChatZip/Prompter-Day-Seoul/releases/tag/v1.0.0)
> 구글 드라이브 백업 다운로드 주소
  
  [https://drive.google.com/file/d/1YS6NlFfOIiDjCkW_3B2GZXgqMDT66zu8/view?usp=sharing](https://drive.google.com/file/d/1XYsiDOoBoT2tLoInwdPkhBH9FIWat906/view?usp=sharing)

> 사용법
  
https://github.com/PNU-ChatZip/Prompter-Day-Seoul/assets/34530460/92f38de7-6794-4da8-93bb-9a69dd820e32

# 6. 발표 자료

---

[DX해카톤_ChatZip발표자료.pdf](Chat%20Zip%202c46c8213e684f80b3d446d884545b32/DX%25ED%2595%25B4%25EC%25B9%25B4%25ED%2586%25A4_ChatZip%25EB%25B0%259C%25ED%2591%259C%25EC%259E%2590%25EB%25A3%258C.pdf)

![Untitled](https://media2.giphy.com/media/26AHC0kdj8IeLkmBy/giphy.gif?cid=7941fdc6o01e5vrf166fb5ayjd4tthktr7dbvyoa9xw8mvux&ep=v1_gifs_search&rid=giphy.gif&ct=g)

![Untitled](https://media4.giphy.com/media/l396M3jF14DXr9mog/giphy.gif?cid=7941fdc64wctks08w1pk2h6xca0lmunshicziuqh026385l9&ep=v1_gifs_search&rid=giphy.gif&ct=g)
