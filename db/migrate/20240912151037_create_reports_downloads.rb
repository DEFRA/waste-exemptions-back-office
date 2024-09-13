class CreateReportsDownloads < ActiveRecord::Migration[7.1]
  def change
    create_table :reports_downloads do |t|
      t.references :report, polymorphic: true
      t.string :user_id
      t.datetime :downloaded_at
    end
  end
end
