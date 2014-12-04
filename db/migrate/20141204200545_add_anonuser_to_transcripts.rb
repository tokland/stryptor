class AddAnonuserToTranscripts < ActiveRecord::Migration
  def change
    add_column :transcripts, :anonuser_ip, :string
    add_column :transcripts, :anonuser_name, :string
  end
end
