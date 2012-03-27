class VanityCouponCode < ActiveRecord::Base                                                                                                                                                                    
  include RescueDbError                                                         
                                                                                
  on_db_error /vanity_coupon_codes_code_key/ do |exception, obj|                
    obj.errors[:code] << "already taken!"                                       
  end                                                                           
                                                                                
  on_db_error /vanity_coupon_codes_code_key/ do |exception, obj|                
    obj.errors[:code] << "mike sucks"                                           
  end                                                                           
                                                                                
  on_db_error /coupon_code_length/, :blah                                       
                                                                                
  private                                                                       
                                                                                
  def blah exception, obj                                                       
    obj.errors[:code] << 'fill me in idiot'                                     
  end                                                                           
end