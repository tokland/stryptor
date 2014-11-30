require 'rails_helper'

describe 'Strip', :type => :feature, :js => true do
  before do
    @user = FactoryGirl.create(:user, :name => "John Smith", :email => "john@smith.com")
    
    FactoryGirl.create(:strip_collection, {
      :code => "mafalda",
      :name => "Mafalda",
      :footer => "My footer",
      :image_url => "http://server/%{code}.jpg",
      :strips => [
        FactoryGirl.build(:strip, :code => "001", :position => 0),
        FactoryGirl.build(:strip, :code => "002", :position => 1),
        FactoryGirl.build(:strip, :code => "003", :position => 2, :transcripts => [
          FactoryGirl.build(:transcript, {:user => @user, :text => "t003"}),
        ]),
      ],
    })
    FactoryGirl.create(:strip_collection, {
      :name => "Snoopy",
      :strips => [
        FactoryGirl.build(:strip, :code => "001", :position => 0),
      ],
    })
  end
  
  describe 'Homepage' do
    before { page.visit '/' }
    
    it 'redirects to the first strip of the first collection' do
      expect(page.current_path).to eq("/mafalda/001")
    end
  end

  describe 'Collection main page' do
    before { page.visit '/mafalda' }
    
    it 'redirects to the first strip' do
      expect(page.current_path).to eq("/mafalda/001")
    end
  end
  
  describe 'Login' do
    before do 
      page.visit '/mafalda/001'
      click_link 'Entrar'
      debugger
    end
    
    #it { }
  end

  describe 'Detail page of strip with transcripts' do
    before { page.visit '/mafalda/003' }

    it 'shows the history link' do
      expect(page).to have_link("Historial")
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/003.jpg']")
    end
    
    it 'shows the text' do
      expect(page).to have_selector('.transcript pre', text: "t003")
    end
  end
  
  describe 'Detail page with unlogged user' do
    before { page.visit '/mafalda/001' }
    
    it 'shows link to FB auth' do
      expect(page).to have_selector('#user-info', :text => "Entrar")
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/001.jpg']")
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      expect(page).to have_selector('.ctitle', :text => "Mafalda 001 (1 de 3)")
    end
    
    it 'shows collection footer' do
      expect(page).to have_selector('#footer', :text => "My footer")
    end
  end

  describe 'Detail of strip without transcripts with logged user' do
    before do
      page.set_rack_session(:user_id => @user.id)
      page.visit '/mafalda/001'
    end

    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/001.jpg']")
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      expect(page).to have_selector('.ctitle', :text => "Mafalda 001 (1 de 3)")
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
        it { expects(page.current_path).to eq("/mafalda/001") } 
      end

      describe 'Previous clicked' do
        before { page.click_link('< Anterior') }
        it { expects(page.current_path).to eq("/mafalda/001") } 
      end

      describe 'Random clicked' do
        before { page.click_link('Aleatorio') }
        it { expects(page.current_path).to be_in(["/mafalda/001", 
              "/mafalda/002", "/mafalda/003"]) } 
      end

      describe 'Next clicked' do
        before { page.click_link('Siguiente >') }
        it { expects(page.current_path).to eq("/mafalda/002") } 
      end
      
      describe 'Last clicked' do
        before { page.click_link('>|') }
        it { expects(page.current_path).to eq("/mafalda/003") } 
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
            expect(page).to have_selector('.transcript pre', text: "Strip text")
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
      page.visit '/mafalda/002'
    end
  
    describe 'Navigation links' do
      describe 'First clicked' do
        before { page.click_link('|<') }
        it { expects(page.current_path).to eq("/mafalda/001") } 
      end

      describe 'Previous clicked' do
        before { page.click_link('< Anterior') }
        it { expects(page.current_path).to eq("/mafalda/001") } 
      end

      describe 'Random clicked' do
        before { page.click_link('Aleatorio') }
        it { expects(page.current_path).to be_in(["/mafalda/001", 
              "/mafalda/002", "/mafalda/003"]) } 
      end

      describe 'Next clicked' do
        before { page.click_link('Siguiente >') }
        it { expects(page.current_path).to eq("/mafalda/003") } 
      end
      
      describe 'Last clicked' do
        before { page.click_link('>|') }
        it { expects(page.current_path).to eq("/mafalda/003") } 
      end
    end
  end
  
  describe "Search" do
    before do
      StripCollection.find_by!(code: "mafalda").strips.each do |strip|
        FactoryGirl.create(:transcript,
          user: @user, 
          strip: strip, 
          text: "hello #{strip.code}",
        )
      end 
    end
    
    describe "Search non-existing text" do
      before { page.visit("/mafalda/search?text=wrong") }
      it { expects(page).to have_selector("#text[value='wrong']") }
      it { expects(page).to have_selector("#search-results", :text => '0 tira(s)') }
      it { expects(page).to have_selector(".comic img", :count => 0) }
    end
  
    describe "Search with three matches" do
      before { page.visit("/mafalda/search?text=hello") }
      it { expects(page).to have_selector("#text[value='hello']") }
      it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
      it { expects(page).to have_selector("#search-results", :text => 'mostrando: 1 a 3') }
      it { expects(page).to have_selector(".comic img", :count => 3) }
    end
    
    describe "Search with one match" do
      before { page.visit("/mafalda/search?text=hello+002") }
      it { expects(page).to have_selector("#text[value='hello 002']") }
      it { expects(page).to have_selector("#search-results", :text => '1 tira(s)') }
      it { expects(page).to have_selector("#search-results", :text => 'mostrando: 1 a 1') }
      it { expects(page).to have_selector(".comic img", :count => 1) }
    end

    describe "Paginator" do
      describe "Without page" do
        before { page.visit("/mafalda/search?text=hello&per_page=2") }
        it { expects(page).to have_selector("#text[value='hello']") }
        it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
        it { expects(page).to have_selector("#search-results", :text => 'mostrando: 1 a 2') }
        it { expects(page).to have_selector(".comic img", :count => 2) }
        it { expects(page).to have_selector(".pagination") }
      end

      describe "First page" do
        before { page.visit("/mafalda/search?text=hello&per_page=2&page=1") }
        it { expects(page).to have_selector("#text[value='hello']") }
        it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
        it { expects(page).to have_selector("#search-results", :text => 'mostrando: 1 a 2') }
        it { expects(page).to have_selector(".comic img", :count => 2) }
        it { expects(page).to have_selector(".pagination") }
      end

      describe "Second page" do
        before { page.visit("/mafalda/search?text=hello&per_page=2&page=2") }
        it { expects(page).to have_selector("#text[value='hello']") }
        it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
        it { expects(page).to have_selector("#search-results", :text => 'mostrando: 3 a 3') }
        it { expects(page).to have_selector(".comic img", :count => 1) }
        it { expects(page).to have_selector(".pagination") }
      end

      describe "Out-of-bounds page" do
        before { page.visit("/mafalda/search?text=hello&per_page=2&page=123") }
        it { expects(page).to have_selector("#text[value='hello']") }
        it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
        it { expects(page).not_to have_selector("#search-results", :text => 'mostrando') }
        it { expects(page).to have_selector(".comic img", :count => 0) }
      end
    end
  end
end
