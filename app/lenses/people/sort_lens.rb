module People
  class SortLens < ApplicationLens
    OPTIONS = %w(unit)
    I18N_KEY = "simple_form.options.user.sort"

    param_name :sort

    def render
      h.select_tag(param_name,
        h.options_for_select(OPTIONS.map { |o| [I18n.t("#{I18N_KEY}.#{o}"), o] }, value),
        prompt: I18n.t("#{I18N_KEY}.name"),
        class: "form-control",
        onchange: "this.form.submit();"
      )
    end
  end
end
