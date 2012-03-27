module RescueDbError                                                            
  extend ActiveSupport::Concern                                                 
                                                                                
  included do                                                                   
    class_attribute :error_matchers                                             
    self.error_matchers = []                                                    
  end                                                                           
      
  # Is overriding save like this bad? Better way to do it?                                                                          
  def save *args, &block                                                        
    super                                                                       
  rescue                                                                        
    self.class.error_matchers.each do |matcher, callback|                       
      if $!.message =~ matcher                                                  
        if callback.kind_of?(Proc)                                              
          callback.call($!, self)                                               
        else                                                                    
          send(callback, $!, self)                                              
        end                                                                     
      end                                                                       
    end                                                                         
  end                                                                           
                                                                                
  module ClassMethods                                                           
    def on_db_error matcher, callback_method=nil, &block                        
      self.error_matchers << [matcher, callback_method || block]                
    end                                                                         
  end                                                                           
end