class Reason < ActiveHash::Base
  self.data = [
    { id: 0, name: '選択してください' },
    { id: 1, name: '今の自分には活用しきれなかった' },
    { id: 2, name: 'サービス内容に不満がある' },
    { id: 3, name: '価格が高い' },
    { id: 4, name: '他のサービスに乗り換える' },
    { id: 5, name: 'あまり利用しなかった' },
    { id: 6, name: '不要になった' }
  ]
  include ActiveHash::Associations
  has_many :contract_calcels
end
