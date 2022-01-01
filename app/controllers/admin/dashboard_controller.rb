class Admin::DashboardController < ApplicationController
  def show
    # count of how many products are in the database
    @num_of_products = Product.count
    # count of how many categories are in the database
    @num_of_categories = Category.count
  end
end
