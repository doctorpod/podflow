module Podflow
  class Inform
    attr_reader :subject, :recipients, :from, :template
    
    def initialize(data = {})
      @subject = data['subject'] || 'MySubject'
      @recipients = data['recipients'] || ['him@here.com', 'her@there.com']
      @from = data['from'] || 'My@From'
      @template = data['template'] || 'MyTemplateFile'
    end
  end
end