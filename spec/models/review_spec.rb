require 'rails_helper'

RSpec.describe Review, type: :model do
  before do
    user = FactoryBot.create(:user)
    subscription = FactoryBot.create(:subscription)
    @review = FactoryBot.build(:review, user_id: user.id, subscription_id: subscription.id)
  end

  # 正常系テスト ------------------------------------
  context 'サブスク評価の保存ができるとき' do
    it '全てに正しい値が存在すれば保存できる' do
      expect(@review).to be_valid
    end

    it 'review_rateが1以上(5以下)の整数なら保存できる' do
      @review.review_rate = 1
      expect(@review).to be_valid
    end

    it 'review_rateが(1以上)5以下の整数なら保存できる' do
      @review.review_rate = 5
      expect(@review).to be_valid
    end

    it 'review_commentが300文字以下なら保存できる' do
      @review.review_comment = 'a' * 300
      expect(@review).to be_valid
    end

    it 'later_check_idが1か2なら保存できる' do
      @review.later_check_id = 1
      expect(@review).to be_valid
    end

    it 'later_check_idが1か2なら保存できる' do
      @review.later_check_id = 2
      expect(@review).to be_valid
    end

    it 'later_check_idが2なら、review_rateが空でも保存できる' do
      @review.later_check_id = 2
      @review.review_rate = nil
      expect(@review).to be_valid
    end

    it 'review_commentは空でも保存できる' do
      @review.later_check_id = 1
      @review.review_comment = ''
      expect(@review).to be_valid
    end

    it '紐づくUserがあれば保存できる' do
      expect(@review.user.nil?).to eq(false)
      expect(@review).to be_valid
    end

    it '紐づくSubscriptionがあれば保存できる' do
      expect(@review.subscription.nil?).to eq(false)
      expect(@review).to be_valid
    end
  end

  context 'type_is_laterメソッドが成功するとき' do
    it 'later_check_idが1なら、falseが返り、review_rateのバリデーションが機能する' do
      @review.later_check_id = 1
      @review.review_rate = nil
      expect(@review.type_is_later).to eq(false)
      @review.valid?
      expect(@review.errors.full_messages).to include('Review rateを入力してください', 'Review rateは数値で入力してください')
    end

    it 'later_check_idが2なら、trueが返り、review_rateのバリデーションは働かない' do
      @review.later_check_id = 2
      expect(@review.type_is_later).to eq(true)
      @review.review_rate = nil
      expect(@review).to be_valid
    end
  end

  context 'get_ave_rate_aveメソッドが成功するとき' do
    it '成功すると、review_rateの平均値が戻る' do
      reviews = []
      reviews << FactoryBot.create(:review, review_rate: 1)
      reviews << FactoryBot.create(:review, review_rate: 5)
      review_ave = Review.get_review_rate_ave(reviews)
      expect(review_ave).to eq(3)
    end

    it '☆評価がまだない場合は、nilが戻る' do
      reviews = []
      reviews << FactoryBot.create(:review, later_check_id: 2, review_rate: "")
      reviews << FactoryBot.create(:review, later_check_id: 2, review_rate: "")
      review_ave = Review.get_review_rate_ave(reviews)
      expect(review_ave).to eq(nil)
    end
  end

  # 異常系テスト ------------------------------------
  context 'サブスク評価の保存ができないとき' do
    it 'start_dateが空では保存できない' do
      @review.start_date = ''
      @review.valid?
      expect(@review.errors.full_messages).to include('Start dateを入力してください')
    end

    it 'end_dateが空では保存できない' do
      @review.end_date = ''
      @review.valid?
      expect(@review.errors.full_messages).to include('End dateを入力してください')
    end

    it 'later_check_idが空では保存できない' do
      @review.later_check_id = ''
      @review.valid?
      expect(@review.errors.full_messages).to include('Later checkを入力してください')
    end

    it '紐づくユーザーが存在しなければ保存できない' do
      @review.user = nil
      @review.valid?
      expect(@review.errors.full_messages).to include('Userを入力してください')
    end

    it '紐づくサブスクリプションが存在しなければ保存できない' do
      @review.subscription = nil
      @review.valid?
      expect(@review.errors.full_messages).to include('Subscriptionを入力してください')
    end

    it 'later_check_idが1のとき、review_rateが空では保存できない' do
      @review.later_check_id = 1
      @review.review_rate = ''
      @review.valid?
      expect(@review.errors.full_messages).to include('Review rateを入力してください')
    end

    it 'later_check_idが1のとき、review_rateは、1未満の数値では保存できない' do
      @review.later_check_id = 1
      @review.review_rate = 0
      @review.valid?
      expect(@review.errors.full_messages).to include('Review rateは1以上の値にしてください')
    end

    it 'later_check_idが1のとき、review_rateは、5超過の数値では保存できない' do
      @review.later_check_id = 1
      @review.review_rate = 6
      @review.valid?
      expect(@review.errors.full_messages).to include('Review rateは5以下の値にしてください')
    end

    it 'review_commentは、300文字超過では保存できない' do
      @review.review_comment = 'あ' * 301
      @review.valid?
      expect(@review.errors.full_messages).to include('Review commentは300文字以内で入力してください')
    end

    it 'later_check_idが1未満では保存できない' do
      @review.later_check_id = 0
      @review.valid?
      expect(@review.errors.full_messages).to include('Later checkは1以上の値にしてください')
    end

    it 'later_check_idが2超過では保存できない' do
      @review.later_check_id = 3
      @review.valid?
      expect(@review.errors.full_messages).to include('Later checkは2以下の値にしてください')
    end
  end
end
