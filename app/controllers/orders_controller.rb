class OrdersController < ApplicationController

  def show
    # @order = Order.find(params[:id])
    # @line_items = LineItem.where(order_id: params[:id])
    # @order_data= Order.joins("INNER JOIN line_items ON orders.id=line_items.order_id")
    
    @order_data=LineItem.select("*").joins(:order, :product)
    # @order_data=Order.joins("JOIN line_items ON orders.id=line_items.order_id JOIN products ON product_id = products.id")

# Author.joins("INNER JOIN posts ON posts.author_id = author.id AND posts.published = 't'")

    # SELECT * FROM orders 
    # JOIN line_items ON orders.id=line_items.order_id
    # JOIN products ON product_id = products.id;
  end

  def create
    charge = perform_stripe_charge
    order  = create_order(charge)

    if order.valid?
      empty_cart!
      redirect_to order, notice: 'Your Order has been placed.'
    else
      redirect_to cart_path, flash: { error: order.errors.full_messages.first }
    end

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

end
