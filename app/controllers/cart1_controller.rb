class Cart1Controller < ApplicationController
before_filter :authenticate_user!
def add
# get the ID of the product
id = params[:id]
# if the cart has already been created, use the existing cart
# else create a blank cart
if session[:cart] then
cart = session[:cart]
else
session[:cart] = {}
cart = session[:cart]
end
# if the product has alreadd been added to the cart, increment the value
# else set the value to 1
if cart[id] then
cart[id] = cart[id] + 1
else
cart[id] = 1
end
# redirect to the cart display page
redirect_to :action => :index
end #end add method
def remove
id = params[:id]
cart = session[:cart]
cart.delete id
redirect_to :action => :index
end
def createOrder
# Step 1: Get the current user
@user = User.find(current_user.id)
# Step 2: Create a new order and associate it with the current user
@order = @user.orders.build(:order_date => DateTime.now)
@order.save
# Step 3: For each item in the cart, create a new item on the order!!
@cart = session[:cart] || {} # Get the content of the Cart
@cart.each do | id, quantity |
item = Item.find_by_id(id)
@orderitem = @order.orderitems.build(:item_id => item.id, :title => item.title, :description => item.description, :quantity => quantity, :price => item.price)
@orderitem.save
end
end
def clearCart
# set the session variable to nil and redirect
session[:cart] = nil
redirect_to :action => :index
end
def index
# if there is a cart, pass it to the page for display
# else pass an empty value
if session[:cart] then
@cart = session[:cart]
else
@cart = {}
end
end
end