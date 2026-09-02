module ApplicationHelper
  def field_class(record, attribute, base: "form-control")
    [ base, ("is-invalid" if record.errors[attribute].any?) ].compact.join(" ")
  end
end
