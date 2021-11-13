# LookBack

# アプリケーション概要
[![Image from Gyazo](https://i.gyazo.com/1d884a89bca2f4312676f0638b4cd5b0.png)](https://gyazo.com/1d884a89bca2f4312676f0638b4cd5b0)

# URL
+ https://look-back-36323.herokuapp.com/
# テスト用アカウント

# 利用方法

# 目指した課題解決

# 洗い出した要件

# 実装した機能

# 実装予定機能

# DB設計
[![Image from Gyazo](https://i.gyazo.com/4d432a34b9d9400b79c24271c1466774.jpg)](https://gyazo.com/4d432a34b9d9400b79c24271c1466774)
## users
| Column             | Type   | Options                   |
|--------------------|--------|---------------------------|
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| nickname           | string | null: false               |

### Association
+ has_many :subscriptions

## subscriptions
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| name           | string     | null: false                    |
| price          | integer    | null: false                    |
| contact_date   | date       | null: false                    |
| update_type_id | integer    | null: false                    |
| update_cycle   | integer    | null: false                    |
| user           | references | null: false, foreign_key: true |

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
| next_update_date | date       | null: false                    |
| subscription     | references | null: false, foreign_key: true |
+ belongs_to :subscription


## contract_cancels
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| cancel_date    | date       | null: false                    |
| reason_id      | integer    | null: false                    |
| cancel_comment | text       |                                |
| subscription   | references | null: false, foreign_key: true |
+ belongs_to :subscription


## reviews
| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| review_rate    | float      | null: false                    |
| review_comment | text       |                                |
| subscription   | references | null: false, foreign_key: true |
+ belongs_to :subscription
+ has_one :action_plan


## action_plans
| Column               | Type       | Options                        |
|----------------------|------------|--------------------------------|
| action_rate          | float      | null: false                    |
| action_review_comment| text       |                                |
| action_plan          | text       | null: false                    |
| review               | references | null: false, foreign_key: true |
+ belongs_to :review


# ローカルでの動作
