class AddTextToStrips < ActiveRecord::Migration
  def change
    add_column :strips, :text, :text
  end
  
  def data
    Strip.with_transcriptions.each do |strip|
      strip.current_transcript.update_strip_text
    end
  end
end
