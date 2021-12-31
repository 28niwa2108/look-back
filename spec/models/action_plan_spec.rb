require 'rails_helper'

RSpec.describe ActionPlan, type: :model do
  before do
    review = FactoryBot.create(:review)
    @action_plan = FactoryBot.build(:action_plan, review_id: review.id)
  end

  # 正常系テスト ------------------------------------
  context 'アクションプラン評価の保存ができるとき' do
    it '全てに正しい値が存在すれば保存できる' do
      expect(@action_plan).to be_valid
    end

    it 'action_rateが1以上(5以下)の整数なら保存できる' do
      @action_plan.action_rate = 1
      expect(@action_plan).to be_valid
    end

    it 'action_rateが(1以上)5以下の整数なら保存できる' do
      @action_plan.action_rate = 5
      expect(@action_plan).to be_valid
    end

    it 'action_planが300文字以下なら保存できる' do
      @action_plan.action_plan = 'a' * 300
      expect(@action_plan).to be_valid
    end

    it 'action_review_commentが300文字以下なら保存できる' do
      @action_plan.action_review_comment = 'a' * 300
      expect(@action_plan).to be_valid
    end

    it 'action_review_commentは空でも保存できる' do
      @action_plan.review.later_check_id = 1
      @action_plan.action_review_comment = ''
      expect(@action_plan).to be_valid
    end

    it '紐づくreviewのlater_check_idが2なら、action_rateが空でも保存できる' do
      @action_plan.review.later_check_id = 2
      @action_plan.action_rate = nil
      expect(@action_plan).to be_valid
    end

    it '紐づくreviewのlater_check_idが2なら、action_planが空でも保存できる' do
      @action_plan.review.later_check_id = 2
      @action_plan.action_plan = ''
      expect(@action_plan).to be_valid
    end

    it '紐づくReviewがあれば保存できる' do
      expect(@action_plan.review.nil?).to eq(false)
      expect(@action_plan).to be_valid
    end
  end

  context 'review_type_is_laterメソッドが成功するとき' do
    it '紐づくreviewのlater_check_idが1なら、falseが返り、バリデーションが機能する' do
      @action_plan.review.later_check_id = 1
      expect(@action_plan.review_type_is_later).to eq(false)
      @action_plan.action_rate = nil
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action rateを入力してください', 'Action rateは数値で入力してください')
    end

    it '紐づくreviewのlater_check_idが1なら、falseが返り、バリデーションが機能する' do
      @action_plan.review.later_check_id = 1
      expect(@action_plan.review_type_is_later).to eq(false)
      @action_plan.action_plan = ''
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action planを入力してください')
    end

    it 'later_check_idが2なら、trueが返り、action_plan_rateのバリデーションは働かない' do
      @action_plan.review.later_check_id = 2
      expect(@action_plan.review_type_is_later).to eq(true)
      @action_plan.action_rate = nil
      @action_plan.action_plan = ''
      expect(@action_plan).to be_valid
    end
  end

  # 異常系テスト ------------------------------------
  context 'アクションプラン評価の保存ができないとき' do
    it '紐づくレビューが存在しなければ保存できない' do
      @action_plan.review_id = ''
      expect { @action_plan.valid? }.to raise_error(NoMethodError)
    end

    it '紐づくreviewのlater_check_idが1のとき、action_rateが空では保存できない' do
      @action_plan.review.later_check_id = 1
      @action_plan.action_rate = ''
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action rateを入力してください')
    end

    it '紐づくreviewのlater_check_idが1のとき、action_rateが1未満では保存できない' do
      @action_plan.review.later_check_id = 1
      @action_plan.action_rate = 0
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action rateは1以上の値にしてください')
    end

    it '紐づくreviewのlater_check_idが1のとき、action_rateが5超過では保存できない' do
      @action_plan.review.later_check_id = 1
      @action_plan.action_rate = 6
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action rateは5以下の値にしてください')
    end

    it '紐づくreviewのlater_check_idが1のとき、action_planが空では保存できない' do
      @action_plan.review.later_check_id = 1
      @action_plan.action_plan = ''
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action planを入力してください')
    end

    it 'action_planは、300文字超過では保存できない' do
      @action_plan.action_plan = 'あ' * 301
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action planは300文字以内で入力してください')
    end

    it 'action_review_commentは、300文字超過では保存できない' do
      @action_plan.action_review_comment = 'a' * 301
      @action_plan.valid?
      expect(@action_plan.errors.full_messages).to include('Action review commentは300文字以内で入力してください')
    end
  end
end
