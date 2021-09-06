class Checkout
  attr_reader :prices, :discount_list
  private :prices

  def initialize(prices, discount_list = {})
    @prices = prices
    @discount_list = discount_list
  end

  def scan(item)
    basket[item] ? basket[item] += 1 : basket[item] = 1
  end

  def total
    total = 0

    basket.each do |item, count|
      if discount_list.item_lookup(item) && count >= discount_list.item_lookup(item).quantity
        total += apply_discount(discount_list.item_lookup(item), prices.fetch(item), count)
      else
        total += prices.fetch(item) * count
      end
    end

    total
  end

  private
  
  def apply_discount(item, item_price, count)
    if item.max_quantity && count > item.max_quantity
      item_price * count - item.discount * item_price * item.max_quantity
    else
      item_price * count - item.discount * item_price * (count / item.quantity)
    end
  end

  def basket
    @basket ||= Hash.new
  end
end
