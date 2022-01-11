require 'rails_helper'

RSpec.describe ReviewAction, type: :model do
  before do
    review = FactoryBot.create(:review)
    @review_action = FactoryBot.build(
      :review_action,
      user_id: review.user.id,
      subscription_id: review.subscription.id,
      review_id: review.id
    )
  end

  # 正常系テスト ------------------------------------
  context '振り返りの変更が保存できるとき' do
    it '全てに正しい値が存在すれば保存できる' do
      expect(@review_action).to be_valid
    end

    it 'review_rateが1以上(5以下)の整数なら保存できる' do
      @review_action.review_rate = 1
      expect(@review_action).to be_valid
    end

    it 'review_rateが(1以上)5以下の整数なら保存できる' do
      @review_action.review_rate = 5
      expect(@review_action).to be_valid
    end

    it 'review_commentが300文字以下なら保存できる' do
      @review_action.review_comment = 'a' * 300
      expect(@review_action).to be_valid
    end

    it 'later_check_idが1か2なら保存できる' do
      @review_action.later_check_id = 1
      expect(@review_action).to be_valid
    end

    it 'later_check_idが1か2なら保存できる' do
      @review_action.later_check_id = 2
      expect(@review_action).to be_valid
    end

    it 'later_check_idが2なら、review_rateが空でも保存できる' do
      @review_action.later_check_id = '2'
      @review_action.review_rate = nil
      expect(@review_action).to be_valid
    end

    it 'review_commentは空でも保存できる' do
      @review_action.later_check_id = '1'
      @review_action.review_comment = ''
      expect(@review_action).to be_valid
    end

    it 'action_rateが1以上(5以下)の整数なら保存できる' do
      @review_action.action_rate = 1
      expect(@review_action).to be_valid
    end

    it 'action_rateが(1以上)5以下の整数なら保存できる' do
      @review_action.action_rate = 5
      expect(@review_action).to be_valid
    end

    it 'action_planが300文字以下なら保存できる' do
      @review_action.action_plan = 'a' * 300
      expect(@review_action).to be_valid
    end

    it 'action_review_commentが300文字以下なら保存できる' do
      @review_action.action_review_comment = 'a' * 300
      expect(@review_action).to be_valid
    end

    it 'action_review_commentは空でも保存できる' do
      @review_action.later_check_id = '1'
      @review_action.action_review_comment = ''
      expect(@review_action).to be_valid
    end

    it 'later_check_idが2なら、action_rateが空でも保存できる' do
      @review_action.later_check_id = '2'
      @review_action.action_rate = nil
      expect(@review_action).to be_valid
    end

    it 'later_check_idが2なら、action_planが空でも保存できる' do
      @review_action.later_check_id = '2'
      @review_action.action_plan = ''
      expect(@review_action).to be_valid
    end
  end

  context 'type_is_laterメソッドが成功するとき' do
    it 'later_check_idが1なら、falseが返り、review_rateのバリデーションが機能する' do
      @review_action.later_check_id = '1'
      @review_action.review_rate = nil
      expect(@review_action.type_is_later).to eq(false)
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('サブスク☆レビューを選択してください')
    end

    it 'later_check_idが1なら、falseが返り、action_rateのバリデーションが機能する' do
      @review_action.later_check_id = '1'
      @review_action.action_rate = nil
      expect(@review_action.type_is_later).to eq(false)
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプラン☆レビューを選択してください')
    end

    it 'later_check_idが1なら、falseが返り、action_planのバリデーションが機能する' do
      @review_action.later_check_id = '1'
      @review_action.action_plan = ''
      expect(@review_action.type_is_later).to eq(false)
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプランを入力してください')
    end

    it 'later_check_idが2なら、trueが返り、バリデーションは働かない' do
      @review_action.later_check_id = '2'
      expect(@review_action.type_is_later).to eq(true)
      @review_action.review_rate = nil
      @review_action.action_rate = nil
      @review_action.action_plan = ''
      expect(@review_action).to be_valid
    end
  end

  context 'saveメソッドが成功するとき' do
    it 'Reviewレコードが保存される' do
      expect { @review_action.save }.to change { Review.count }.by(1)
    end

    it ' ActionPlanレコードが保存される' do
      expect { @review_action.save }.to change { ActionPlan.count }.by(1)
    end
  end

  context 'updateメソッドが成功するとき' do
    it 'Reviewレコードが更新される' do
      action = FactoryBot.create(:action_plan)
      # 更新前のレビューid、レビューコメント
      before_review_id = action.review.id
      first_comment = action.review.review_comment
      # 更新するコメントが現在のコメントと異なる事を確認
      expect(first_comment).not_to eq('更新後コメント')

      review_action = ReviewAction.new(
        review_rate: action.review.review_rate,
        review_comment: '更新後コメント',
        start_date: action.review.start_date,
        end_date: action.review.end_date,
        later_check_id: action.review.later_check_id,
        user_id: action.review.user_id,
        subscription_id: action.review.subscription_id,
        action_rate: action.action_rate,
        action_review_comment: action.action_review_comment,
        action_plan: action.action_plan,
        review_id: action.review_id
      )
      # 更新するレビューのidを確認
      expect(review_action.review_id).to eq(before_review_id)

      # 更新後、レビューモデルのカウント、レビューidが変わりないことを確認
      expect { review_action.update }.to change { Review.count }.by(0)
      expect(review_action.review_id).to eq(before_review_id)
      # コメントが更新されたことを確認
      expect(review_action.review_comment).to eq('更新後コメント')
    end

    it ' ActionPlanレコードが更新される' do
      action = FactoryBot.create(:action_plan)
      # 更新前のアクションプランレコードid、action_plan
      before_action_id = action.id
      first_plan = action.action_plan
      # 更新するアクションプランが現在のアクションプランと異なる事を確認
      expect(first_plan).not_to eq('更新後のアクションプラン')

      review_action = ReviewAction.new(
        review_rate: action.review.review_rate,
        review_comment: action.review.review_comment,
        start_date: action.review.start_date,
        end_date: action.review.end_date,
        later_check_id: action.review.later_check_id,
        user_id: action.review.user_id,
        subscription_id: action.review.subscription_id,
        action_rate: action.action_rate,
        action_review_comment: action.action_review_comment,
        action_plan: '更新後のアクションプラン',
        review_id: action.review_id
      )
      # 更新するレビューのidを確認
      before_action = ActionPlan.find_by(review_id: review_action.review_id)
      expect(before_action.id).to eq(before_action_id)

      # 更新後、レビューモデルのカウント、レビューidが変わりないことを確認
      expect { review_action.update }.to change { ActionPlan.count }.by(0)
      after_action = ActionPlan.find_by(review_id: review_action.review_id)
      expect(after_action.id).to eq(before_action_id)
      # コメントが更新されたことを確認
      expect(review_action.action_plan).to eq('更新後のアクションプラン')
    end
  end

  # 異常系テスト ------------------------------------
  context '振り返りの変更が保存ができないとき' do
    it 'start_dateが空では保存できない' do
      @review_action.start_date = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Start dateを入力してください')
    end

    it 'end_dateが空では保存できない' do
      @review_action.end_date = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('End dateを入力してください')
    end

    it 'later_check_idが空では保存できない' do
      @review_action.later_check_id = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Later checkを入力してください', 'Later checkは数値で入力してください')
    end

    it '紐づくユーザーが存在しなければ保存できない' do
      @review_action.user_id = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Userを入力してください')
    end

    it '紐づくサブスクリプションが存在しなければ保存できない' do
      @review_action.subscription_id = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Subscriptionを入力してください')
    end

    it 'later_check_idが1のとき、review_rateが空では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.review_rate = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('サブスク☆レビューを選択してください')
    end

    it 'later_check_idが1のとき、review_rateは、1未満の数値では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.review_rate = 0
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('サブスク☆レビューを選択してください')
    end

    it 'later_check_idが1のとき、review_rateは、5超過の数値では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.review_rate = 6
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('サブスク☆レビューを選択してください')
    end

    it 'review_commentは、300文字超過では保存できない' do
      @review_action.review_comment = 'あ' * 301
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('サブスク振り返りコメントは300文字以内で入力してください')
    end

    it 'later_check_idが1未満では保存できない' do
      @review_action.later_check_id = 0
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Later checkは1以上の値にしてください')
    end

    it 'later_check_idが2超過では保存できない' do
      @review_action.later_check_id = 3
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Later checkは2以下の値にしてください')
    end

    it '紐づくレビューが存在しなければ保存できない' do
      @review_action.review_id = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('Reviewを入力してください')
    end

    it 'later_check_idが1のとき、action_rateが空では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.action_rate = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプラン☆レビューを選択してください')
    end

    it 'reviewのlater_check_idが1のとき、action_rateが1未満では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.action_rate = 0
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプラン☆レビューを選択してください')
    end

    it 'reviewのlater_check_idが1のとき、action_rateが5超過では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.action_rate = 6
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプラン☆レビューを選択してください')
    end

    it 'reviewのlater_check_idが1のとき、action_planが空では保存できない' do
      @review_action.later_check_id = '1'
      @review_action.action_plan = ''
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプランを入力してください')
    end

    it 'action_planは、300文字超過では保存できない' do
      @review_action.action_plan = 'あ' * 301
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクションプランは300文字以内で入力してください')
    end

    it 'action_review_commentは、300文字超過では保存できない' do
      @review_action.action_review_comment = 'a' * 301
      @review_action.valid?
      expect(@review_action.errors.full_messages).to include('アクション振り返りコメントは300文字以内で入力してください')
    end
  end
end
