require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
    before do
      @user= User.new(first_name: 'John', last_name: 'Johnny', email: 'johnjohnny@gmail.com',password:'password',password_confirmation:'password')
     end

  # Initial example that ensures that a user with all five fields set will indeed save successfully
   it 'should save a user when it has all five necessary fields' do
    expect(@user).to be_valid
  end

  #1.Validates that the user contains a first_name
   it 'should validate the user contains a first_name' do
    @user.first_name= nil
    expect(@user).to_not be_valid
  end

  #2.Validates that the user contains a last_name
  it 'should validate the user contains a last_name' do
    @user.last_name= nil
    expect(@user).to_not be_valid
  end

  #3.Validates that the user contains a email
  it 'should validate the user contains a email' do
    @user.email= nil
    expect(@user).to_not be_valid
  end

  #4.Validates that the user contains a password
  it 'should validate the user contains a password' do
    @user.password= nil
    expect(@user).to_not be_valid
  end

  #5.Validates that the user contains a password_confirmation
  it 'should validate the user contains a password_confirmation' do
    @user.password_confirmation= nil
    expect(@user).to_not be_valid
  end

  #6. It should throw an error when password and password confirmation do not match
  it 'should throw an error when password and password confirmation do not match' do
    @user.password= 'password'
    @user.password_confirmation= 'somethingelse'
    expect(@user).to_not be_valid
    expect(@user.errors.full_messages).to eq ["Password confirmation doesn't match Password"]
  end

  #7. Validates that the email should be unique (but not case-sensitive)
  it 'should validate that the email should be unique (but not case-sensitive)' do
    @user.save

    @userTwo= User.new(
      first_name: 'John', 
      last_name: 'Johnny', 
      email: 'JOHNJOHNNY@gmail.com',password:'password',password_confirmation:'password')

    expect(@user).to be_valid
    expect(@userTwo).to_not be_valid
    expect(@userTwo.errors.full_messages).to eq ["Email has already been taken"]
  end

  #8. Validates that the password meets the minimum requirement of 10 characters 
  it 'should validate that the password meets the minimum requirement of 8 characters' do
    @user.password = 'passwor'
    expect(@user).to_not be_valid
  end
end

  # Authentication
  describe '.authenticate_with_credentials' do
    before do
      @user= User.new(first_name: 'John', last_name: 'Johnny', email: 'johnjohnny@gmail.com',password:'password',password_confirmation:'password')
     end
     
    # a user should be able to create a new account and be logged in or login with credentials 
    it 'should be able to create new account and also login' do
    @user.save
    logged_in_user = User.authenticate_with_credentials('johnjohnny@gmail.com', 'password')
    #confirms that authenticate_with_credentials return the user object and the correct user is logged in
    expect(logged_in_user.email).to eq('johnjohnny@gmail.com')
  end

  # Edge Case: user should be logged in if they leave white spaces around email
  it 'should be able to login with whitespaces around the email' do
  @user.save

  logged_in_user= User.authenticate_with_credentials(" johnjohnny@gmail.com   ", "password")
  puts logged_in_user
  expect(logged_in_user.email).to eq ('johnjohnny@gmail.com')
  end

   # Edge case: Not case-sensitive for email when logging in
   it 'should be log user in if user puts in different cases for email' do
    @user.save

    logged_in_user = User.authenticate_with_credentials("JohnJohnnY@Gmail.com", "password")
    expect(logged_in_user.email).to eq "johnjohnny@gmail.com"
   end

  end

end
