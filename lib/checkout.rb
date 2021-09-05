class Checkout
  attr_reader :prices, :basket, :discount_list
  private :prices

  def initialize(prices, discount_list = {})
    @prices = prices
    @basket = Hash.new
    @discount_list = discount_list
  end

  def scan(item)
    basket[item] ? basket[item] += 1 : basket[item] = 1
  end

  def total
    total = 0

    basket.each do |item, count|
      if discount_list.item_lookup(item) && count >= discount_list.item_lookup(item).quantity
        total += prices.fetch(item) * count - (discount_list.item_lookup(item).discount * prices.fetch(item) * (count / discount_list.item_lookup(item).quantity))
      else
        total += prices.fetch(item) * count
      end
    end
    total
  end

  # private

  # def basket
  #   @basket ||= Hash.new
  # end
end
