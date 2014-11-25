require 'rails_helper'

describe 'Strip pages', :type => :feature, :js => true do
  before :each do
    collection = FactoryGirl.create(:strip_collection, {
      :code => "collection",
      :name => "Collection",
      :footer => "My footer",
      :image_url => "http://server/%{code}.jpg"
    })
    FactoryGirl.create(:strip, :strip_collection => collection, :code => "001", :position => 0)
    FactoryGirl.create(:strip, :strip_collection => collection, :code => "002", :position => 1)
    
    collection2 = FactoryGirl.create(:strip_collection, :name => "Another collection")
    FactoryGirl.create(:strip, :strip_collection => collection2, :code => "001", :position => 0)
    
    @user = FactoryGirl.create(:user, :name => "John Smith", :email => "john@smith.com")
  end
  
  describe 'Homepage' do
    before { page.visit '/' }
    
    it 'redirects to the first strip of the first collection on homepage' do
      expect(page.current_path).to eq("/collection/001")
    end
  end

  describe 'Collection main page' do
    before { page.visit '/collection' }
    
    it 'redirects to the first strip' do
      expect(page.current_path).to eq("/collection/001")
    end
  end
  
  describe 'Detail page with unlogged user' do
    before { page.visit '/collection/001' }
    
    it 'shows link to FB auth' do
      expect(page).to have_selector('#user-info', :text => "Entrar")
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/001.jpg']")
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      expect(page).to have_selector('#ctitle', :text => "Collection 001 (1 de 2)")
    end
    
    it 'shows collection footer' do
      expect(page).to have_selector('#footer', :text => "My footer")
    end
  end

  describe 'Detail with logged user' do
    before do
      page.set_rack_session(:user_id => @user.id)
      page.visit '/collection/001'
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/001.jpg']")
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      expect(page).to have_selector('#ctitle', :text => "Collection 001 (1 de 2)")
    end
    
    it 'shows collection footer' do
      expect(page).to have_selector('#footer', :text => "My footer")
    end
    
    it 'shows user name' do
      expect(page).to have_selector('#user-info', :text => "John Smith")
    end

    it 'does not show the history link' do
      expect(page).not_to have_link("Historial")
    end
    
    describe 'Navigation links' do
      describe 'First clicked' do
        before { page.click_link('|<') }
        it { expects(page.current_path).to eq("/collection/001") } 
      end

      describe 'Previous clicked' do
        before { page.click_link('< Anterior') }
        it { expects(page.current_path).to eq("/collection/001") } 
      end

      describe 'Random clicked' do
        before { page.click_link('Aleatorio') }
        it { expects(page.current_path).to eq("/collection/001").or eq("/collection/002") } 
      end

      describe 'Next clicked' do
        before { page.click_link('Siguiente >') }
        it { expects(page.current_path).to eq("/collection/002") } 
      end
      
      describe 'Last clicked' do
        before { page.click_link('>|') }
        it { expects(page.current_path).to eq("/collection/002") } 
      end
    end
    
    describe 'Transcription box' do
      it { expects(page).to have_selector('.toggle-edit', text: "Editar", visible: true) }
      
      describe 'Click [edit] button' do
        before { page.click_link("Editar") }
        
        it "enabled edit mode" do
          expect(page).to have_selector('#new_transcript') 
          expect(page).to have_selector('.toggle-edit', text: "Cancelar", visible: true)
        end
      
        describe "Click [cancel] button" do
          before { page.click_link("Cancelar") }
          
          it 'returns to show-only mode' do
            expect(page).not_to have_selector('#new_transcript', visible: true)
            expect(page).not_to have_selector('.toggle-edit', text: "Cancelar", visible: true)
            expect(page).to have_selector('.toggle-edit', text: "Editar", visible: true)
          end
        end
        
        describe 'Write transcription text and click save button' do
          before do
            page.fill_in("transcript[text]", :with => "Strip text")
            page.click_button("Guardar")
          end
          
          it 'shows new transcription' do
            expect(page).to have_selector('.toggle-edit', text: "Editar", visible: true)
            expect(page).to have_selector('#transcript pre', text: "Strip text")
          end

          it 'shows the history link' do
            expect(page).to have_link("Historial")
          end    
        end
      end
    end
  end
end
