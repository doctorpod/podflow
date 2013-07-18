require 'mail'
require 'podflow/pod_utils'

module Podflow
  class Inform
    attr_reader :subject, :recipients, :recipient_salutation, :from, :from_salutation, :template,
                :additional_text
    
    def initialize(data = {})
      @subject              = data['subject'] || 'MySubject'
      @recipients           = data['recipients'] || ['him@here.com', 'her@there.com']
      @recipient_salutation = data['recipient_salutation'] || 'TheirName'
      @from                 = data['from'] || 'me@from.com'
      @from_salutation      = data['from_salutation'] || 'MyName'
      @template             = data['template'] || 'MyInformTemplateFile'
      @additional_text      = ''
    end
    
    def generate_mail(series, episode)
      mail = Mail.new
      mail.subject = subject.chomp
      mail.body = ERB.new(PodUtils.local_template_string(template)).result(binding)
      mail.to = recipients
      mail.from = from
      mail
    end
    
    def perform(series, episode)
      mail = generate_mail(series, episode)
      STDOUT.puts "--\n#{mail}\n--"
      STDOUT.print "Action for mail ([s]end, [i]gnore, set [a]dditional text): "
      answer = STDIN.gets.chomp
      
      case answer
      when "s"
        STDOUT.puts "Sending mail..."
        mail.delivery_method :sendmail
        mail.deliver
      when "a"
        STDOUT.print "Additional text: "
        @additional_text = STDIN.gets.chomp
        perform(series, episode)
      else
        STDOUT.puts "Ignoring mail"
      end
    end
  end
end