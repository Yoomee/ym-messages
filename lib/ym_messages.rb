require 'ym_core'
require "ym_messages/engine"

module YmMessages
end

Dir[File.dirname(__FILE__) + '/ym_messages/models/*.rb'].each {|file| require file }