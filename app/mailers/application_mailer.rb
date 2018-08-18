# frozen_string_literal: true

# Root mailer for all mailers.
class ApplicationMailer < ActionMailer::Base
  include SubdomainSettable
  default from: Settings.email.from

  protected

  attr_reader :community

  # Overrides default mail method.
  #
  # Allows email addresses, users, or households in the to field.
  # It is up to the mailer system, not the job system, to figure out how to send mail to a household or user,
  # and whether users have opted out of a given type of mail.
  # Mails to households should be addressed to all the household users, not to each user separately.
  #
  # Also filters out fake users so that emails are not sent to their fake addresses.
  #
  # If self.community returns a non-nil value, sets the appropriate subdomain.
  def mail(params)
    params[:to] = resolve_recipients(params[:to])
    return if params[:to].empty?
    raise "@community must be set or community method overridden to send mail" unless community
    with_community_subdomain(community) do
      super
    end
  end

  private

  def resolve_recipients(recipients)
    Array.wrap(recipients).map do |recipient|
      if recipient.is_a?(User)
        resolve_user_email(recipient)
      elsif recipient.is_a?(Household)
        recipient.users.reject(&:fake?).map(&:email)
      else
        recipient
      end
    end.flatten.compact
  end

  def resolve_user_email(user)
    if user.fake?
      nil
    elsif user.child? && user.email.blank?
      user.guardians.map(&:email)
    else
      user.email
    end
  end
end
