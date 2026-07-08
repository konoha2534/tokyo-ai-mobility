# Tokyo AI Mobility

Tokyo AI Mobility は、東京都内のデマンド交通をテーマにした Flutter ポートフォリオアプリです。

OpenStreetMap と OSRM REST API を利用し、乗車地・目的地の選択、ルート表示、AI風の運行提案、予約完了画面までの一連の体験を実装しています。日本のIT企業選考に向けて、モバイル開発・API連携・UI設計・コード構成を示すことを目的としています。

## 主な機能

- ダッシュボード画面
- ダッシュボード指標カード
- OpenStreetMap による地図表示
- 乗車地・目的地の選択
- OSRM API を利用したルート表示
- AIルート提案カード
- 予約完了画面
- 予約履歴画面
- Bottom Navigation による画面切り替え
- モバイル・Web向けのレスポンシブUI
- Material 3 ベースのデザイン
- ページ・ウィジェット・サービス・モデルに分割した構成

## 使用技術

- Flutter
- Dart
- flutter_map
- OpenStreetMap
- OSRM REST API
- latlong2
- http

## ディレクトリ構成

```text
lib/
  main.dart
  app.dart
  data/
  models/
  pages/
  services/
  widgets/
```

## 今後の実装予定

- Firebase Auth による Google ログイン
- Firestore による予約データ保存
- ユーザープロフィール表示
- Webデプロイ

## 起動方法

```bash
flutter pub get
flutter run
```

## チェック方法

```bash
flutter analyze
flutter test
```
