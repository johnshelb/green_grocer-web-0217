def consolidate_cart(item_array)
  result={}
  item_array.each do |item_hash|
    item_hash.each do |item,attributes_hash|
      if attributes_hash.keys.include?(:count)
        attributes_hash[:count]+=1
      else
        attributes_hash[:count]=1
      end
      result[item]=attributes_hash
    end
  end
  result
end

def apply_coupons(cart_hash, coupons_array)
  result={}
  cart_hash.keys.each do |item|
    if coupons_array==[]
      result[item]=cart_hash[item]
    else
      coup_ct=0
      coupons_array.each do |coupon_hash|
          if  coupon_hash.values[0]==item
            if coupon_hash[:num]<=cart_hash[item][:count]
              coup_ct+=1
              cart_hash[item][:count]-=coupon_hash[:num]
              result[item]=cart_hash[item]
              result["#{item} W/COUPON"]=result[item].dup
              result["#{item} W/COUPON"][:count]=coup_ct
              result["#{item} W/COUPON"][:price]=coupon_hash[:cost]
            end
          else
            result[item]=cart_hash[item]
          end
      end
    end
  end
    result
end

def apply_clearance(cart)
  cart.each do |item,attributes_hash|
    #binding.pry
    if cart[item][:clearance]
      cart[item][:price]=(0.8*cart[item][:price]).round(2)
    end
  end
end

def checkout(cart, coupons)
 total_cost=0
  final_cart=consolidate_cart(cart)
  post_coupons=apply_coupons(final_cart,coupons)
  post_clearance=apply_clearance(post_coupons)
  post_clearance.each do |item, attributes_hash|
    attributes_hash.each do |attribute,value|
      if attribute==:price
        total_cost+=(attributes_hash[attribute]*attributes_hash[:count]).round(2)
      end
  end
end
if total_cost>100
  final_cost=(total_cost * 0.9).round(2)
else
  final_cost=total_cost
end
final_cost
end
