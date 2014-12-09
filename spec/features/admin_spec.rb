require 'rails_helper'

feature 'Admin page', js: true do
  given(:user) do 
    FactoryGirl.create(:user, :name => "John Smith", :email => "john@abc.com")
  end

  background do
    FactoryGirl.create(:strip_collection, {
      :code => "mafalda",
      :name => "Mafalda",
      :footer => "My footer",
      :image_url => "http://server/%{code}.jpg",
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
    
    it "renders all transcripts" do
      expect(page).to have_selector('ul li', count: 3)
    end
  end
end
