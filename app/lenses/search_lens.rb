class SearchLens < ApplicationLens
  param_name :search

  def render
    h.text_field_tag(param_name, value, placeholder: "Search...", class: "form-control")
  end
end
