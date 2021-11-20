require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  context '新規登録ができるとき' do
    it '全てに正しい値が存在すれば登録できる' do
      expect(@user).to be_valid
    end

    it 'emailが一意であれば登録できる' do
      @user.email = 'test@aaa'
      expect(User.where(email: 'test@aaa').count).to eq(0)
      expect(@user).to be_valid
    end

    it 'emailに@があれば登録できる' do
      @user.email = 'a@a'
      expect(@user).to be_valid
    end

    it 'passwordが6文字以上であれば登録できる' do
      @user.password = 'a23456'
      @user.password_confirmation = @user.password
      expect(@user).to be_valid
    end

    it 'passwordが128文字以下であれば登録できる' do
      @user.password = Faker::Lorem.characters(number: 128, min_alpha: 1, min_numeric: 1)
      @user.password_confirmation = @user.password
      expect(@user).to be_valid
    end

    it 'passwordが半角英数字混合であれば登録できる' do
      @user.password = 'test01'
      @user.password_confirmation = @user.password
      expect(@user).to be_valid
    end

    it 'passwordとpassword_confirmationが一致すれば登録できる' do
      @user.password = 'test01'
      @user.password_confirmation = 'test01'
      expect(@user).to be_valid
    end

    it 'nicknameが6文字以下であれば登録できる' do
      @user.nickname = '１２３４５６'
      expect(@user).to be_valid
    end
  end

  context '新規登録ができないとき' do
    it 'emailが空では登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Eメールを入力してください")
    end

    it 'passwordが空では登録できない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードを入力してください")
    end

    it 'password_confirmationが空では登録できない' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワード(確認用)とパスワードの入力が一致しません")
    end

    it 'nicknameが空では登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("ニックネームを入力してください")
    end

    it 'emailが重複してる場合は登録できない' do
      @user.save
      user2 = FactoryBot.build(:user)
      user2.email = @user.email
      user2.valid?
      expect(user2.errors.full_messages).to include('Eメールはすでに使用されています')
    end

    it 'emailに@が含まれない場合は登録できない' do
      @user.email = 'abcdefg.com'
      @user.valid?
      expect(@user.errors.full_messages).to include('Eメールは不正な値です')
    end

    it 'passwordが6文字未満では登録できない' do
      @user.password = 'a2345'
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
    end

    it 'passwordが128文字超過では登録できない' do
      @user.password = Faker::Lorem.characters(number: 129, min_alpha: 1, min_numeric: 1)
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは128文字以内で入力してください')
    end

    it 'passwordが全角文字を含む場合は登録できない' do
      @user.password = 'Ａ２3456'
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは不正な値です')
    end

    it 'passwordが半角英字を含まないと登録できない' do
      @user.password = '123456'
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは不正な値です')
    end

    it 'passwordが半角数字を含まないと登録できない' do
      @user.password = 'abcdef'
      @user.password_confirmation = @user.password
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは不正な値です')
    end

    it 'passwordとpassword_confirmationが一致しないと登録できない' do
      @user.password = 'a23456'
      @user.password_confirmation = 'b23456'
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワード(確認用)とパスワードの入力が一致しません")
    end

    it 'nicknameが6文字超過では登録できない' do
      @user.nickname = '1234567'
      @user.valid?
      expect(@user.errors.full_messages).to include('ニックネームは6文字以内で入力してください')
    end
  end
end
