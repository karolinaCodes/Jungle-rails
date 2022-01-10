require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
      # setup
    before do
      # exercise
      @user= User.new(first_name: 'John', last_name: 'Johnny', email: 'johnjohnny@gmail.com',password:'password',password_confirmation:'password')
     end

  # Initial example that ensures that a user with all five fields set will indeed save successfully
   it 'should save a user when it has all five necessary fields' do
     # verify
    expect(@user).to be_valid
  end

  #1.Validates that the user contains a first_name
   it 'should validate the user contains a first_name' do
    # exercise
    @user.first_name= nil

     # verify
    expect(@user).to_not be_valid
  end

  #2.Validates that the user contains a last_name
  it 'should validate the user contains a last_name' do
    # exercise
    @user.last_name= nil

     # verify
    expect(@user).to_not be_valid
  end

  #3.Validates that the user contains a email
  it 'should validate the user contains a email' do
    # exercise
    @user.email= nil

     # verify
    expect(@user).to_not be_valid
  end

  #4.Validates that the user contains a password
  it 'should validate the user contains a password' do
    # exercise
    @user.password= nil

     # verify
    expect(@user).to_not be_valid
  end

  #5.Validates that the user contains a password_confirmation
  it 'should validate the user contains a password_confirmation' do
    # exercise
    @user.password_confirmation= nil

    # verify
    expect(@user).to_not be_valid
  end

  #6. It should throw an error when password and password confirmation do not match
  it 'should throw an error when password and password confirmation do not match' do
    # exercise
    @user.password= 'password'
    @user.password_confirmation= 'somethingelse'

    # verify
    expect(@user).to_not be_valid
    expect(@user.errors.full_messages).to eq ["Password confirmation doesn't match Password"]
  end

  #7. Validates that the email should be unique (but not case-sensitive)
  it 'should validate that the email should be unique (but not case-sensitive)' do
    # exercise
    @user.save

    @userTwo= User.new(
      first_name: 'John', 
      last_name: 'Johnny', 
      email: 'JOHNJOHNNY@gmail.com',password:'password',password_confirmation:'password')

    # verify
    expect(@user).to be_valid
    expect(@userTwo).to_not be_valid
    expect(@userTwo.errors.full_messages).to eq ["Email has already been taken"]
  end

  #8. Validates that the password meets the minimum requirement of 10 characters 
  it 'should validate that the password meets the minimum requirement of 8 characters' do
    # exercise
    @user.password = 'passwor'

    # verify
    expect(@user).to_not be_valid
  end
end

  # Authentication
  describe '.authenticate_with_credentials' do
    # setup
    before do
      @user= User.new(first_name: 'John', last_name: 'Johnny', email: 'johnjohnny@gmail.com',password:'password',password_confirmation:'password')
     end
     
    # a user should be able to create a new account and be logged in or login with credentials 
    it 'should be able to create new account and also login' do
      # exercise
    @user.save
    logged_in_user = User.authenticate_with_credentials('johnjohnny@gmail.com', 'password')

    # verify
    #confirms that authenticate_with_credentials return the user object and the correct user is logged in
    expect(logged_in_user.email).to eq('johnjohnny@gmail.com')
  end

  # Edge Case: user should be logged in if they leave white spaces around email
  it 'should be able to login with whitespaces around the email' do
    # exercise
  @user.save

  logged_in_user= User.authenticate_with_credentials(" johnjohnny@gmail.com   ", "password")
  puts logged_in_user

  # verify
  expect(logged_in_user.email).to eq ('johnjohnny@gmail.com')
  end

   # Edge case: Not case-sensitive for email when logging in
   it 'should be log user in if user puts in different cases for email' do
    # exercise
    @user.save

    # verify
    logged_in_user = User.authenticate_with_credentials("JohnJohnnY@Gmail.com", "password")
    expect(logged_in_user.email).to eq "johnjohnny@gmail.com"
   end

  end

end
