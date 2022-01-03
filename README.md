# LookBack
[![Image from Gyazo](https://i.gyazo.com/9717dcd86db84db505e5651e46357354.png)](https://gyazo.com/9717dcd86db84db505e5651e46357354)


# アプリケーション概要
サブスクをもっと活用するための、サブスク管理アプリ。
+ サブスク情報を一括管理
+ 累計金額・契約期間等サブスク情報の閲覧
+ 活用度の振り返り・アクションプラン設定


# 動作環境
## URL
+ https://look-back-36323.herokuapp.com/

## BASIC認証
+ ID      ： admin 
+ Password： 36323 

## テスト用アカウント
+ Email   ： test@email.com
+ Password： test123


# 制作背景
## 対象
+ 自己投資目的で、サブスクに課金している人
+ いろいろなサブスクを試している人
+ サブスクの契約を継続すべきか迷う人

## 解決したい事
+ 登録したものの、あまり活用できていないサブスクがある状態
+ 行動の伴わない受動的な活用にとどまる状態
+ 自分にとって有用な支払いか、判断しかねる状態

## 機能の実装背景
+ 振り返る
有益な情報も、インプットしただけでは自己成長につながりにくい。
情報を実際に活用することで、自分の目標へ近づくことができる。
実際の「行動」につなげるために、振り返り、何を実行するか決める事が必要だと考えた。
実装の具体例）
アクションプラン設定

+ 手軽さ
半年間のプログラミング学習中、学習後に振り返りを記入する時間を設けていた。
ほんの少しの改善や工夫が問題を解決したり、
振り返りを記入している間に、何が問題か気づく事があった。
大体的でなくとも、振り返る「きっかけ」があれば、現状の改善につながり、
簡易な方法であれば習慣化しやすいと実感した。
実装での具体例）
☆での簡易評価

+ 気づく
毎月の金額では妥当と感じていても、年間支払金額を見ると印象が変わる経験があった。
また、コンテンツが良いか悪いかという判断軸だけでなく、
実際にどんなときに役立ったか・いつ活用したか？と考えることで、
有益な支払いかどうか判断しやすくなると気づいた。
実装での具体例）
累計課金額・期間


# 洗い出した要件
+ ユーザー管理機能
  ユーザーごとにサブスク情報を管理するため
+ ユーザー編集機能
  ユーザー情報を修正するため(未実装)
+ ユーザー削除機能
  ユーザー登録を削除するため(未実装)
+ サブスク登録機能
  管理するサブスクを登録するため
+ サブスク一覧表示機能
  登録済のサブスクを確認するため
+ サブスク詳細機能
  登録したサブスクの情報を閲覧するため
+ サブスク編集機能
  登録したサブスクの情報を訂正するため
+ サブスク削除機能
  登録したサブスクを削除するため
+ サブスク更新機能
  サブスクの更新日に累計金額・期間を更新するため
+ サブスク評価機能
  サブスクの振り返りを行うため
+ サブスク評価一覧表示機能
  登録した振り返り情報を表示するため
+ サブスク評価詳細表示機能
  登録した振り返り情報を確認するため
+ サブスク評価編集機能
  登録した振り返り情報を訂正するため
+ サブスク未評価一覧表示機能
  振り返り待ちの評価を一覧で表示するため
+ サブスク解約機能
  サブスクの更新を停止するため
+ 解約サブスク一覧表示機能
  解約したサブスクを確認するため
+ 解約サブスク詳細表示機能
  解約理由を閲覧するため
+ 再開機能
  解約済のサブスクを再度契約状態にするため(未実装)
+ 更新通知機能
  サブスク更新日・振り返りをリマインドするため(未実装)
+ アクション記録機能
  実行したアクションプランを記録するため(未実装)
+ エクセル出力機能
  サブスク情報を出力し、より分析するため(未実装)
+ 問い合わせ機能
  エラー等を問い合わせるため(未実装)


# 実装した機能・利用方法
## ユーザー登録機能
[![Image from Gyazo](https://i.gyazo.com/e4c31b1f276d5ca93d582bf084590b36.gif)](https://gyazo.com/e4c31b1f276d5ca93d582bf084590b36)
+ トップページで、sign upをクリック
+ 必要事項を入力し、Createをクリック

## ログイン機能
+ ヘッダーのLoginをクリック
+ 必要事項を入力し、Loginをクリック

## ログアウト機能
+ ヘッダーのLogoutをクリック

## サブスク登録機能
[![Image from Gyazo](https://i.gyazo.com/295f8517208ba5dd4d0d2a3194c669b6.gif)](https://gyazo.com/295f8517208ba5dd4d0d2a3194c669b6)
+ マイページで、Addをクリック
+ 必要事項を入力・選択し、登録するをクリック

## サブスク編集機能
[![Image from Gyazo](https://i.gyazo.com/337856d1349270bf7256c259deef0d27.gif)](https://gyazo.com/337856d1349270bf7256c259deef0d27)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、編集をクリック
+ 必要事項を入力・選択し、更新するをクリック
+ 確認ホップアップが表示されるので、OKをクリック
+ 更新完了のホップアップが表示されるので、OKをクリック

## サブスク削除機能
[![Image from Gyazo](https://i.gyazo.com/828413e1db5968bdb095fa7ae7995361.gif)](https://gyazo.com/828413e1db5968bdb095fa7ae7995361)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、削除をクリック
+ 確認ホップアップが表示されるので、OKをクリック
+ 削除完了のホップアップが表示されるので、OKをクリック

## サブスク一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/371870f47d6d04aff7b3a90661f57dca.png)](https://gyazo.com/371870f47d6d04aff7b3a90661f57dca)
+ マイページトップ(Listsタブ)で、契約中のサブスク一覧が確認できる

## サブスク詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/fdf88dab4895e4958d1d71ddc7cda437.gif)](https://gyazo.com/fdf88dab4895e4958d1d71ddc7cda437)
+ マイページで、サブスクのカードをクリック
+ サブスク情報を確認できる

## サブスク更新機能
[![Image from Gyazo](https://i.gyazo.com/a388aeb55b759029b0dc3ccecf553ae4.gif)](https://gyazo.com/a388aeb55b759029b0dc3ccecf553ae4)
+ サブスク更新日になると、次回更新日がClickで更新に変化する
+ Clickで更新をクリック
+ 更新完了後、振り返りを促すホップアップが表示されるので、Goをクリック
[![Image from Gyazo](https://i.gyazo.com/bd7b3e0b424dde625db14b2fa7e2aec8.png)](https://gyazo.com/bd7b3e0b424dde625db14b2fa7e2aec8)
+ 後で振り返るをクリックすると、好きなタイミングで振り返ることができる
[![Image from Gyazo](https://i.gyazo.com/8659d7a65a7d6cba90f5827dd4afb502.png)](https://gyazo.com/8659d7a65a7d6cba90f5827dd4afb502)

## サブスク評価機能
[![Image from Gyazo](https://i.gyazo.com/be824e4fdaed1fbc7c5124f262990728.gif)](https://gyazo.com/be824e4fdaed1fbc7c5124f262990728)
+ サブスク更新後に表示される画面に、必要事項を入力する
+ レビューをクリック

[![Image from Gyazo](https://i.gyazo.com/16fd7f4c93498d68b4aeca4a6077cd1e.gif)](https://gyazo.com/16fd7f4c93498d68b4aeca4a6077cd1e)
+ 後で振り返るをONにすると、現在の入力を一時保存できる

## サブスク評価一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/ae690605373fa767773fe33081877418.gif)](https://gyazo.com/ae690605373fa767773fe33081877418)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 過去のレビュー一覧が確認できる

## サブスク評価詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/b8bdead730ce15e99769f8ee95126a88.gif)](https://gyazo.com/b8bdead730ce15e99769f8ee95126a88)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 閲覧したいレビューのカードのLook More→をクリック
+ 入力したレビューの詳細を確認できる

## サブスク評価編集機能
[![Image from Gyazo](https://i.gyazo.com/1a23fd0b73168212ca8febea8169dcef.gif)](https://gyazo.com/1a23fd0b73168212ca8febea8169dcef)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 閲覧したいレビューのカードのLook More→をクリック
+ Editをクリック
+ 必要事項を入力して、レビューをクリック

## サブスク未評価一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/25ee168c5e77275c444d967b7d7882c3.png)](https://gyazo.com/25ee168c5e77275c444d967b7d7882c3)
+ マイページで、Reviewsタブをクリック
+ 後で振り返るをONにしているレビュー一覧を確認できる

## サブスク解約機能
[![Image from Gyazo](https://i.gyazo.com/059109baa76c6104b59683a86f2ceeaf.gif)](https://gyazo.com/059109baa76c6104b59683a86f2ceeaf)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、解約をクリック
+ 必要事項を入力・選択し、解約するをクリック

## 解約サブスク一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/a8a6944d8590fe2dd07739c375a43bda.png)](https://gyazo.com/a8a6944d8590fe2dd07739c375a43bda)
+ マイページで、Cancelsタブをクリック
+ 解約済のサブスク一覧を確認できる

## 解約サブスク詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/d714df7f13ff7e951bd53556c73e3041.gif)](https://gyazo.com/d714df7f13ff7e951bd53556c73e3041)
+ マイページで、Cancelsタブをクリック
+ 閲覧したいサブスクカードをクリック
+ サブスク詳細ページに解約理由が表示される


# 工夫した点
+ サブスク管理だけでなく、振り返り機能があり、サブスクの活用を保証する設計にした
+ 振り返り項目でアクションプランを必須にし、行動を促す仕様にした
+ ☆評価で手軽な評価を実現し、振り返りを継続するハードルを下げる仕様にした
+ 更新待ちのサブスクには通知アイコンがつけ、目立たせた
+ 実際のサブスクに対応できるように、契約プランを充実させた
  - 年、月、日のタイプを選択可能
  - 年、月の場合は、契約日更新か、毎年・毎月1日更新か選択可能
+ サブスク登録時、契約開始日が過去の場合にも対応した
  - 契約開始日〜今日までの累計金額・契約期間が保存される仕様
+ 利用しやすいUIを心がけて設計した
  - 感覚的な操作ができるように、アイコン、hoverイベントを使用
  - サブスク登録時、自動で当日の日付が入る(カレンダー選択不要)
  - ハンバーガーメニューから、ワンクリックで編集・削除・解約操作ができる
  - 後で振り返る機能を利用し、内容の一時保存ができる
  - 複数のサブスクの「後で振り返るレビュー」があっても、一覧から処理できる
+ 気づきを得るきっかけとなる様、様々な角度の情報を表示した
  - サブスク契約金額だけでなく、累計金額・期間を表示
  - 解約理由・コメントを残すことで、自分の判断を見返す事が可能
  - サブスク☆評価の平均を表示することで、ロングスパンでのサブスク評価も確認可能


# 課題・実装予定機能
## 課題及び解決方法
+ モデル単体テストにおいて、モデルに定義したメソッドの異常系テストを実装・実行し、品質を担保
+ コントローラー単体テストを実装・実行し、品質を担保
+ 結合テストを実装・実行し、品質を担保
+ エラーメッセージの不自然な日本語を修正
+ エラーメッセージ変更に伴う、モデル単体テストの修正・実行
+ 繰り返しの記述、冗長な表現などコード改善、リファクタリング
+ 解約日が更新日・契約日より前の日付の場合、確認ホップアップを表示
+ エラー等を連絡するコンタクトフォームの作成

## 実装予定機能
+ 上記課題の解消
+ ビューレイアウトの改善
+ ユーザー編集機能
+ ユーザー削除機能
+ サブスク登録、評価入力時に、Javascriptで説明を表示する


# 使用技術(開発環境)
+ バックエンド

Ruby, Ruby on Rails

+ フロントエンド

HTML, CSS, tailwindcss, JavaScript, JQuery, Ajax

+ データベース

MySQL, Sequel Pro

+ 本番環境

Heroku

+ ソース管理

GitHub, GitHub Desktop

+ テスト

RSpec

+ エディタ

Visual Studio Code


# DB設計
[![Image from Gyazo](https://i.gyazo.com/456fcd402ba60029ce78bf077362140c.png)](https://gyazo.com/456fcd402ba60029ce78bf077362140c)

## users
| Column             | Type   | Options                   |
|--------------------|--------|---------------------------|
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| nickname           | string | null: false               |

### Association
+ has_many :subscriptions
+ has_many :reviews

## subscriptions
| Column             | Type       | Options                        |
|--------------------|------------|--------------------------------|
| name               | string     | null: false                    |
| price              | integer    | null: false                    |
| contract_date      | date       | null: false                    |
| update_type_id     | integer    | null: false                    |
| update_cycle       | integer    | null: false                    |
| update_day_type_id | integer    |                                |
| user               | references | null: false, foreign_key: true |

### Association
+ belongs_to :user
+ has_many :reviews
+ has_one :contract_renewal
+ has_one :contract_cancel

## contract_renewals
| Column           | Type       | Options                        |
|------------------|------------|--------------------------------|
| renewal_count    | integer    | null: false                    |
| total_price      | integer    | null: false                    |
| total_period     | integer    | null: false                    |
| update_date      | date       | null: false                    |
| next_update_date | date       | null: false                    |
| subscription     | references | null: false, foreign_key: true |

### Association
+ belongs_to :subscription


## contract_cancels
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| cancel_date    | date       | null: false                    |
| reason_id      | integer    | null: false                    |
| cancel_comment | text       |                                |
| subscription   | references | null: false, foreign_key: true |

### Association
+ belongs_to :subscription


## reviews
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| review_rate    | integer    |                                |
| review_comment | text       |                                |
| start_date     | date       | null: false                    |
| end_date       | date       | null: false                    |
| later_check_id | integer    | null: false                    |
| user           | references | null: false, foreign_key: true |
| subscription   | references | null: false, foreign_key: true |

### Association
+ belongs_to :user
+ belongs_to :subscription
+ has_one :action_plan


## action_plans
| Column                | Type       | Options                        |
|-----------------------|------------|--------------------------------|
| action_rate           | integer    |                                |
| action_review_comment | text       |                                |
| action_plan           | text       |                                |
| review                | references | null: false, foreign_key: true |

### Association
+ belongs_to :review