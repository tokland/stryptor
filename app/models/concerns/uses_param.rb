module UsesParam
  extend ActiveSupport::Concern

  included do
    cattr_accessor :uses_param_attribute
  end  
  
  def to_param
    send(self.class.uses_param_attribute)
  end
  
  module ClassMethods
    def uses_param(attribute)
      self.uses_param_attribute = attribute
    end
      
    def find_by_param!(value)
      find_by!(uses_param_attribute => value)
    end
  end
end
