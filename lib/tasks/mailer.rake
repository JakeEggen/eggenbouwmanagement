namespace :mailer do
  desc "Show Action Mailer delivery setup without secrets"
  task status: :environment do
    method = ActionMailer::Base.delivery_method
    settings = ActionMailer::Base.smtp_settings || {}

    puts "delivery_method: #{method}"
    puts "from: #{ApplicationMailer.default[:from]}"
    puts "to: #{ContactInquiryMailer.default[:to]}"
    puts "resend_api_key: #{ENV['RESEND_API_KEY'].present? ? 'set' : 'missing'}"

    if method == :smtp
      puts "smtp_address: #{settings[:address]}"
      puts "smtp_port: #{settings[:port]}"
    elsif method == :file
      puts "file_location: #{ActionMailer::Base.file_settings[:location]}"
      puts "Mails stay local until RESEND_API_KEY is set and the server is restarted."
    end
  end
end
