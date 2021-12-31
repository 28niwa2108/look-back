class CreateContractCalcels < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_calcels do |t|

      t.timestamps
    end
  end
end
