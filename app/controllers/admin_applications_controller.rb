class AdminApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
  end

  def update
    application_pet = ApplicationPet.find(params[:app_id])
    application = application_pet.application
    if params[:status] == 'Approve'
      application_pet.pet_status = 'Approved'
    elsif params[:status] == 'Reject'
      application_pet.pet_status = 'Rejected'
      application.status = 'Rejected'
    end
      application_pet.save
        if application.application_pets.where(pet_status: 'Approved').count == application.pets.count
          application.status = 'Accepted'
            application.pets.map do |pet|
            pet.update_attribute(:adoptable, false)
            pet.save
          end
        end
      application.save
      redirect_to "/admin/applications/#{application.id}"
  end
end
