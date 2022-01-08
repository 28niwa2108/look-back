# LookBack
# アプリケーション概要
小さな行動につなげるための、サブスク管理アプリ。
+ サブスク情報を一括管理
+ 累計金額・契約期間等、サブスク情報の閲覧
+ 活用度の振り返り・アクションプラン設定
<br>

[![Image from Gyazo](https://i.gyazo.com/0eda3935761b54259610e4c2dda8339b.png)](https://gyazo.com/0eda3935761b54259610e4c2dda8339b)
<br>
<br>

# 動作環境
## URL
+ https://look-back-36323.herokuapp.com/<br>
追加機能実装によるデプロイ等で、接続できないタイミングがございます。<br>
少し置いてからのアクセスをお願いします。
<br>

## BASIC認証
+ ID      ： admin 
+ Password： 36323 
<br>

## テスト用アカウント
+ Email   ： test@email.com
+ Password： test123
<br>
<br>

# 制作背景
## 対象
+ 自己投資目的で、サブスクに課金している人
+ いろいろなサブスクを試している人
+ サブスクの契約を継続すべきか迷う人
<br>

## 解決したい事
+ 登録したものの、あまり活用できていないサブスクがある状態
+ 行動の伴わない受動的な活用にとどまる状態
+ 自分にとって有用な支払いか、判断しかねる状態
<br>

## 機能の実装背景
+ 振り返る<br>
  - 実装例）アクションプラン設定
  - 有益な情報も、インプットしただけでは自己成長につながりにくい。<br>
情報を実際に活用することで、自分の目標へ近づくことができる。<br>
実際の「行動」につなげるために、振り返り、何を実行するか決める事が必要だと考えた。<br>

+ 手軽さ<br>
  - 実装例）☆での簡易評価
  - 半年間のプログラミング学習中、学習後に振り返りを記入する時間を設けていた。<br>
ほんの少しの改善や工夫が問題を解決したり、<br>
振り返りを記入している間に、何が問題か気づく事があった。<br>
大体的でなくとも、振り返る「きっかけ」があれば、現状の改善につながり、<br>
簡易な方法であれば習慣化しやすいと実感した。<br>


+ 気づく<br>
  - 実装例）累計課金額・期間
  - 毎月の金額では妥当と感じていても、年間支払金額を見ると印象が変わる経験があった。<br>
また、コンテンツが良いか悪いかという判断軸だけでなく、<br>
実際にどんなときに役立ったか・いつ活用したか？と考えることで、<br>
有益な支払いかどうか判断しやすくなると気づいた。<br>
<br>

# 洗い出した要件
+ ユーザー管理機能
  - ユーザーごとにサブスク情報を管理するため
+ ユーザー編集機能
  - ユーザー情報を修正するため(未実装)
+ ユーザー削除機能
  - ユーザー登録を削除するため(未実装)
+ サブスク登録機能
  - 管理するサブスクを登録するため
+ サブスク一覧表示機能
  - 登録済のサブスクを確認するため
+ サブスク詳細機能
  - 登録したサブスクの情報を閲覧するため
+ サブスク編集機能
  - 登録したサブスクの情報を訂正するため
+ サブスク削除機能
  - 登録したサブスクを削除するため
+ サブスク更新機能
  - サブスクの更新日に累計金額・期間を更新するため
+ サブスク評価機能
  - サブスクの振り返りを行うため
+ サブスク評価一覧表示機能
  - 登録した振り返り情報を表示するため
+ サブスク評価詳細表示機能
  - 登録した振り返り情報を確認するため
+ サブスク評価編集機能
  - 登録した振り返り情報を訂正するため
+ サブスク未評価一覧表示機能
  - 振り返り待ちの評価を一覧で表示するため
+ サブスク解約機能
  - サブスクの更新を停止するため
+ 解約サブスク一覧表示機能
  - 解約したサブスクを確認するため
+ 解約サブスク詳細表示機能
  - 解約理由を閲覧するため
+ 再開機能
  - 解約済のサブスクを再度契約状態にするため(未実装)
+ 更新通知機能
  - サブスク更新日・振り返りをリマインドするため(未実装)
+ アクション記録機能
  - 実行したアクションプランを記録するため(未実装)
+ エクセル出力機能
  - サブスク情報を出力し、より分析するため(未実装)
+ 問い合わせ機能
  - エラー等を問い合わせるため(未実装)
<br>
<br>

# 実装した機能・利用方法
[![Image from Gyazo](https://i.gyazo.com/f6eb5101c47756a302ff576dfd88ace2.png)](https://gyazo.com/f6eb5101c47756a302ff576dfd88ace2)
<br>

## 画面遷移図
[![Image from Gyazo](https://i.gyazo.com/d1d5405ef30f85527eed2908124c22ec.png)](https://gyazo.com/d1d5405ef30f85527eed2908124c22ec)
<br>

## ユーザー登録機能
[![Image from Gyazo](https://i.gyazo.com/e4c31b1f276d5ca93d582bf084590b36.gif)](https://gyazo.com/e4c31b1f276d5ca93d582bf084590b36)
+ トップページで、sign upをクリック
+ 必要事項を入力し、Createをクリック
<br>

## ログイン機能
+ ヘッダーのLoginをクリック
+ 必要事項を入力し、Loginをクリック
<br>

## ログアウト機能
+ ヘッダーのLogoutをクリック
<br>

## サブスク登録機能
[![Image from Gyazo](https://i.gyazo.com/295f8517208ba5dd4d0d2a3194c669b6.gif)](https://gyazo.com/295f8517208ba5dd4d0d2a3194c669b6)
+ マイページで、Addをクリック
+ 必要事項を入力・選択し、登録するをクリック
<br>

## サブスク編集機能
[![Image from Gyazo](https://i.gyazo.com/337856d1349270bf7256c259deef0d27.gif)](https://gyazo.com/337856d1349270bf7256c259deef0d27)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、編集をクリック
+ 必要事項を入力・選択し、更新するをクリック
+ 確認ホップアップが表示されるので、OKをクリック
+ 更新完了のホップアップが表示されるので、OKをクリック
<br>

## サブスク削除機能
[![Image from Gyazo](https://i.gyazo.com/828413e1db5968bdb095fa7ae7995361.gif)](https://gyazo.com/828413e1db5968bdb095fa7ae7995361)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、削除をクリック
+ 確認ホップアップが表示されるので、OKをクリック
+ 削除完了のホップアップが表示されるので、OKをクリック
<br>

## サブスク一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/371870f47d6d04aff7b3a90661f57dca.png)](https://gyazo.com/371870f47d6d04aff7b3a90661f57dca)
+ マイページトップ(Listsタブ)で、契約中のサブスク一覧が確認できる
<br>

## サブスク詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/fdf88dab4895e4958d1d71ddc7cda437.gif)](https://gyazo.com/fdf88dab4895e4958d1d71ddc7cda437)
+ マイページで、サブスクのカードをクリック
+ サブスク情報を確認できる
<br>

## サブスク更新機能
[![Image from Gyazo](https://i.gyazo.com/a388aeb55b759029b0dc3ccecf553ae4.gif)](https://gyazo.com/a388aeb55b759029b0dc3ccecf553ae4)
+ サブスク更新日になると、通知アイコンが表示される
+ 次回更新日がClickで更新に変化する
+ Clickで更新をクリック
+ 更新完了後、振り返りを促すホップアップが表示されるので、Goをクリック
<br>

[![Image from Gyazo](https://i.gyazo.com/3a26bf91480dfc07a49ccf7ce049d922.png)](https://gyazo.com/3a26bf91480dfc07a49ccf7ce049d922)
+ 更新完了後のホップアップで、後で振り返るをクリックし、後で振り返ることも可能
<br>

## サブスク評価機能
[![Image from Gyazo](https://i.gyazo.com/be824e4fdaed1fbc7c5124f262990728.gif)](https://gyazo.com/be824e4fdaed1fbc7c5124f262990728)
+ サブスク更新後に表示される画面に、必要事項を入力する
+ レビューをクリック
<br>

[![Image from Gyazo](https://i.gyazo.com/16fd7f4c93498d68b4aeca4a6077cd1e.gif)](https://gyazo.com/16fd7f4c93498d68b4aeca4a6077cd1e)
+ 後で振り返るをONにすると、現在の入力を一時保存できる
<br>

## サブスク評価一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/ae690605373fa767773fe33081877418.gif)](https://gyazo.com/ae690605373fa767773fe33081877418)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 過去のレビュー 一覧が確認できる
<br>

## サブスク評価詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/b8bdead730ce15e99769f8ee95126a88.gif)](https://gyazo.com/b8bdead730ce15e99769f8ee95126a88)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 閲覧したいレビューのカードのLook More→をクリック
+ 入力したレビューの詳細を確認できる
<br>

## サブスク評価編集機能
[![Image from Gyazo](https://i.gyazo.com/1a23fd0b73168212ca8febea8169dcef.gif)](https://gyazo.com/1a23fd0b73168212ca8febea8169dcef)
+ マイページで、サブスクのカードをクリック
+ Reviewのもっと見る→をクリック
+ 閲覧したいレビューのカードのLook More→をクリック
+ Editをクリック
+ 必要事項を入力して、レビューをクリック
<br>

## サブスク未評価一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/93c491d63a12cc4efe8491f0f1d700cc.png)](https://gyazo.com/93c491d63a12cc4efe8491f0f1d700cc)
+ マイページで、Reviewsタブをクリック
+ 後で振り返るをONにしているレビュー 一覧を確認できる
<br>

## サブスク解約機能
[![Image from Gyazo](https://i.gyazo.com/059109baa76c6104b59683a86f2ceeaf.gif)](https://gyazo.com/059109baa76c6104b59683a86f2ceeaf)
+ マイページで、サブスクのハンバーガーメニューをクリック
+ メニューから、解約をクリック
+ 必要事項を入力・選択し、解約するをクリック
<br>

## 解約サブスク一覧表示機能
[![Image from Gyazo](https://i.gyazo.com/4f8ff2438192f624db7d1893dd805cf9.png)](https://gyazo.com/4f8ff2438192f624db7d1893dd805cf9)
+ マイページで、Cancelsタブをクリック
+ 解約済のサブスク一覧を確認できる
<br>

## 解約サブスク詳細表示機能
[![Image from Gyazo](https://i.gyazo.com/d714df7f13ff7e951bd53556c73e3041.gif)](https://gyazo.com/d714df7f13ff7e951bd53556c73e3041)
+ マイページで、Cancelsタブをクリック
+ 閲覧したいサブスクカードをクリック
+ サブスク詳細ページに解約理由が表示される
<br>
<br>

# 工夫した点
+ サブスク管理機能に振り返り機能を加え、サブスクの活用を保証する設計にした
+ 振り返り項目でアクションプランを必須にし、行動を促す仕様にした
+ ☆評価で手軽な評価を実現し、振り返りを継続するハードルを下げる仕様にした
+ 更新待ちのサブスクには通知アイコンを付け、目立たせた
+ 実際のサブスクに対応できるように、契約プランを充実させた
  - 年、月、日のタイプを選択可能
  - 年、月の場合は、契約日更新かor毎月(毎年)1日更新か、選択可能
+ サブスク登録時、契約開始日が過去の場合にも対応した
  - 契約開始日〜登録当日までの累計金額・契約期間が保存される仕様
+ 利用しやすいUIを心がけて設計した
  - レスポンシブ対応
  - 感覚的な操作ができるように、アイコン、hoverイベントを使用
  - サブスク登録時、自動で当日の日付が入る(カレンダー選択不要)
  - ハンバーガーメニューから、ワンクリックで編集・削除・解約操作ができる
  - 後で振り返る機能を利用し、内容の一時保存ができる
  - 複数のサブスクで「後で振り返るレビュー」が存在しても、未評価一覧から処理できる
+ 気づきを得るきっかけとなる様、様々な角度の情報を表示した
  - サブスク契約金額だけでなく、累計金額・期間を表示
  - 解約理由・コメントを残すことで、自分の判断を見返す事が可能
  - サブスク☆評価の平均を表示することで、ロングスパンでの評価も確認可能
+ 実際の開発を意識したアプリケーション作成を心がけた
    + プルリクエストでWhat, Whyを記述
    + プルリクエスト前に、単体テスト・RuboCopの実行
    + 要件定義、画面遷移図を作成後実装開始
<br>
<br>

# 課題・実装予定機能
## 課題及び解決方法
+ サブスク名が短いため、maxlengthの変更及び、モデル単体テストの修正
+ モデル単体テストにおいて、モデルに定義したメソッドの異常系テストを実装・実行し、品質を担保
+ コントローラー単体テストを実装・実行し、品質を担保
+ 結合テストを実装・実行し、品質を担保
+ エラーメッセージの不自然な日本語を修正
+ エラーメッセージ変更に伴う、モデル単体テストの修正・実行
+ 繰り返しの記述、冗長な表現などコード改善(リファクタリング)
+ 解約済のサブスク編集機能を制限する
+ 解約日が、更新日・契約日より前の日付の場合、確認ホップアップを表示
+ リンクの仮urlを更新
  - サブスク削除ホップアップ：解約リンク
  - サブスク編集画面：契約日を変更するリンク
+ 画面遷移図の修正
+ エラー等を連絡するコンタクトフォームの作成
<br>

## 実装予定機能
+ 上記課題の解消
+ ビューレイアウトの改善
  - ユーザー名をマイページに表示する
  - サブスク登録数が0の時のマイページレイアウトを変更
  - トップページの作り込み
  - サブスク詳細、評価詳細ページの作り込み
  - 各フォームのレイアウト調整
  - ビュー全体でテイストを統一
+ ユーザー編集機能
+ ユーザー削除機能
+ サブスク登録時に、Javascriptで説明を表示する
+ サブスク評価入力時に、前回の評価をJavascriptで表示する
<br>
<br>

# 使用技術(開発環境)
+ バックエンド
  - Ruby, Ruby on Rails

+ フロントエンド
  - HTML, CSS, tailwindcss, JavaScript, JQuery, Ajax

+ データベース
  - MySQL, Sequel Pro

+ 本番環境
  - Heroku

+ ソース管理
  - GitHub, GitHub Desktop

+ テスト
  - RSpec

+ エディタ
  - Visual Studio Code
<br>
<br>

# DB設計
[![Image from Gyazo](https://i.gyazo.com/08ae366ae3bad47dc1baa54211e9e34d.png)](https://gyazo.com/08ae366ae3bad47dc1baa54211e9e34d)
<br>

## users
| Column             | Type   | Options                   |
|--------------------|--------|---------------------------|
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| nickname           | string | null: false               |

### Association
+ has_many :subscriptions
+ has_many :reviews
<br>

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
<br>

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
<br>

## contract_cancels
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| cancel_date    | date       | null: false                    |
| reason_id      | integer    | null: false                    |
| cancel_comment | text       |                                |
| subscription   | references | null: false, foreign_key: true |

### Association
+ belongs_to :subscription
<br>

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
<br>

## action_plans
| Column                | Type       | Options                        |
|-----------------------|------------|--------------------------------|
| action_rate           | integer    |                                |
| action_review_comment | text       |                                |
| action_plan           | text       |                                |
| review                | references | null: false, foreign_key: true |

### Association
+ belongs_to :review