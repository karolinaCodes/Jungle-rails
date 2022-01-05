require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    before do
     @category= Category.new(name: 'test')
      @product = Product.new(
        name: 'Test product',
        price: 45.99,
        quantity: 4,
        category: @category
      )
    end

    # Initial example that ensures that a product with all four fields set will indeed save successfully
    it 'should save a product when it has all four fields' do
      expect(@product).to be_valid
    end

    #1.Validates that the product contains a name
    it 'should validate the product contains a name' do
      @product.name= nil
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to eq ["Name can't be blank"]
    end

    #2. Validates that the product contains a price
    it 'should validate the product contains a price' do
      @product.price_cents= nil
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to eq ["Price cents is not a number", "Price is not a number", "Price can't be blank"]
    end

    #3. Validates that the product contains a quantity number
    it 'should validate the product contains a quantity' do
      @product.quantity= nil
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to eq ["Quantity can't be blank"]
    end

    #4. Validates that the product contains a category
    it 'should validate the product contains a category' do
      @product.category= nil
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages).to eq ["Category can't be blank"]
    end
  end
end