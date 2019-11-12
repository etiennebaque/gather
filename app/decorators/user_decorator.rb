# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  def greeting
    I18n.t("users.greeting", name: name)
  end

  def link(highlight: nil, show_cmty_if_foreign: false, show_inactive: false)
    name = full_name(show_inactive: show_inactive)
    name = "#{name} (#{community_name})" if show_cmty_if_foreign && community != h.current_community
    name = h.content_tag(:mark, name) if id == highlight.to_i
    h.link_to(name, h.user_url(object), class: "user-link")
  end

  def full_name(show_inactive: false)
    suffix = active? || !show_inactive ? "" : " (Inactive)"
    "#{first_name} #{last_name}#{suffix}"
  end

  def name_with_inactive
    full_name(show_inactive: true)
  end

  def first_name_with_inactive
    "#{first_name}#{active? ? '' : ' (Inactive)'}"
  end

  def birthday_formatted
    return nil unless object.birthday?
    l(birthday.date, format: birthday.format)
  end

  def joined_on
    l(object.joined_on)
  end

  def mobile_phone
    phone(:mobile).formatted
  end

  def home_phone
    phone(:home).formatted
  end

  def work_phone
    phone(:work).formatted
  end

  def phone_tags
    phones.map { |p| h.content_tag(:div, p.formatted(kind_abbrv: true), class: "phone") }.reduce(:<<)
  end

  def preferred_contact
    return nil if object.preferred_contact.nil?
    I18n.t("simple_form.options.user.preferred_contact.#{object.preferred_contact}")
  end

  def unit_num_and_suffix_with_hash
    unit_num.nil? ? nil : "##{unit_num_and_suffix}"
  end

  def unit_link
    unit_num.nil? ? nil : h.link_to("##{unit_num_and_suffix}", household)
  end

  def first_phone_link
    no_phones? ? nil : h.phone_link(phones.first, kind_abbrv: true)
  end

  def unit_and_phone
    [unit_link, first_phone_link].compact.reduce(&sep(" &bull; "))
  end

  def tr_classes
    active? ? "" : "inactive"
  end

  def email_link
    email.blank? ? "" : h.link_to(email, "mailto:#{email}", class: long_email_class)
  end

  def long_email_class
    email.size > 25 ? "long-email" : ""
  end

  def preferred_contact_icon
    case object.preferred_contact
    when "email" then "fa-envelope"
    when "text" then "fa-comment"
    when "phone" then "fa-phone"
    end
  end

  def preferred_contact_tooltip
    h.t("users.preferred_contact_tooltip", method: preferred_contact)
  end

  def photo_if_permitted(format)
    h.image_tag(h.policy(object).show_photo? ? photo.url(format) : "missing/users/#{format}.png",
                class: "photo")
  end

  def show_action_link_set
    ActionLinkSet.new(
      ActionLink.new(object, :update_info, icon: "pencil", path: h.edit_user_path(object)),
      ActionLink.new(object, :update_photo, icon: "camera", path: h.edit_user_path(object)),
      ActionLink.new(object, :impersonate, icon: "user-circle-o", path: h.impersonate_user_path(object),
                                           method: :post),
      ActionLink.new(object, :invite,
                     icon: "life-ring",
                     method: :post,
                     path: h.people_sign_in_invitations_path(object, "to_invite[]": id),
                     confirm: {name: name},
                     permitted: People::SignInInvitationsPolicy.new(h.current_user, community).create?)
    )
  end

  def edit_action_link_set
    ActionLinkSet.new(
      ActionLink.new(object, :deactivate, icon: "times-circle", path: h.deactivate_user_path(object),
                                          method: :put, confirm: {name: name}),
      ActionLink.new(object, :destroy, icon: "trash", path: h.user_path(object), method: :delete,
                                       confirm: {name: name})
    )
  end
end
