# LookBack

# アプリケーション概要
[![Image from Gyazo](https://i.gyazo.com/a300d271bc7a9ef491dda15ebf34b186.jpg)](https://gyazo.com/a300d271bc7a9ef491dda15ebf34b186)

# URL
+ https://look-back-36323.herokuapp.com/
# テスト用アカウント

# 利用方法

# 目指した課題解決

# 洗い出した要件

# 実装した機能

# 実装予定機能

# DB設計
[![Image from Gyazo](https://i.gyazo.com/c8ccc015e51b008c6ea84826682eb083.jpg)](https://gyazo.com/c8ccc015e51b008c6ea84826682eb083)

## users
| Column             | Type   | Options                   |
|--------------------|--------|---------------------------|
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| nickname           | string | null: false               |

### Association
+ has_many :subscriptions

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
| subscription   | references | null: false, foreign_key: true |

### Association
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


# ローカルでの動作
