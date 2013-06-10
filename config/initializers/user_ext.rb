YmUsers::User.class_eval do

  class << self
    
    def included_with_ym_messages(base)
      included_without_ym_messages(base)
      base.send(:include, YmMessages::UserExt)
    end
    alias_method_chain :included, :ym_messages
    
  end
  
end
