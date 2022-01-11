require 'rails_helper'

RSpec.describe ContractCancel, type: :model do
  before do
    @cancel = FactoryBot.build(:contract_cancel)
  end

  # 正常系テスト ------------------------------------
  context '解約データの保存ができるとき' do
    it '全てに正しい値が存在すれば保存できる' do
      expect(@cancel).to be_valid
    end

    it 'reason_idが1以上(6以下)の整数なら保存できる' do
      @cancel.reason_id = 1
      expect(@cancel).to be_valid
    end

    it 'reason_idが(1以上)6以下の整数なら保存できる' do
      @cancel.reason_id = 6
      expect(@cancel).to be_valid
    end

    it 'cancel_commentが300字以下なら保存できる' do
      @cancel.cancel_comment = 'あ' * 300
      expect(@cancel).to be_valid
    end

    it 'cancel_commentは、空でも保存できる' do
      @cancel.cancel_comment = ''
      expect(@cancel).to be_valid
    end

    it '紐づくSubscriptionがあれば保存できる' do
      expect(@cancel.subscription.nil?).to eq(false)
      expect(@cancel).to be_valid
    end
  end

  # 異常系テスト ------------------------------------
  context '解約データの保存ができないとき' do
    it 'cancel_dateが空では保存できない' do
      @cancel.cancel_date = ''
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約日を入力してください')
    end

    it 'reason_idが空では保存できない' do
      @cancel.reason_id = nil
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約理由を入力してください', '解約理由を選択してください')
    end

    it '紐づくSubscriptionが存在しなければ保存できない' do
      @cancel.subscription = nil
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('Subscriptionを入力してください')
    end

    it 'reason_idが数値以外では登録できない' do
      @cancel.reason_id = 'e'
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約理由を選択してください')
    end

    it 'reason_idが1未満の数値では登録できない' do
      @cancel.reason_id = 0
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約理由を選択してください')
    end

    it 'reason_idが6超過の数値では登録できない' do
      @cancel.reason_id = 7
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約理由を選択してください')
    end

    it 'cancel_commentが300字超過では保存できない' do
      @cancel.cancel_comment = 'a' * 301
      @cancel.valid?
      expect(@cancel.errors.full_messages).to include('解約メモは300文字以内で入力してください')
    end
  end
end
