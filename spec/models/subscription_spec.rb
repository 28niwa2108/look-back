require 'rails_helper'

RSpec.describe Subscription, type: :model do
  before do
    @subs = FactoryBot.build(:subscription)
  end

  context 'サブスクの登録ができるとき' do
    it '全てに正しい値が存在すれば登録できる' do
      expect(@subs).to be_valid
    end

    it 'nameが10文字以下なら登録できる' do
      @subs.name = 'abcdefghij'
      expect(@subs).to be_valid
    end

    it 'priceが数値なら登録できる' do
      @subs.price = 1234
      expect(@subs).to be_valid
    end

    it 'priceが0以上なら登録できる' do
      @subs.price = 0
      expect(@subs).to be_valid
    end

    it 'update_cycleが1~31の数値なら登録できる' do
      @subs.update_cycle = 25
      expect(@subs).to be_valid
    end

    it 'update_type_idが1~3の数値なら登録できる' do
      @subs.update_type_id = 2
      expect(@subs).to be_valid
    end

    it 'update_day_type_idが1~2の数値なら登録できる' do
      @subs.update_day_type_id = 1
      expect(@subs).to be_valid
    end

    it 'update_type_idが1なら、update_day_type_idが空でも登録できる' do
      @subs.update_type_id = 1
      @subs.update_day_type_id = ''
      expect(@subs).to be_valid
    end

    it '紐付けくuserが存在すれば登録できる' do
      expect(@subs.user).to be_truthy
      expect(@subs).to be_valid
    end
  end

  context 'type_is_dayメソッドが成功するとき' do
    it 'update_type_idが1なら、update_day_type_idのバリデーションが働かない' do
      @subs.update_type_id = 1
      expect(@subs.type_is_day).to eq(true)
      @subs.update_day_type_id = ''
      expect(@subs).to be_valid
    end

    it 'update_type_idが2(か3)なら、update_day_type_idのバリデーションが働く' do
      @subs.update_type_id = 2
      expect(@subs.type_is_day).to eq(false)
      @subs.update_day_type_id = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新日タイプは数値で入力してください')
    end

    it 'update_type_idが(2か)3なら、update_day_type_idのバリデーションが働く' do
      @subs.update_type_id = 3
      expect(@subs.type_is_day).to eq(false)
      @subs.update_day_type_id = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新日タイプは数値で入力してください')
    end
  end

  context 'サブスクの登録ができないとき' do
    it 'nameが空では登録できない' do
      @subs.name = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('サブスク名を入力してください')
    end

    it 'priceが空では登録できない' do
      @subs.price = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('価格を入力してください')
    end

    it 'contract_dateが空では登録できない' do
      @subs.contract_date = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約開始日を入力してください')
    end

    it 'update_cycleが空では登録できない' do
      @subs.update_cycle = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新サイクルを入力してください')
    end

    it 'update_type_idが空では登録できない' do
      @subs.update_type_id = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約タイプは数値で入力してください')
    end

    it 'update_type_idが2か3のとき、update_day_type_idが空では登録できない' do
      @subs.update_type_id = 3
      @subs.update_day_type_id = ''
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新日タイプは数値で入力してください')
    end

    it '紐づくユーザーが存在しなければ登録できない' do
      @subs.user = nil
      @subs.valid?
      expect(@subs.errors.full_messages).to include('Userを入力してください')
    end

    it 'nameが10文字超過では登録できない' do
      @subs.name = 'abcdefghijl'
      @subs.valid?
      expect(@subs.errors.full_messages).to include('サブスク名は10文字以内で入力してください')
    end

    it 'priceが数値以外では登録できない' do
      @subs.price = 'e'
      @subs.valid?
      expect(@subs.errors.full_messages).to include('価格は数値で入力してください')
    end

    it 'priceが0未満の数値では登録できない' do
      @subs.price = -1
      @subs.valid?
      expect(@subs.errors.full_messages).to include('価格は0以上の値にしてください')
    end

    it 'update_type_idが数値以外では登録できない' do
      @subs.update_type_id = 'e'
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約タイプは数値で入力してください')
    end

    it 'update_cycleが数値以外では登録できない' do
      @subs.update_cycle = 'e'
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新サイクルは数値で入力してください')
    end

    it 'update_cycleが1未満(31超過)では登録できない' do
      @subs.update_cycle = 0
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新サイクルは1以上の値にしてください')
    end

    it 'update_cycleが(1未満)31超過では登録できない' do
      @subs.update_cycle = 32
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新サイクルは31以下の値にしてください')
    end

    it 'update_type_idが1未満(3超過)では登録できない' do
      @subs.update_type_id = 0
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約タイプは1以上の値にしてください')
    end

    it 'update_type_idが(1未満)3超過では登録できない' do
      @subs.update_type_id = 4
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約タイプは3以下の値にしてください')
    end

    it 'update_type_idが1未満(3超過)では登録できない' do
      @subs.update_type_id = 0
      @subs.valid?
      expect(@subs.errors.full_messages).to include('契約タイプは1以上の値にしてください')
    end

    it 'update_type_idが2か3のとき、update_day_type_idが(1未満)2超過では登録できない' do
      @subs.update_type_id = 2
      @subs.update_day_type_id = 3
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新日タイプは2以下の値にしてください')
    end

    it 'update_type_idが2か3のとき、update_day_type_idが1未満(2超過)では登録できない' do
      @subs.update_type_id = 3
      @subs.update_day_type_id = 0
      @subs.valid?
      expect(@subs.errors.full_messages).to include('更新日タイプは1以上の値にしてください')
    end
  end
end
