require 'rails_helper'

RSpec.describe ContractRenewal, type: :model do
  before do
    @renewal = FactoryBot.build(:contract_renewal)
  end

  # 正常系テスト ------------------------------------
  context '契約更新の保存ができるとき' do
    it '全てに正しい値が存在すれば保存できる' do
      expect(@renewal).to be_valid
    end

    it 'renewal_countが0以上の整数なら保存できる' do
      @renewal.renewal_count = 0
      expect(@renewal).to be_valid
    end

    it 'total_priceが0以上の整数なら保存できる' do
      @renewal.total_price = 1000
      expect(@renewal).to be_valid
    end

    it 'total_periodが0以上の整数なら保存できる' do
      @renewal.total_period = 30
      expect(@renewal).to be_valid
    end

    it '紐づくSubscriptionがあれば保存できる' do
      expect(@renewal.subscription.nil?).to eq(false)
      expect(@renewal).to be_valid
    end
  end

  context 'get_total_periodメソッドが成功するとき' do
    it '次回更新日(第2引数)から、契約日(第1引数)を減算した合計契約期間が数値で返る' do
      # 契約日、更新日の用意
      contract_date = Date.new(2021, 12, 1)
      update_date = Date.new(2022, 1, 1)
      # テスト対象のメソッド呼び出し
      contract_period = @renewal.get_total_period(contract_date, update_date)
      # 戻り地が数値か、減算結果と等しいか確認
      expect(contract_period.integer?).to eq(true)
      expect(contract_period).to eq(31)
    end
  end

  context '「日」更新：update_type_idが1のとき' do
    context 'get_update_dateメソッドが成功するとき' do
      it '更新日(第2引数)に、update_cycle日分加算された日付が返る' do
        # 前提条件のセット(月更新、月初タイプ)
        @renewal.subscription.update_type_id = 1
        # 更新サイクルを「20日」に
        @renewal.subscription.update_cycle = 20
        # 更新日を「2022/1/1」に
        date = Date.new(2022, 1, 1)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.get_update_date(@renewal.subscription, date)
        # 戻り値の月が、20日後の「2022年1月21日」か確認
        result = Date.new(2022, 1, 21)
        expect(update_date).to eq(result)
      end
    end
  end

  context '「月」更新：update_type_idが2のとき' do
    context 'day_type_diagnoseメソッドが成功するとき' do
      it '「月初更新」(update_day_type_idが1)のとき、第2引数の日付の日にちが「1日」に変更されて戻る' do
        # 前提条件のセット(月更新、月初タイプ)
        @renewal.subscription.update_type_id = 2
        @renewal.subscription.update_day_type_id = 1
        # 1日ではない更新日を用意
        date = Date.new(2022, 1, 12)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.day_type_diagnose(@renewal.subscription, date)
        # 戻り値の日にちが、「2022年1月1日」になっているか確認
        result = Date.new(2022, 1, 1)
        expect(update_date).to eq(result)
      end

      it '「契約日更新」(update_day_type_idが2)のとき、第2引数の日付がそのまま返る' do
        # 前提条件のセット(月更新、月初タイプ)
        @renewal.subscription.update_type_id = 2
        @renewal.subscription.update_day_type_id = 2
        # 1日ではない更新日を用意
        date = Date.new(2022, 1, 12)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.day_type_diagnose(@renewal.subscription, date)
        # 戻り値の日にちが、dateと同じか確認
        expect(update_date).to eq(date)
      end
    end

    context 'get_update_dateメソッドが成功するとき' do
      it '「月」更新：update_type_idが2なら、更新日(第2引数)に、update_cycle月を加算した日付が返る' do
        # 前提条件のセット(月更新、月初タイプ)
        @renewal.subscription.update_type_id = 2
        # 更新サイクルを「3ヶ月」に
        @renewal.subscription.update_cycle = 3
        # 更新日を「2022/1/1」に
        date = Date.new(2022, 1, 1)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.get_update_date(@renewal.subscription, date)
        # 戻り値の月が、3ヶ月後の「2022年4月」か確認
        expect(update_date.year).to eq(2022)
        expect(update_date.month).to eq(4)
      end
    end
  end

  context '「年」更新：update_type_idが3のとき' do
    context 'day_type_diagnoseメソッドが成功するとき' do
      it '「月初更新」(update_day_type_idが1)のとき、第2引数の日付の日にちが、「1日」に変更されて戻る' do
        # 前提条件のセット(年更新、月初タイプ)
        @renewal.subscription.update_type_id = 3
        @renewal.subscription.update_day_type_id = 1
        # 1日ではない更新日を用意
        date = Date.new(2022, 1, 12)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.day_type_diagnose(@renewal.subscription, date)
        # 戻り値の日にちが、「2022年1月1日」になっているか確認
        result = Date.new(2022, 1, 1)
        expect(update_date).to eq(result)
      end

      it '「契約日更新」(update_day_type_idが2)のとき、第2引数の日付がそのまま返る' do
        # 前提条件のセット(年更新、月初タイプ)
        @renewal.subscription.update_type_id = 3
        @renewal.subscription.update_day_type_id = 2
        # 1日ではない更新日を用意
        date = Date.new(2022, 1, 12)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.day_type_diagnose(@renewal.subscription, date)
        # 戻り値の日にちが、dateと同じか確認
        expect(update_date).to eq(date)
      end
    end

    context 'get_update_dateメソッドが成功するとき' do
      it '「年」更新：update_type_idが3なら、更新日(第2引数)に、update_cycle年を加算した日付が返る' do
        # 前提条件のセット(年更新、月初タイプ)
        @renewal.subscription.update_type_id = 3
        # 更新サイクルを「2年」に
        @renewal.subscription.update_cycle = 2
        # 更新日を「2022/1/1」に
        date = Date.new(2022, 1, 1)
        # テスト対象のメソッド呼び出し
        update_date = @renewal.get_update_date(@renewal.subscription, date)
        # 戻り値の月が、2年後の「2024年1月」か確認
        expect(update_date.year).to eq(2024)
        expect(update_date.month).to eq(1)
      end
    end
  end

  # 異常系テスト ------------------------------------
  context '契約更新の保存ができないとき' do
    it 'renewal_countが空では保存できない' do
      @renewal.renewal_count = ''
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Renewal countを入力してください')
    end

    it 'total_priceが空では保存できない' do
      @renewal.total_price = ''
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total priceを入力してください')
    end

    it 'total_periodが空では保存できない' do
      @renewal.total_period = ''
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total periodを入力してください')
    end

    it 'update_dateが空では保存できない' do
      @renewal.update_date = ''
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Update dateを入力してください')
    end

    it 'next_update_dateが空では保存できない' do
      @renewal.next_update_date = ''
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Next update dateを入力してください')
    end

    it '紐づくSubscriptionが存在しなければ保存できない' do
      @renewal.subscription = nil
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Subscriptionを入力してください')
    end

    it 'renewal_counteが数値以外では登録できない' do
      @renewal.renewal_count = 'e'
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Renewal countは数値で入力してください')
    end

    it 'renewal_countが0未満では登録できない' do
      @renewal.renewal_count = -1
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Renewal countは0以上の値にしてください')
    end

    it 'total_priceが数値以外では登録できない' do
      @renewal.total_price = 'e'
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total priceは数値で入力してください')
    end

    it 'total_priceが0未満では登録できない' do
      @renewal.total_price = -1
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total priceは0以上の値にしてください')
    end

    it 'total_periodが数値以外では登録できない' do
      @renewal.total_period = 'e'
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total periodは数値で入力してください')
    end

    it 'total_periodが0未満では登録できない' do
      @renewal.total_period = -1
      @renewal.valid?
      expect(@renewal.errors.full_messages).to include('Total periodは0以上の値にしてください')
    end
  end
end
