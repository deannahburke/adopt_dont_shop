require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip_code}
    it {should validate_presence_of :description}
    it {should allow_value("In Progress").for(:status)}
    it {should allow_value("Pending").for(:status)}
    it {should allow_value("Accepted").for(:status)}
    it {should allow_value("Rejected").for(:status)}
  end

  describe 'relationships' do
    it {should have_many :application_pets}
    it {should have_many(:pets).through(:application_pets)}
  end
end
