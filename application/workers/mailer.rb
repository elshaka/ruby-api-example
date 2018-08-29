class Api
  module Workers
    class Mailer
      include Sidekiq::Worker

      def perform(message)
        Mail.deliver do
          from MAIL_USERNAME
          to message["to"]
          subject message["subject"]
          body message["body"]
        end
      end
    end
  end
end
