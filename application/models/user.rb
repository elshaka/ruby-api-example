require 'lib/abilities'

class Api
  module Models
    class User < Sequel::Model(:users)
      include AbilityList::Helpers

      def abilities
        @abilities ||= Abilities.new(self)
      end

      def full_name
        "#{self.first_name} #{self.last_name}"
      end

      def after_create
        Workers::Mailer.perform_async({
          "to" => self.email,
          "subject" => 'Welcome to ruby-api-example',
          "body" => 'Yay!'
        })
      end

      def before_update
        Workers::Mailer.perform_async({
          "to" => self.email,
          "subject" => 'Password updated on ruby-api-example',
          "body" => 'Your password has been updated'
        }) if modified? :password
      end
    end
  end
end
