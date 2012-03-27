module RescueDbError                                                            
  extend ActiveSupport::Concern                                                 
                                                                                
  ErrorMatch = Struct.new(:regex, :callback)                                    
                                                                                
  included do                                                                   
    class_attribute :error_matchers                                             
    self.error_matchers = []                                                    
  end                                                                           
                                                                                
  # Is overriding ActiveRecord::Base#save bad? Better way to do it?             
  def save *args, &block                                                        
    super                                                                       
  rescue ActiveRecord::StatementInvalid => e                                    
    self.class.error_matchers.each do |match|                                   
      if e.message =~ match.regex                                               
        if match.callback.kind_of?(Proc)                                        
          match.callback.call(e, self)                                          
        else                                                                    
          send(match.callback, e, self)                                         
        end                                                                     
      end                                                                       
    end                                                                         
  end                                                                           
                                                                                
  module ClassMethods                                                           
    def on_db_error matcher, callback_method=nil, &block                        
      self.error_matchers << ErrorMatch.new(matcher, callback_method || block)  
    end                                                                         
  end                                                                           
end