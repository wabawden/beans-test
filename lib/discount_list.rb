class DiscountList
    attr_accessor :discounts

    def initialize(discounts = [])
        @discounts = discounts
    end

    def add(discount)
        @discounts.push(discount)
    end

    def remove(discount)
        @discounts.delete(discount)
    end

    def show
        @discounts.each{|discount| discount.show }
    end
end