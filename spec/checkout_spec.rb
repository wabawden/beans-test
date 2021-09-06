require 'spec_helper'
require 'checkout'
require 'discount'
require 'discount_list'

RSpec.describe Checkout do
  describe '#total' do
    let(:discount_list) { DiscountList.new }
    before do
      apple_discount = Discount.new(:apple, 2, 1)
      pear_discount = Discount.new(:pear, 2, 1)
      banana_discount = Discount.new(:banana, 1, 0.5)
      mango_discount = Discount.new(:mango, 3, 1)
      pineapple_discount = Discount.new(:pineapple, 1, 0.5, 1)
      kiwi_discount = Discount.new(:kiwi, 1, 0.5, 3)
      discount_list.add(apple_discount)
      discount_list.add(pear_discount)
      discount_list.add(banana_discount)
      discount_list.add(mango_discount)
      discount_list.add(pineapple_discount)
      discount_list.add(kiwi_discount)
    end
    subject(:total) { checkout.total }

    let(:checkout) { Checkout.new(pricing_rules, discount_list) }
    let(:pricing_rules) {
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200,
        kiwi: 100
      }
    }

    context 'when no offers apply' do
      before do
        checkout.scan(:apple)
        checkout.scan(:orange)
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      before do
        checkout.scan(:apple)
        checkout.scan(:apple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there are other items' do
        before do
          checkout.scan(:orange)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a two for 1 applies on pears' do
      before do
        checkout.scan(:pear)
        checkout.scan(:pear)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.scan(:banana)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.scan(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      before do
        checkout.scan(:pineapple)
        checkout.scan(:pineapple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a half price offer applies on kiwis restricted to 3 per customer' do
        before do
          4.times { checkout.scan(:kiwi) }
        end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(250)
      end
    end

    context 'when a buy 3 get 1 free offer applies to mangos' do
      before do
        4.times { checkout.scan(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end
  end
end
