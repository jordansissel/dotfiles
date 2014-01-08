require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history" 
IRB.conf[:PROMPT_MODE]  = :SIMPLE

# Just for Rails...
if ENV['IRB_PROMPT'] and ENV['RAILS_ENV']
  IRB.conf[:PROMPT] ||= {}
  IRB.conf[:PROMPT][:CUSTOM] = {
    :PROMPT_I => "#{ENV['IRB_PROMPT']}/irb> ",
    :PROMPT_S => "#{ENV['IRB_PROMPT']}/irb* ",
    :PROMPT_C => "#{ENV['IRB_PROMPT']}/irb? ",
    :RETURN   => "=> %s\n" 
  }
  IRB.conf[:PROMPT_MODE] = :CUSTOM

  # Called after the irb session is initialized and Rails has
  # been loaded (props: Mike Clark).
  IRB.conf[:IRB_RC] = Proc.new do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.instance_eval { alias :[] :find }
  end
end
