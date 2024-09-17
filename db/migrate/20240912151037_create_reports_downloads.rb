class CreateReportsDownloads < ActiveRecord::Migration[7.1]
  def change
    create_table :reports_downloads do |t|
      t.string :report_type
      t.string :report_file_name
      
      t.string :user_id
      t.datetime :downloaded_at
    end
  end
end
