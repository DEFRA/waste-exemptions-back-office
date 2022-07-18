class RemoveAdRenewalLettersExports < ActiveRecord::Migration[6.1]
  def change
    drop_table :ad_renewal_letters_exports, if_exists: true
  end
end
