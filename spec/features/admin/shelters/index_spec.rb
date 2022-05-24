require 'rails_helper'

RSpec.describe 'Admin Shelter Index Page' do
    describe 'Admin Shelters Index' do
        before :each do
            @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
            @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
            @humane_society = Shelter.create!(name: 'Humane Society', city: 'Denver', rank: 12, foster_program: false)
            @max_fund = Shelter.create!(name: 'MaxFund Shelter', city: 'Oakland', rank: 2, foster_program: true)

            @pet_1 = @dumb_friends.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
            @pet_2 = @dumb_friends.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
            @pet_3 = @max_fund.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
            @pet_4 = @humane_society.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

            @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 1)
            @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 1)
            @application_3 = Application.create!(name: 'Deannah', street_address: '1424 Pennsylvania Ave', city: 'Denver', state: 'CO', zip_code: '80214', description: 'Mohammed', status: 0)

            ApplicationPet.create!(application: @application_1, pet: @pet_4)
            ApplicationPet.create!(application: @application_2, pet: @pet_4)
            ApplicationPet.create!(application: @application_3, pet: @pet_1)
            ApplicationPet.create!(application: @application_2, pet: @pet_2)
        end

        it 'lists all shelters in reverse alphbetical' do
            visit "/admin/shelters"
            expect("MaxFund Shelter").to appear_before("Humane Society")
            expect("Humane Society").to appear_before("Denver Dumb Friends League")
            expect("Denver Dumb Friends League").to appear_before("Boulder County Shelter")
        end

        it "has a sections for shelters with pending applications" do
            visit '/admin/shelters'
            within "#shelters-with-pending-applications" do
                expect(page).to have_content("Humane Society") 
                expect(page).to have_content("Denver Dumb Friends League") 
                expect(page).to_not have_content("Boulder County Shelter") 
                expect(page).to_not have_content("MaxFund Shelter") 
            end
        end

        it "oraders section for shelters with pending applications alphabetically" do
            visit '/admin/shelters'
            within "#shelters-with-pending-applications" do
                expect("Denver Dumb Friends").to appear_before("Humane Society")
                expect(page).to_not have_content("Boulder County Shelter") 
                expect(page).to_not have_content("MaxFund Shelter") 
            end
        end

        it "has a link from admin shelter index to admin shelter show pages" do
            visit '/admin/shelters'
            click_link 'Denver Dumb Friends League'
            expect(current_path).to eq("/admin/shelters/#{@dumb_friends.id}")
        end
        
    end
end