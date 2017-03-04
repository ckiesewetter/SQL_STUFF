require 'rails_helper'
#
# RSpec.feature "RegisterUser", type: :feature do
#   context "Landing page" do
#     Steps "Going to Landing page" do
#       Given "I visit localhost 3000:" do
#         visit "/users/index"
#       end
#       Then "I see Welcome!" do
#         expect(page).to have_content("Welcome!")
#       end
#     end
#   end
#   context "Register a user" do
#     Steps "for registering a user" do
#       Given "that I am on the registering page" do
#         visit "/"
#       end
#       Then "I can enter my information" do
#         fill_in 'name', with: 'Don Ready'
#         fill_in 'email', with: 'DonReady@hotmail.com'
#         click_button 'register'
#       end
#       Then 'I am taken to a page that shows that I am registered.' do
#         expect(page).to have_content 'Don Ready'
#         expect(page).to have_content 'DonReady@hotmail.com'
#       end
#     end
#   end
# end

RSpec.describe User, type: :model do
  it 'is a thing' do
    expect{User.new}.to_not raise_error
  end

  it 'has name has name and email' do
    user = User.new
    user.name = 'Bill Nye'
    user.email = 'BillNye@scienceGuy.com'
    expect(user.save).to eq true
    u2 = User.find_by_name 'Bill Nye'
    expect(u2.name).to eq 'Bill Nye'
    expect(u2.email).to eq 'BillNye@scienceGuy.com'
  end
end
