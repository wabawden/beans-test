class Discount
  attr_accessor :item, :quantity, :discount, :max_quantity

  def initialize(item, quantity, discount, max_quantity = false)
    @item = item.to_sym
    @quantity = quantity
    @discount = discount
    @max_quantity = max_quantity
  end

  def show
    puts "item: #{item.to_s}, quantity: #{quantity}, discount: #{discount}" + "#{max_quantity ? ", max quantity: "  + max_quantity.to_s : ""}"
  end
end