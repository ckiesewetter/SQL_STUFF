class UsersController < ApplicationController
  def index
    @contacts = Contact.all
  end
  def register
    @contact = Contact.new
    @contact.family_name = params[:family_name]
    @contact.given_name = params[:given_name]
    @contact.email = params[:email]
    @contact.address = params[:address]

    # TODO: Create user in database with user_name
    if @contact.save
    session[:contact] = @contact.id
    render text: "Thank you #{@contact.family_name}. You have successfully registered!"
    end
  end
  def edit
    @contact = Contact.find(params[:id])
  end
end
