class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "noreply@eggenbouwmanagement.nl")
  layout "mailer"
end
