require 'rails_helper'

feature 'Admin', js: true do
  given(:user) { FactoryGirl.create(:user) }

  background do
    FactoryGirl.create(:strip_collection, {
      :strips => [
        FactoryGirl.build(:strip, :code => "001", :position => 0, :transcripts => [
          FactoryGirl.build(:transcript, {:user => user, :text => "001-text1"}),
          FactoryGirl.build(:transcript, {:user => user, :text => "001-text2"}),
        ]),
        FactoryGirl.build(:strip, :code => "002", :position => 1, :transcripts => [
          FactoryGirl.build(:transcript, {:user => user, :text => "002-text1"}),
        ]),
      ],
    })
  end
    
  feature 'transcripts' do
    background { page.visit '/admin/transcripts' }
    
    it "renders transcripts grouped by strip" do
      expect(page).to have_selector('.transcripts li', count: 2)
    end
  end
end
