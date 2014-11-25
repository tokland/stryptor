require 'rails_helper'

describe 'Strip pages', :type => :feature, :js => true do
  before do
    @user = FactoryGirl.create(:user, :name => "John Smith", :email => "john@smith.com")
    
    collection = FactoryGirl.create(:strip_collection, {
      :code => "collection",
      :name => "Collection",
      :footer => "My footer",
      :image_url => "http://server/%{code}.jpg"
    })
    @strips = [
      FactoryGirl.create(:strip, :strip_collection => collection, :code => "001", :position => 0),
      FactoryGirl.create(:strip, :strip_collection => collection, :code => "002", :position => 1),
      FactoryGirl.create(:strip, :strip_collection => collection, :code => "003", :position => 2),
    ] 
    FactoryGirl.create(:transcript, :user => @user, :strip => @strips[2], :text => "003 text")
    
    collection2 = FactoryGirl.create(:strip_collection, :name => "Another collection")
    FactoryGirl.create(:strip, :strip_collection => collection2, :code => "001", :position => 0)
  end
  
  describe 'Homepage' do
    before { page.visit '/' }
    
    it 'redirects to the first strip of the first collection' do
      expect(page.current_path).to eq("/collection/001")
    end
  end

  describe 'Collection main page' do
    before { page.visit '/collection' }
    
    it 'redirects to the first strip' do
      expect(page.current_path).to eq("/collection/001")
    end
  end

  describe 'Detail page of strip with transcripts' do
    before { page.visit '/collection/003' }

    it 'shows the history link' do
      expect(page).to have_link("Historial")
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/003.jpg']")
    end
    
    it 'shows the text' do
      expect(page).to have_selector('#transcript pre', text: "003 text")
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
      expect(page).to have_selector('#ctitle', :text => "Collection 001 (1 de 3)")
    end
    
    it 'shows collection footer' do
      expect(page).to have_selector('#footer', :text => "My footer")
    end
  end

  describe 'Detail of strip without transcripts with logged user' do
    before do
      page.set_rack_session(:user_id => @user.id)
      page.visit '/collection/001'
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/001.jpg']")
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      expect(page).to have_selector('#ctitle', :text => "Collection 001 (1 de 3)")
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
    
    describe 'Logout' do
      before { page.click_link('Salir') }

      it 'shows link to FB auth' do
        expect(page).to have_selector('#user-info', :text => "Entrar")
      end
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
        it { expects(page.current_path).to be_in(["/collection/001", 
              "/collection/002", "/collection/003"]) } 
      end

      describe 'Next clicked' do
        before { page.click_link('Siguiente >') }
        it { expects(page.current_path).to eq("/collection/002") } 
      end
      
      describe 'Last clicked' do
        before { page.click_link('>|') }
        it { expects(page.current_path).to eq("/collection/003") } 
      end
    end
    
    describe 'Transcription box' do
      it { expects(page).to have_selector('.toggle-edit', text: "Editar", visible: true) }
      
      describe 'Click [edit] button' do
        before { page.click_link("Editar") }
        
        it "enables edit mode" do
          expect(page).to have_selector('#new_transcript') 
          expect(page).to have_selector('.toggle-edit', text: "Cancelar", visible: true)
        end
      
        describe "Click [cancel] button" do
          before { page.click_link("Cancelar") }
          
          it 'returns to show mode' do
            expect(page).not_to have_selector('#new_transcript', visible: true)
            expect(page).not_to have_selector('.toggle-edit', text: "Cancelar", visible: true)
            expect(page).to have_selector('.toggle-edit', text: "Editar", visible: true)
          end
        end
        
        describe 'Submit new transcription' do
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

  describe 'Detail second strip page' do
    before do
      page.visit '/collection/002'
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
        it { expects(page.current_path).to be_in(["/collection/001", 
              "/collection/002", "/collection/003"]) } 
      end

      describe 'Next clicked' do
        before { page.click_link('Siguiente >') }
        it { expects(page.current_path).to eq("/collection/003") } 
      end
      
      describe 'Last clicked' do
        before { page.click_link('>|') }
        it { expects(page.current_path).to eq("/collection/003") } 
      end
    end
  end
end
