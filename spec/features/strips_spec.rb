require 'rails_helper'

describe 'Strip', :type => :feature, :js => true do
  let(:user) do 
    FactoryGirl.create(:user, :name => "John Smith", :email => "john@abc.com")
  end

  before do
    FactoryGirl.create(:strip_collection, {
      :code => "mafalda",
      :name => "Mafalda",
      :footer => "My footer",
      :image_url => "http://server/%{code}.jpg",
      :strips => [
        FactoryGirl.build(:strip, :code => "001", :position => 0),
        FactoryGirl.build(:strip, :code => "002", :position => 1),
        FactoryGirl.build(:strip, :code => "003", :position => 2, :transcripts => [
          FactoryGirl.build(:transcript, {:user => user, :text => "t003b"}),
          FactoryGirl.build(:transcript, {:user => user, :text => "t003"}),
        ]),
      ],
    })
    FactoryGirl.create(:strip_collection, {
      :name => "Snoopy",
      :strips => [
        FactoryGirl.build(:strip, :code => "001", :position => 0),
        FactoryGirl.build(:strip, :code => "002", :position => 1),
      ],
    })
  end
  
  shared_examples :strip do |code:, position:, total:, footer:|
    it 'shows the strip image' do
      expect(page).to have_selector("img[src='http://server/%s.jpg']" % code)
    end
    
    it 'shows title <collection-name> <script-code> (<position> of <total>)' do
      text = "Mafalda %s (%d de %d)" % [code, position, total]
      expect(page).to have_selector('.ctitle', :text => text)
    end
    
    it 'shows collection footer' do
      expect(page).to have_selector('#footer', :text => footer)
    end
  end

  describe 'Root URL' do
    before { page.visit '/' }
    
    it 'redirects to the first strip of the first collection' do
      expect(page.current_path).to eq("/mafalda/001")
    end
  end

  describe 'Collection main URL' do
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

  describe 'Detail page of strip' do
    describe 'with transcripts' do
      before { page.visit '/mafalda/003' }
      
      it_behaves_like :strip, code: "003", footer: "My footer", position: 3, total: 3

      it 'shows the history link' do
        expect(page).to have_link("Historial")
      end

      it 'shows the text' do
        expect(page).to have_selector('.transcript pre', text: "t003")
      end
    end
  
    describe 'for unlogged user' do
      before { page.visit '/mafalda/001' }
      
      it_behaves_like :strip, code: "001", footer: "My footer", position: 1, total: 3
      
      it 'shows link to FB auth' do
        expect(page).to have_selector('#user-info', :text => "Entrar")
      end
    end

    describe 'without transcripts, with logged user' do
      before do
        page.set_rack_session(:user_id => user.id)
        page.visit '/mafalda/001'
      end
      
      it_behaves_like :strip, code: "001", footer: "My footer", position: 1, total: 3

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
              page.fill_in("transcript[text]", :with => "New text")
              page.click_button("Guardar")
            end
        
            it "shows the [edit] button again" do          
              expect(page).to have_selector('.toggle-edit', text: "Editar", visible: true)
            end
            
            it 'shows new transcription' do
              expect(page).to have_selector('.transcript pre', text: "New text")
            end

            it 'shows the history link' do
              expect(page).to have_link("Historial")
            end    
          end
        end
      end
    end

    describe 'Detail of second strip page' do
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
  end
  
  describe "Search" do
    before do
      StripCollection.find_by!(code: "mafalda").strips.each do |strip|
        FactoryGirl.create(:transcript,
          user: user, 
          strip: strip, 
          text: "hello #{strip.code}",
        )
      end 
    end
    
    describe "non-existing text" do
      before { page.visit("/mafalda/search?text=wrong") }
      
      it { expects(page).to have_selector("#text[value='wrong']") }
      it { expects(page).to have_selector("#search-results", :text => '0 tira(s)') }
      it { expects(page).to have_selector(".comic img", :count => 0) }
    end
  
    describe "text contained in three matches" do
      before { page.visit("/mafalda/search?text=hello") }
      
      it { expects(page).to have_selector("#text[value='hello']") }
      it { expects(page).to have_selector("#search-results", :text => '3 tira(s)') }
      it { expects(page).to have_selector("#search-results", :text => 'mostrando: 1 a 3') }
      it { expects(page).to have_selector(".comic img", :count => 3) }
    end
    
    describe "text contained in one match" do
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
  
  describe "A non-logged user" do
    describe "goes to a non-rated strip" do
      before { page.visit '/mafalda/001' }
      
      describe "and clicks on a rating star" do
        before { page.click_link("rating-3") }
        
        it 'redirects to oauth' do
          expect(page.current_path).to eq("/dialog/oauth")
        end
      end
    end
  end

  describe "A logged user" do
    before { page.set_rack_session(:user_id => user.id)}
    
    describe "that goes to a non-rated strip" do 
      before { page.visit '/mafalda/001' }

      describe "and clicks on a rating star" do
        before { page.click_link("rating-3") }
    
        it 'sees the votes count updated' do
          expect(page).to have_selector("#rating-info", text: "Valoración: 3.0 (de 1 usuarios)")
        end
        
        it 'sees HIS rating in the stars' do
          expect(page).to have_selector("a#rating-1.voted")
          expect(page).to have_selector("a#rating-2.voted")
          expect(page).to have_selector("a#rating-3.voted")
          expect(page).to have_selector("a#rating-4.non-voted")
          expect(page).to have_selector("a#rating-5.non-voted")
        end
      end
    end
  end
end
