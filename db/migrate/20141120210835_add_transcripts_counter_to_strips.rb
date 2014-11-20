class AddTranscriptsCounterToStrips < ActiveRecord::Migration
  def change
    add_column :strips, :transcripts_count, :integer, :default => 0
  end
  
  def data
    Strip.find_each do |strip|
      Strip.reset_counters(strip.id, :transcripts)
    end
  end
end
