class Admin::DashboardController < ApplicationController
  
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD']
  
  def show
    # count of how many products are in the database
    @num_of_products = Product.count
    # count of how many categories are in the database
    @num_of_categories = Category.count
  end
end
