# posttree

A new Flutter project.

## Project
MVVM

## Run on web
```bash
$ flutter run -d chrome --web-port=5000
```

## Run on ios
```bash
$ open -a Simulator
$ flutter run
... take a long time
```

## 依存を追加する手順

```bash
$ dart pub add provider
```

1. pubspec.yamlに追記する

```yaml
dependencies:
  provider: ^3.1.0+1
```

2. 更新する

```bash
$ flutter pub get
```

## fmt
```bash
$ flutter format .
```

## エラー一覧

### A GlobalKey can only be specified on one widget at a time in the widget tree.
```
A GlobalKey can only be specified on one widget at a time in the widget tree.

The relevant error-causing widget was:
  MaterialApp file:///Users/s11604/IdeaProjects/bambootuna/posttree/lib/main.dart:11:12
```

ホットリロードではなく、もう一回`flutter run`したらなおったw

## firebase auth

### google

#### IOS

`GoogleService-Info.plist`のREVERSED_CLIENT_IDを`Info.plist`に書き込む

```Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...
	<key>CFBundleURLTypes</key>
    <array>
    	<dict>
    		<key>CFBundleTypeRole</key>
    		<string>Editor</string>
    		<key>CFBundleURLSchemes</key>
    		<array>
    			<string>com.googleusercontent.apps.??????????</string>
    		</array>
    	</dict>
    </array>
</dict>
</plist>
```