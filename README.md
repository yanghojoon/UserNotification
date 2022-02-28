# 💌 UserNotification
야곰 23주차 활동학습에서 진행한 UserNotification 관련 활동입니다.

### 📖 UserNotifications는 뭘까?
일단 User Notification`이 뭔지 살펴보자. 
`<img width="735" alt="스크린샷 2022-02-27 오후 3 01 02" src="https://user-images.githubusercontent.com/90880660/155987081-8a0ff674-c2dd-48a7-b2cb-cbed5776569a.png">

위 그림처럼 카톡이나, 유튜브, 메일 등에서 알림을 받아본 적이 있을 것이다. 
User Notification이 바로 저 알림을 의미한다. 

사용자에게 알림을 보내 사용자가 디바이스를 사용 중이든, 아니든 앱 사용자에게 중요한 정보를 전달하게 된다. 또한 이를 탭하여 인터페이스를 업데이트하고 앱에서 특정 작업을 할 수 있도록 구현할 수도 있다.

그렇다면 `UserNotifications` 프레임워크는 무슨 일을 할까?
- 앱이 지원하는 알림의 유형을 결정한다. (.alert, .sound, .badge)
- 알림의 유형과 관련된 커스텀한 액션을 정의한다. 
- 알림의 전달을 위해 위치 관련 알림을 예약한다.
- 이미 전달된 알림을 처리한다.
- 사용자가 선택한 액션에 대해 처리를 한다.

<br>

### 🗄 UserNotifications의 종류
`User Notification`은 크게 2가지로 나뉜다. 
- **Local Notification** : 따로 서버를 거치지 않고 앱이 직접 시스템에 특정 조건에 맞춰 알림을 달라고 요청함. 
- **Remote Notification**: 아래 그림처럼 `Provider(서버)`가 따로 존재한다. 그리고 `APNs(애플 푸시 노티피케이션 서비스)`를 무조건 거쳐야 한다. 이때 모든 정보가 100% 전달되는 것은 장담할 수 없다고 나왔있다. 
서버끼리의 통신 장애나 장기간의 기기 꺼짐 등으로 데이터가 누실될 수 있다. 
<img width="500" alt="스크린샷 2022-02-28 오전 10 28 07" src="https://user-images.githubusercontent.com/90880660/155985986-a6b67686-ff3d-444c-b131-53d6f7473fe5.png">

이때 알람을 요청할 수 있는 특정 조건이 존재한다. 
- 시간 (Time Interval) 
- 날짜 (Date)
- 위치 (Location)

<br>

### 🖋 [권한을 요청하자](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)
사용자에게 알림을 보내기 전에 반드시 권한을 요청해야 한다. 
사용자가 알림에 대한 권한을 허용해야 알림을 보낼 수 있는 것이다. 

따라서 앱을 시작할 때나 알림을 요청해야하는 작업이 있을 경우 권한을 요청할 수 있도록 해야 한다. (공식문서에서는 앱에 권한 승인이 필요한 이유를 이해하는데 도움이 되는 상황에서 권한을 요청하길 권하고 있다)
그렇다면 권한은 어떻게 요청할 수 있을까? 

일단 권한을 요청하기 위해선 `UNUserNotificationCenter` 인스턴스를 생성하고 `requestAuthorization(options:completionHandler)` 메서드를 호출해야 한다. 
이때 `options`에는 사용자와 어떻게 상호작용을 하며 알림을 보낼 것인지를 정해주면 된다. 

해당 프로젝트에선 앱을 시작할 때 권한을 요청해보도록 하자. 
```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { // 앱이 처음 실행되는 방법은 정말 다양하다. launchOptions에 remoteNotification을 처리할 수 있다.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { granted, error in
            print("권한 허용 \(granted)") // 권한 허용이 됐는지에 대한 Bool 값
            
            if let error = error {
                print(error)
            }
        }
        application.registerForRemoteNotifications() // APNs 파일을 사용하기 위해 작성해줌. 
        center.delegate = self
        return true
    }
 }
```

<br>

### 🤲🏻 APNs 파일을 생성해보자
APNs 파일은 앞서 설명했듯 Remote Notification을 Provider에서 발송한 뒤 반드시 거쳐야 하는 애플 푸시 노티피케이션 서비스이다. 
이는 직접 `텍스트 편집기`를 통해 생성해줄 수 있다. 

만약 텍스트 편집기를 켰는데 다음과 같이 화면이 되어 있다면 파일을 생성할 때 요상한 주석들이 잔뜩 달릴수도 있다. 
<img width="604" alt="스크린샷 2022-02-28 오후 10 16 59" src="https://user-images.githubusercontent.com/90880660/155989840-7f0a9b7a-13f9-4239-bdc1-659511d3186e.png">

따라서 이때는 텍스트 편집기의 `포맷 > 일반 텍스트 만들기` 로 설정을 바꿔주면 된다. 

<img width="246" alt="스크린샷 2022-02-28 오후 10 17 10" src="https://user-images.githubusercontent.com/90880660/155989940-c940adce-50c0-4e44-bb1f-43396bce6b20.png">

여기에 JSON 파일과 유사한 형태의 내용을 작성해주면 된다. 

```swift
{
   "Simulator Target Bundle": "net.yagom.PracticeUserNotification",
   "aps" : {
      "alert" : {
         "title" : "Hi brown",
         "body" : "This is the letter from England..."
      },
   },
   "target_view" : "brown_view"
}
```

여기서 `Simulator Target Bundle`의 경우 프로젝트의 General > Identity > Bundle Identifier를 가져오면 된다. 

<img width="739" alt="스크린샷 2022-02-28 오후 10 22 23" src="https://user-images.githubusercontent.com/90880660/155990463-5b2f2168-1d2a-4524-98b6-4d00a2373c7a.png">

또한 `aps`의 경우 remote notification인 경우 페이로드에 실려오는 노티피케이션 컨텐츠를 의미한다. 

그 밑에 있는 `target_view`의 경우 추후 `userInfo`를 통해 접근할 수 있다. 

<br>

### 🔧 노티를 처리해보자 (UNUserNotificationCenterDelegate)
위 파일을 생성하여 시뮬레이터에 드래그 앤 드롭으로 넣어주면 시뮬레이터에 노티가 뜨게 된다. 
즉, remote Notification을 받은 것처럼 연출을 할 수 있는 것이다. 

하지만 여기서 더 중요한 것은 알림을 보내는 것이 아니라 **알림을 어떻게 처리하는가** 이다. 

<br>

#### 🟢 `userNotificationCenter(_:didreceive:withCompletionHandler)`

이를 위해 사용할 수 있는 것이 바로 `UNUserNotificationCenterDelegate`이다. 

그 중 `userNotificationCenter(_:didreceive:withCompletionHandler)`는 알림을 사용자가 탭했을 경우 호출되는 메서드이다. 

앱이 foreground에 있든 background에 있든 관계없이 알림이 왔을 때 탭을 하면 호출이 된다.  

따라서 탭을 했을 때 어떤 액션을 취할 지에 대해 작성해주면 된다. 

<br>

#### 🟢 `userNotificationCenter(_:willPresent:withCompletionHandler:)`

`userNotificationCenter(_:willPresent:withCompletionHandler:)`의 경우 앱이 foreground에 있을 때 알림을 띄우라고 오게 될 경우 호출되는 메서드이다. 

다만 설정을 따로 해주지 않는다면 Alert가 뜨진 않고 호출만 된다. 따라서 Alert를 어떻게 띄울지 정해줘야 한다. 

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner])
}
```

위 코드처럼 completionHandler에 array로 어떤 상호 작용을 할지 작성해주면 된다. 
