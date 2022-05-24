require 'rails_helper'

RSpec.describe "Admin Shelter Show Page", type: :feature do
    describe "ability to approve or reject a pet for an application" do
        before :each do
            @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
            @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
            @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 0)
            @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
            @rajah = @dumb_friends.pets.create!(name: 'Rajah', breed: 'cat', age: 5, adoptable: false)
            @stacks = @dumb_friends.pets.create!(name: 'Stacks', breed: 'german shepherd', age: 10, adoptable: true)
            @flaubert = @boulder_county.pets.create!(name: 'Flaubert', breed: 'terrier', age: 2, adoptable: true)
            @pavel = @boulder_county.pets.create!(name: 'Pavel', breed: 'cat', age: 4, adoptable: true)
            ApplicationPet.create!(application: @application_1, pet: @rajah)
            ApplicationPet.create!(application: @application_1, pet: @stacks)
            ApplicationPet.create!(application: @application_1, pet: @flaubert)
            ApplicationPet.create!(application: @application_2, pet: @pavel)
        end

        it "has a button to approve a pet for adoption" do
            visit "/admin/applications/#{@application_1.id}"
            click_button "Approve Rajah"
            expect(current_path).to eq("/admin/applications/#{@application_1.id}")
            within "#pet-application-Rajah" do
                expect(page).to have_content("Rajah Approved")
                expect(page).to_not have_content("Flaubert Approved")
            end
            within "#pet-application-Stacks" do
                click_button "Approve Stacks"
                expect(page).to have_content("Stacks Approved")
                expect(page).to_not have_content("Pavel Approved")
            end
        end

        it "has a button to reject a pet for adoption" do
            visit "/admin/applications/#{@application_1.id}"
            click_button "Reject Rajah"
            expect(current_path).to eq("/admin/applications/#{@application_1.id}")
            within "#pet-application-Rajah" do
                expect(page).to have_content("Rajah Rejected")
                expect(page).to_not have_content("Flaubert Approved")
            end
            within "#pet-application-Stacks" do
                click_button "Reject Stacks"
                expect(page).to have_content("Stacks Rejected")
                expect(page).to_not have_content("Pavel Rejected")
            end
        end
    end

    describe 'approved or rejected pets on one application do not affect another application' do
      before :each do
        @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
        @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
        @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 0)
        @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
        @rajah = @dumb_friends.pets.create!(name: 'Rajah', breed: 'cat', age: 5, adoptable: false)
        @stacks = @dumb_friends.pets.create!(name: 'Stacks', breed: 'german shepherd', age: 10, adoptable: true)
        @flaubert = @boulder_county.pets.create!(name: 'Flaubert', breed: 'terrier', age: 2, adoptable: true)
        @pavel = @boulder_county.pets.create!(name: 'Pavel', breed: 'cat', age: 4, adoptable: true)
        ApplicationPet.create!(application: @application_1, pet: @rajah)
        ApplicationPet.create!(application: @application_1, pet: @stacks)
        ApplicationPet.create!(application: @application_1, pet: @pavel)
        ApplicationPet.create!(application: @application_2, pet: @rajah)
        ApplicationPet.create!(application: @application_2, pet: @stacks)
        ApplicationPet.create!(application: @application_2, pet: @flaubert)
      end

      it 'displays pets on one app when they are approved or rejected' do
        visit "/admin/applications/#{@application_1.id}"
        click_button "Approve Rajah"
        click_button "Reject Stacks"
        expect(page).to have_content("Rajah Approved")
        expect(page).to have_content("Stacks Rejected")
        expect(page).to_not have_content("Rajah Rejected")
        expect(page).to_not have_content("Stacks Approved")

        visit "/admin/applications/#{@application_2.id}"
        click_button "Approve Rajah"
        click_button "Approve Stacks"
        expect(page).to have_content("Rajah Approved")
        expect(page).to_not have_content("Rajah Rejected")
        expect(page).to have_content("Stacks Approved")
        expect(page).to_not have_content("Stacks Rejected")
      end
    end

  describe 'Approval or rejection of pets on application' do
    before :each do
      @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
      @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
      @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 0)
      @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
      @rajah = @dumb_friends.pets.create!(name: 'Rajah', breed: 'cat', age: 5, adoptable: false)
      @stacks = @dumb_friends.pets.create!(name: 'Stacks', breed: 'german shepherd', age: 10, adoptable: true)
      @flaubert = @boulder_county.pets.create!(name: 'Flaubert', breed: 'terrier', age: 2, adoptable: true)
      @pavel = @boulder_county.pets.create!(name: 'Pavel', breed: 'cat', age: 4, adoptable: true)
      ApplicationPet.create!(application: @application_1, pet: @rajah)
      ApplicationPet.create!(application: @application_1, pet: @stacks)
      ApplicationPet.create!(application: @application_1, pet: @pavel)
      ApplicationPet.create!(application: @application_2, pet: @rajah)
      ApplicationPet.create!(application: @application_2, pet: @stacks)
      ApplicationPet.create!(application: @application_2, pet: @flaubert)
    end

    it 'approves all pets and changes status to "Accepted"' do
      visit "/admin/applications/#{@application_1.id}"
      click_button "Approve Rajah"
      click_button "Approve Stacks"
      click_button "Approve Pavel"

      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to have_content("Status: Accepted")
      expect(page).to_not have_content("Status: Pending")
      expect(page).to_not have_content("Status: In Progress")
    end

    it 'does not change status to "Accepted" if not all pets are approved' do
      visit "/applications/#{@application_1.id}"
      fill_in :description, with: "Test"
      click_button "Submit Application"

      visit "/admin/applications/#{@application_1.id}"
      click_button "Approve Rajah"

      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to have_content("Status: Pending")
      expect(page).to_not have_content("Status: Accepted")
      expect(page).to_not have_content("Status: In Progress")
      expect(page).to_not have_content("Status: Rejected")
    end
    it 'changes application status to rejected if one or more pets is rejected' do
      visit "/admin/applications/#{@application_1.id}"
      click_button "Approve Rajah"
      click_button "Reject Stacks"
      click_button "Approve Pavel"

      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to have_content("Status: Rejected")
      expect(page).to_not have_content("Status: Accepted")
      expect(page).to_not have_content("Status: In Progress")
      expect(page).to_not have_content("Status: Pending")
    end
  end

  describe 'application approval makes pets not adoptable' do
    before :each do
      @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
      @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
      @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 0)
      @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
      @rajah = @dumb_friends.pets.create!(name: 'Rajah', breed: 'cat', age: 5, adoptable: true)
      @stacks = @dumb_friends.pets.create!(name: 'Stacks', breed: 'german shepherd', age: 10, adoptable: true)
      @flaubert = @boulder_county.pets.create!(name: 'Flaubert', breed: 'terrier', age: 2, adoptable: true)
      @pavel = @boulder_county.pets.create!(name: 'Pavel', breed: 'cat', age: 4, adoptable: true)
      ApplicationPet.create!(application: @application_1, pet: @rajah)
      ApplicationPet.create!(application: @application_1, pet: @stacks)
      ApplicationPet.create!(application: @application_1, pet: @pavel)
      ApplicationPet.create!(application: @application_2, pet: @rajah)
      ApplicationPet.create!(application: @application_2, pet: @stacks)
      ApplicationPet.create!(application: @application_2, pet: @flaubert)
    end

    it 'makes pets no longer adoptable after their application is approved' do
      visit "/admin/applications/#{@application_1.id}"
      click_button "Approve Rajah"
      click_button "Approve Stacks"
      click_button "Approve Pavel"

      visit "/pets/#{@rajah.id}"
      expect(page).to have_content('Adoptable: false')
      expect(page).to_not have_content('Adoptable: true')

      visit "/pets/#{@stacks.id}"
      expect(page).to have_content('Adoptable: false')
      expect(page).to_not have_content('Adoptable: true')

      visit "/pets/#{@pavel.id}"
      expect(page).to have_content('Adoptable: false')
      expect(page).to_not have_content('Adoptable: true')
    end
  end
end
