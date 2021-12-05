class CreateContractRenewals < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_renewals do |t|

      t.timestamps
    end
  end
end
