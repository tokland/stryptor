class AddTranscriptsCounterToStrips < ActiveRecord::Migration
  def change
    add_column :strips, :transcripts_count, :integer, :default => 0, index: true
  end
end
