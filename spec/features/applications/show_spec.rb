require 'rails_helper'

RSpec.describe 'application show page', type: :feature do
  before :each do
    @dumb_friends = Shelter.create!(name: 'Denver Dumb Friends League', city: 'Denver', rank: 4, foster_program: true)
    @boulder_county = Shelter.create!(name: 'Boulder County Shelter', city: 'Boulder', rank: 7, foster_program: true)
    @application_1 = Application.create!(name: 'Antonio', street_address: '1234 Drury Lane', city: 'San Francisco', state: 'CA', zip_code: '94016', description: 'God', status: 0)
    @application_2 = Application.create!(name: 'Casey', street_address: '1564 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
    @application_3 = Application.create!(name: 'Deannah', street_address: '154 Pearl Street', city: 'Boulder', state: 'C0', zip_code: '80037', description: 'Allah', status: 0)
    @rajah = @dumb_friends.pets.create!(name: 'Rajah', breed: 'cat', age: 5, adoptable: false)
    @stacks = @dumb_friends.pets.create!(name: 'Stacks', breed: 'german shepherd', age: 10, adoptable: true)
    @flaubert = @boulder_county.pets.create!(name: 'Flaubert', breed: 'terrier', age: 2, adoptable: true)
    @pavel = @boulder_county.pets.create!(name: 'Pavel', breed: 'cat', age: 4, adoptable: true)
    ApplicationPet.create!(application: @application_1, pet: @rajah)
    ApplicationPet.create!(application: @application_1, pet: @stacks)
    ApplicationPet.create!(application: @application_1, pet: @flaubert)
    ApplicationPet.create!(application: @application_2, pet: @pavel)
  end

    it 'displays application info including address, pets, and status' do

    visit "/applications/#{@application_1.id}"

    expect(page).to have_content("Antonio")
    expect(page).to have_content("1234 Drury Lane")
    expect(page).to have_content("San Francisco")
    expect(page).to have_content("CA")
    expect(page).to have_content("94016")
    expect(page).to have_content("God")
    expect(page).to have_content("In Progress")
    expect(page).to_not have_content("Casey")
    expect(page).to_not have_content("1564 Pearl Street")
  end

  it 'displays applications pets as links to pet show page' do
    visit "/applications/#{@application_1.id}"

    expect(page).to have_content(@rajah.name)
    expect(page).to have_content(@stacks.name)
    expect(page).to_not have_content(@pavel.name)

    click_link "#{@flaubert.name}"

    expect(current_path).to eq("/pets/#{@flaubert.id}")
  end

  it 'has a section to "Add a Pet to this Application"' do
    visit "/applications/#{@application_1.id}"
    within ('#add-pet-to-application') do
      expect(page).to have_content("Add a Pet to this Application")

      fill_in('Search', with: 'Pavel')
      click_on("Search for pets by name")

      expect(current_path).to eq("/applications/#{@application_1.id}")
      expect(page).to have_content(@pavel.name)
    end
  end

  it 'has a section to "Add a Pet to this Application"' do
    visit "/applications/#{@application_1.id}"
    within "#wanted-pets" do
        expect(page).to_not have_content("Pavel")
    end
    fill_in('Search', with: 'Pavel')
    click_on("Search for pets by name")
    click_button 'Adopt Pavel'
    expect(current_path).to eq("/applications/#{@application_1.id}")
    within "#wanted-pets" do
      expect(page).to have_content("Pavel")
    end
  end

  it 'returns partial pet name matches' do
    visit "/applications/#{@application_2.id}"

    fill_in('Search', with: 'Ra')
    click_on("Search for pets by name")

    expect(page).to have_content('Rajah')
    expect(page).to_not have_content('Flaubert')
    expect(current_path).to eq("/applications/#{@application_2.id}")
  end

  it 'is case insensitive when searching pet names all lowercase' do
    visit "/applications/#{@application_2.id}"

    fill_in('Search', with: 'rajah')
    click_on("Search for pets by name")

    expect(page).to have_content('Rajah')
    expect(page).to_not have_content('Flaubert')
    expect(current_path).to eq("/applications/#{@application_2.id}")
  end

  it 'is case insensitive when searching pet names all uppercase' do
    visit "/applications/#{@application_2.id}"

    fill_in('Search', with: 'RAJAH')
    click_on("Search for pets by name")

    expect(page).to have_content('Rajah')
    expect(page).to_not have_content('Flaubert')
    expect(current_path).to eq("/applications/#{@application_2.id}")
  end

  it 'is case insensitive when searching pet names' do
    visit "/applications/#{@application_2.id}"

    fill_in('Search', with: 'RaJah')
    click_on("Search for pets by name")

    expect(page).to have_content('Rajah')
    expect(page).to_not have_content('Flaubert')
    expect(current_path).to eq("/applications/#{@application_2.id}")
  end

  it 'has a section to submit application after pets are added' do
    visit "/applications/#{@application_1.id}"

    fill_in('Description', with: "I love dogs more than life itself")
    click_button('Submit Application')

    expect(current_path).to eq("/applications/#{@application_1.id}")
    expect(page).to have_content("Pending")
    expect(page).to have_content("Rajah")
    expect(page).to have_content("Stacks")
    expect(page).to have_content("Flaubert")
    expect(page).to have_content("I love dogs more than life itself")
    expect(page).to_not have_content("Add a Pet to this Application")
    expect(page).to_not have_content("In Progress")
  end

  it 'does not have a submit section if no pets are added' do
    visit "/applications/#{@application_3.id}"

    expect(page).to have_content("Deannah")
    expect(page).to_not have_content("Submit Application")
  end
end
